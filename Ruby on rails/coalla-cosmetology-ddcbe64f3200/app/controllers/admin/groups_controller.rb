# Контроллер раздела "Группы"
# @see app/views/admin/groups
# @see app/views/admin/course_notices/new.haml
# @see app/assets/javascripts/admin/group_subscriptions.js.coffee
module Admin
  class GroupsController < AdminController
    before_action only: %i(edit update destroy) do
      @group = Group.find(params[:id])
      force_update_current_shop_id(@group.shop_id)
    end

    with_options except: :info do
      set_current_shop_for_model(Group)
      set_current_shop_for_model(Course)
      set_current_shop_for_model(Instructor)
    end

    authorize_resource

    def index
      @q = Group.ransack(params[:q])
      @groups = @q.result.ascending_name.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @group = Group.new
    end

    def create
      @group = Group.new(group_params)
      if @group.save
        redirect_to edit_admin_group_path(@group)
      else
        render :new
      end
    end

    def edit; end

    def update
      @group.update(group_params)
      render :edit
    end

    def destroy
      @group.destroy
      redirect_to action: :index
    end

    def search
      course = Course.find(params[:course_id])
      if params[:q].present?
        groups = course.groups.where('title ilike :q', q: "%#{params[:q]}%").order(:title)
      else
        groups = course.groups.order(:title)
      end
      render json: groups.map { |g| { id: g.id, name: g.title, html: render_to_string(partial: 'admin/course_notices/group', locals: { group: g }) } }
    end

    def info
      group = Group.find(params[:id])
      render json: { course_name: group.course_name,
                     start_time: group.start_time.try(:strftime, '%H:%M'),
                     end_time: group.end_time.try(:strftime, '%H:%M'),
                     begin_on: group.begin_on.try(:strftime, '%d.%m.%Y'),
                     end_on: group.end_on.try(:strftime, '%d.%m.%Y') }
    end

    def clone
      _group = Group.find(params[:id])
      @group = _group.amoeba_dup
      render :new
    end

    private

    def group_params
      { shift_work_on: nil, week_days: [] }.merge(params.require(:group).permit!)
    end
  end
end