module DiscountsHelper
  def discount_type_text(discount)
    if discount.percent?
      '%'
    elsif discount.composite?
      'Составная'
    else
      'Абсолютное значение'
    end
  end
end