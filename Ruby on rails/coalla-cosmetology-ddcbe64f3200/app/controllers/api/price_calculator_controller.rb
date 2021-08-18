module Api
  class PriceCalculatorController < Api::ApplicationController
    def calculate
      group_price = GroupPrice.find(params[:group_price_id])
      discount = Discount.find_by(id: params[:discount_id])

      price = (discount.present? ? group_price.amount - discount.calculate(group_price.amount) : group_price.amount).to_i

      render json: {price: price}
    end
  end
end