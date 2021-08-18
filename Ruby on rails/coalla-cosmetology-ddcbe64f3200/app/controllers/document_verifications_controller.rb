class DocumentVerificationsController < ApplicationController
  before_action do
    @tutorial = Lookup.find_by(code: 'verification_tutorial')
  end

  def show
  end

  def create
    @number = params[:number]

    if @number.blank?
      redirect_to document_verification_path
      return
    end

    @subscription_document = SubscriptionDocument
                                 .where.not(issued_at: nil)
                                 .where(registration_number: @number)
                                 .first

    render :show
  end
end