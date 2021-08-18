# Генерация заданий при выборе типа задания и бланка ведомости
# @see app/assets/javascripts/admin/works.js.coffee
module Admin
  class ExercisesController < AdminController
    before_action do
      authorize! :manage, Work
    end

    def create
      @work = Work.new(params.require(:work).permit(:type, :form_sheet, :hairdresser_form_sheet))
      render json: { html: render_to_string(partial: 'admin/works/exercises') }
    end
  end
end