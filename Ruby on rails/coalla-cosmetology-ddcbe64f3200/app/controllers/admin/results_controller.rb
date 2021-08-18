# Управление результатами студента
# @see app/views/admin/my_students
module Admin
  class ResultsController < AdminController
    load_and_authorize_resource

    def show
      render json: {result: render_to_string(partial: 'admin/my_students/result', locals: {result: @result})}
    end

    def update
      @result.mark_result!(mark: params[:mark], instructor: current_user)
      render json: {mark: @result.mark}
    end
  end
end