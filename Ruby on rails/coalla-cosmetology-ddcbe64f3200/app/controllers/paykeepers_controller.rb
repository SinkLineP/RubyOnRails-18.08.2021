class PaykeepersController < ActionController::Base

  skip_before_filter :verify_authenticity_token

  def result
    handler = Paykeeper::Handler.new(params)
    result = handler.process_payment!

    if result
      logger.info('Payment approved!')
      render json: result
    else
      logger.info('Payment not approved!')
      render nothing: true
    end
  end

  def success
    redirect_to courses_shop_profile_courses_path
  end

  def failed
    redirect_to courses_shop_profile_courses_path
  end

end
