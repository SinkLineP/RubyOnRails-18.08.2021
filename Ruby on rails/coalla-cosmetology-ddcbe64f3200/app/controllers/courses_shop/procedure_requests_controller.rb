module CoursesShop
  class ProcedureRequestsController < BaseController
    def create
      procedure_request = ::ProcedureRequest.new(procedure_request_params)
      if procedure_request.save
        CoursesShop::CoursesShopMailer.procedure_request_to_user(procedure_request).deliver!
        CoursesShop::CoursesShopMailer.procedure_request_to_admin(procedure_request).deliver!
        render json: {
            popup: {
                title: 'Поздравляем!<br>Вы успешно записаны'.html_safe,
                text: ty('Наш менеджер свяжется с&nbsp;вами в&nbsp;самое ближайшее время для уточнения деталей визита.')},
            resetForm: true,
            fbEvent: ('fbLead' if current_shop.barbershop?)
        }
      else
        render json: {errors: procedure_request.errors}
      end
    end

    private

    def procedure_request_params
      params.require(:procedure_request).permit(:email, :phone, :name, :cosmetology_procedure_id)
    end
  end
end