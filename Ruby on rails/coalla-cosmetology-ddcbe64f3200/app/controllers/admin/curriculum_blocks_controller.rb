# Контролле раздела "Учебный план"
# @see app/views/admin/curriculum_blocks
# @see app/views/admin/course_content/edit.haml
module Admin
  class CurriculumBlocksController < AdminController
    load_and_authorize_resource

    before_action only: %i(edit update destroy) do
      force_update_current_shop_id(@curriculum_block.shop_id)
    end

    set_current_shop_for_model(CurriculumBlock)
    set_current_shop_for_model(Course)

    def index
      @curriculum_blocks = CurriculumBlock.order(created_at: :desc).paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      save_and_responce
    end

    def update
      @curriculum_block.assign_attributes(curriculum_block_params)
      save_and_responce
    end

    def destroy
      @curriculum_block.destroy
      redirect_to admin_curriculum_blocks_path
    end

    def list
      curriculum_blocks = CurriculumBlock.alphabetical_order

      if params[:term].present?
        curriculum_blocks = curriculum_blocks.where('title ilike ?', "%#{params[:term]}%")
      end

      render json: curriculum_blocks.first(LIST_SIZE).map { |block| {value: block.title, id: block.id} }
    end

    protected

    def save_and_responce
      if @curriculum_block.save
        redirect_to edit_admin_curriculum_block_path(@curriculum_block)
        return
      end

      render :edit
    end

    def curriculum_block_params
      params.require(:curriculum_block).permit!
    end
  end
end