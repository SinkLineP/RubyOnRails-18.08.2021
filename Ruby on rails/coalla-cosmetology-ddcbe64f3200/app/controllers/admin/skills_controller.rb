# Контроллер раздела "Ключевые навыки"
# @see app/views/admin/skills/
module Admin
  class SkillsController < AdminController
    load_and_authorize_resource

    before_action :store_path_history

    def index
      @skills = Skill.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      if @skill.save
        redirect_to last_uri
      else
        render :new
      end
    end

    def update
      @skill.assign_attributes(skill_params)
      if @skill.save
        redirect_to last_uri
      else
        render :edit
      end
    end

    def destroy
      @skill.destroy
      redirect_to last_uri
    end

    def list
      skills = Skill.alphabetical_order

      if params[:term].present?
        skills = skills.where('name ilike ?', "%#{params[:term]}%")
      end

      render json: skills.first(LIST_SIZE).map { |skill| {value: skill.name, id: skill.id} }
    end

    private

    def skill_params
      params.require(:skill).permit!
    end

  end
end