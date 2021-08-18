class VacanciesController < ApplicationController
  before_action :authenticate_user!

  before_action do
    authorize! :index, :vacancies
  end

  def index
    @vacancy_groups = Vacancy.includes(:vacancy_group).order('vacancy_groups.created_at desc').ordered.group_by(&:vacancy_group)
  end

  def show_content
    @vacancy = Vacancy.find(params[:vacancy_id])
  end

end