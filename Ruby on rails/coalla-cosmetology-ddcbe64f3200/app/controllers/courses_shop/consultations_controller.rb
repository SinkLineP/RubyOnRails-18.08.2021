module CoursesShop
  class ConsultationsController < BaseController
    def create
      course = Course.find(params[:course_id])
      consultation = Consultation.new(consultation_params)
      consultation.assign_attributes(course: course)

      unless consultation.save
        render json: {errors: consultation.errors}
        return
      end

      consultation.create_task_and_notify
      render json: {
          popup: {
              title: 'Поздравляем!<br>Вы успешно записаны'.html_safe,
              text: ty("Консультация назначена на #{Russian.strftime(consultation.date, '%d %B (%A)')} #{consultation.formatted_time}. Наш менеджер свяжется с вами в самое ближайшее время для уточнения деталей визита.")},
          resetForm: true,
          fbEvent: ('fbLead' if current_shop.barbershop?),
          dataLayer: { event: 'consultform' }
      }
    end

    private

    def consultation_params
      params.require(:consultation).permit(:name, :email, :phone, used_time_attributes: [:date, :time])
    end
  end
end
