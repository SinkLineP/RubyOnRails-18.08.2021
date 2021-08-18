module CoursesShop
  class UserQuestionsController < BaseController
    def create
      user_question = ::UserQuestion.new(user_question_params)
      if user_question.save
        Delayed::Job.enqueue(Amocrm::Operations::CreateTasks.new(3779901,
                                                                 User.find_by(email: user_question.email).try(:amocrm_id),
                                                                 nil, user_question.user_name, user_question.email, nil,
                                                                 "ВОПРОС ОТ ПОЛЬЗОВАТЕЛЯ. #{user_question.question}"),
                             queue: :amocrm)

        render json: {
            popup: {
                title: 'Спасибо!<br>Ваш вопрос очень важен для нас'.html_safe,
                text: ty('Мы ответим на ваш вопрос в течение трех рабочих дней. Если вопрос срочный, рекомендуем вам позвонить в институт.')},
            resetForm: true,
            fbEvent: ('fbLead' if current_shop.barbershop?),
            dataLayer: { event: 'questionform' }
        }
      else
        render json: { errors: user_question.errors }
      end
    end



    def user_question_params
      params.require(:user_question).permit(:email, :question, :user_name)
    end
  end
end
