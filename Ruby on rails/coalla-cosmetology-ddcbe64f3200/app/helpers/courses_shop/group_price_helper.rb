module CoursesShop
  module GroupPriceHelper

    def tooltip_text(group_price)
      if group_price.bank_installment?
        "Первый взнос - оплачиваем сейчас, остаток - оплачиваем банку равными платежами в срок #{months_count_text(group_price.bank_installment_months)}.".html_safe
      else
        'Первый взнос&nbsp;&mdash; оплачиваем сейчас, остальные взносы&nbsp;&mdash; потом в&nbsp;рамках срока обучения'.html_safe
      end
    end

    def months_count_text(count)
      "#{count} #{Russian.p(count, 'месяц', 'месяца', 'месяцев')}"
    end

    def payments_count_text(count)
      "#{count} #{Russian.p(count, 'платеж', 'платежа', 'платежей')}"
    end

  end
end