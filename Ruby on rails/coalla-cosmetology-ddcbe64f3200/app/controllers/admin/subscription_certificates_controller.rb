# Справки для сделки
# @see app/views/admin/subscription_certificates
# @see app/views/admin/group_subscriptions
module Admin
  class SubscriptionCertificatesController < AdminController
    load_and_authorize_resource :group_subscription

    def show
      load_documents
    end

    def update
      @group_subscription.assign_attributes(group_subscription_params)

      if @group_subscription.valid?
        education_certificate = @group_subscription.education_certificate || @group_subscription.build_education_certificate
        education_certificate.generate!(with_print: education_certificate.with_print)
        redirect_to admin_group_subscription_certificate_path(@group_subscription)
        return
      end
      load_documents
      render :show
    end

    protected

    def group_subscription_params
      params.require(:group_subscription).permit!
    end

    private

    def load_documents
      @education_certificate = @group_subscription.education_certificate || @group_subscription.build_education_certificate(created_on: Date.today)
    end
  end
end