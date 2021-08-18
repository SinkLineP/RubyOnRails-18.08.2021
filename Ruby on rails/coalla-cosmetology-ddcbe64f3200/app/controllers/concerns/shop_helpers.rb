module ShopHelpers

  def set_current_shop
    return unless current_shop
    SharedModels.set_current_shop(current_shop.id)
  end

  def unset_current_shop
    SharedModels.unset_current_shop
  end

  def current_shop
    @current_shop ||= Shop.find_by_request_or_default(request)
  end

end