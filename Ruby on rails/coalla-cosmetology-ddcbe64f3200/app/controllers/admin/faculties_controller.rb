# Контроллер раздела "Факультеты"
# @see app/views/admin/faculties
# @see app/views/admin/graduates/_form.html.haml
# @see app/views/admin/instructors/_form.html.haml
module Admin
  class FacultiesController < ResourceController
    set_current_shop_for_model(Faculty)

    def list
      faculties = Faculty.ordered

      if params[:term].present?
        faculties = faculties.where('title ilike ?', "%#{params[:term]}%")
      end

      render json: faculties.first(LIST_SIZE).map { |faculty| {value: faculty.title, id: faculty.id} }
    end
  end
end