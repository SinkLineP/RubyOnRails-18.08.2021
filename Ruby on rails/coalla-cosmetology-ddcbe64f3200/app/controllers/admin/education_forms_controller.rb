# Контроллер раздела "Формы обучения"
# @see app/views/admin/education_forms
module Admin
  class EducationFormsController < AdminController
    authorize_resource

    def index
      @education_forms = EducationForm.order(:created_at)
    end
  end
end