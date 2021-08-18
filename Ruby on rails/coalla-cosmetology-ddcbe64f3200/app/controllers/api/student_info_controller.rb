module Api
  class StudentInfoController < Api::ApplicationController
    def list
      @student = Student.find_by(amocrm_id: params[:amocrm_id]) if params[:amocrm_id].present?
      @education_levels = EducationLevel.ordered
    end
  end
end
