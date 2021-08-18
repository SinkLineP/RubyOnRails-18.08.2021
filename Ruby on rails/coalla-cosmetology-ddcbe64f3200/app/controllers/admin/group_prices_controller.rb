# Варианты оплаты для группы
# @see app/assets/javascripts/admin/group_subscriptions.js.coffee
# @see app/views/admin/group_subscriptions/_form.html.haml
module Admin
  class GroupPricesController < AdminController
    load_and_authorize_resource :group

    def index
      prices = @group.prices.where(education_form_id: params[:education_form_id])
      render json: prices.as_json(only: :id, methods: :display_text)
    end
  end
end