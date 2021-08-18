module Api
  class GroupPricesController < Api::ApplicationController
    def list
      @group_prices = GroupPrice
                          .where(group_id: params[:group_id], education_form_id: params[:education_form_id])
                          .ordered
    end
  end
end