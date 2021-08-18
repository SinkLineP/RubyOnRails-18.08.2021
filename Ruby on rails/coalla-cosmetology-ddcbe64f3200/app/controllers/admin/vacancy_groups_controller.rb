# Контроллер раздела "Группы вакансий"
# @see app/views/admin/vacancy_groups
module Admin
  class VacancyGroupsController < AdminController
    load_and_authorize_resource

    def index
      @vacancy_groups = VacancyGroup.order(created_at: :desc).paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      save_and_responce
    end

    def update
      @vacancy_group.assign_attributes(vacancy_group_params)
      save_and_responce
    end

    def destroy
      @vacancy_group.destroy
      redirect_to admin_vacancy_groups_path
    end

    protected

    def save_and_responce
      if @vacancy_group.save
        redirect_to edit_admin_vacancy_group_path(@vacancy_group)
      else
        render @vacancy_group.persisted? ? :edit : :new
      end
    end

    def vacancy_group_params
      params.require(:vacancy_group).permit!
    end
  end
end