module MoneyHelper

  def format_money(amount, unit = "руб.")
    number_to_currency(amount, precision: 0, unit: unit)
  end

  def format_money_nbsp(amount, unit = "руб.")
    number_to_currency(amount, precision: 0, delimiter: '&nbsp'.html_safe, format: '%n&nbsp%u'.html_safe, unit: unit.html_safe)
  end

  def format_money_without_wrap(amount, unit = "руб.")
    number_to_currency(amount, precision: 2, delimiter: '', format: '%n %u'.html_safe, unit: unit)
  end

end