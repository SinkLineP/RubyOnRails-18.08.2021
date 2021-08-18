module CoursesShop
  class CallbacksController < BaseController
    include AjaxRequestsOnly
    include PopupTexts

    layout false

    before_action :ajax_requests_only

    def send_form_data
      model = params[:call_me] ? CallParams : QuestionParams
      form_data = model.new(params[:data].permit!)
      if form_data.invalid?
        render json: { errors: form_data.errors }
        return
      end
      if params[:call_me]
        Callbacks::DataProcessor.enqueue(form_data.attributes.merge(roistat: cookies[:roistat_visit],
                                                                    roistat_marker: cookies[:roistat_marker],
                                                                    shop_id: current_shop.id))
      else
        Amocrm::Operations::CreateDefaultSubscription.new(email: form_data.email,
                                                          name: form_data.name,
                                                          message: form_data.question,
                                                          roistat: cookies[:roistat_visit],
                                                          roistat_marker: cookies[:roistat_marker],
                                                          phone_number: form_data.phone,
                                                          shop: current_shop).perform
      end
      render json: {
        popup: { title: ty(popup_title.html_safe), text: ty(popup_text.html_safe) },
        resetForm: true,
        fbEvent: ('fbLead' if current_shop.barbershop?),
        dataLayer: { event: params[:call_me] ? 'callbackform' : 'feedbackform'}
      }
    end
  end
end
