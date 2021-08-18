# Контроллер раздела "Блоки"
# @see app/views/admin/blocks
module Admin
  class BlocksController < AdminController
    before_action only: %i(edit clone update) do
      @block = Block.find(params[:id])
      force_update_current_shop_id(@block.shop_id)
    end

    set_current_shop_for_model(Block)
    set_current_shop_for_model(Course)

    authorize_resource

    def index
      @blocks = Block.ordered
    end

    def new
      @block = Block.new(course_id: params[:course_id])
      gon.block = @block.to_backbone
      gon.lectures = @block.lectures.map(&:to_backbone)
    end

    def create
      block_ids = block_params.delete(:block_ids)
      if block_ids.present?
        @block = Block.new(block_params)
        if @block.save
          block_ids.each{ |block_id| Delayed::Job.enqueue(CopyBlockJob.new(block_id, @block.id)) }
          render json: { status: "ok" }
        else
          render json: { error: @block.errors.full_messages.join("\n") }
        end
      else
        @block = Block.new(block_params)
        apply_commit_action
      end
    end

    def edit
      gon.block = @block.to_backbone
      gon.lectures = @block.lectures.map(&:to_backbone)
    end

    def update
      @block.assign_attributes(block_params)
      apply_commit_action
    end

    def clone
      Delayed::Job.enqueue(BlockCloningJob.new(@block.id))
      render json: { status: 'ok' }
    end

    def list
      blocks = Block.ordered

      if params[:term].present?
        blocks = blocks.where('name ilike ?', "%#{params[:term]}%")
      end

      render json: blocks.first(LIST_SIZE).map { |block| { value: block.name, id: block.id, link: edit_admin_block_path(block) } }
    end

    protected

    def preview
      @course = @block.course || @block.courses.first
      @lecture = Lecture.find_by(id: params[:extras][:lecture_id]) if params[:extras][:lecture_id].present?
      @lecture ||= @block.try(:lectures).try(:last)
      @preview_mode = true
      dashboard_mode
      preview = render_to_string('courses/show', layout: 'user')
      render json: { preview: preview }
    end

    def save
      if @block.save
        render json: { redirect_url: edit_admin_block_path(@block) }
      else
        render json: { error: @block.errors.full_messages.join(', ') }
      end
    end

    def block_params
      params.permit![:block].tap do |block_params|
        block_params[:lectures_attributes] = (params[:lectures_attributes] || [])
        block_params[:course_id] = params[:course_id]

        block_params[:lectures_attributes].each do |lectures_attributes|
          lectures_attributes.delete_if do |attribute|
            Lecture::FILTERED_ATTRIBUTES.include?(attribute)
          end
        end

        block_params[:lectures_attributes].flat_map { |lectures_attributes| lectures_attributes[:materials_attributes] }.each do |materials_attributes|
          next if materials_attributes.blank?
          materials_attributes.delete_if do |attribute|
            Material::FILTERED_ATTRIBUTES.include?(attribute)
          end
        end
      end
    end

  end
end