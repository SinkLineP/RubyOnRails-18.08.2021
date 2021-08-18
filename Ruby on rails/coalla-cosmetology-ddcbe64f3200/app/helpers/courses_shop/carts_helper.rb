module CoursesShop
  module CartsHelper

    def discount_value_text(discount)
      if discount.standard?
        "- #{discount.value.to_i} Р"
      elsif discount.percent?
        "- #{discount.value.to_i}%"
      end
    end

    def popup_title_text(order)
      subscriptions = order.current_group_subscriptions
      payment_type = order.payment_type
      result = if subscriptions.count > 1
                 subscriptions.map { |subscription| "&laquo;#{subscription.course_name}&raquo;" }.join(', ').html_safe
               else
                 subscription = subscriptions.first
                 "&laquo;#{subscription.course_name}&raquo; <br> #{ subscription.group.fake ? '' : education_period_short_with_schedule(subscription.group)+', практика '+education_period(subscription.group) }".html_safe
               end
      "#{result}#{t("payment_type.#{payment_type}")}".html_safe
    end

    def popup_description_text(order)
      payment_type = order.payment_type
      case payment_type
        when 'cash'
          "Внимание! Место в группе закрепляется за вами только после оплаты - рекомендуем подъехать к нам&nbsp;<a href='#{courses_shop_contacts_path}'>в офис</a> и оплатить обучение в течение двух дней после записи.".html_safe
        when 'receipt'
          "Внимание! Место в группе закрепляется за вами только после оплаты - рекомендуем оплатить обучение в течение двух дней после записи и сразу же загрузить скан квитанции с отметкой банка об оплате в&nbsp;<a href='#{courses_shop_profile_documents_path}'>личном кабинете</a> или прислать на&nbsp;почту: <a href='mailto:info@cosmeticru.com'>info@cosmeticru.com</a>".html_safe
        when 'terminal'
          "Внимание! Место в группе закрепляется за вами только после оплаты - рекомендуем оплатить обучение в течение двух дней после записи и сразу же загрузить скан чека из терминала об оплате в&nbsp;<a href='#{courses_shop_profile_documents_path}'>личном кабинете</a> или прислать на&nbsp;почту: <a href='mailto:info@cosmeticru.com'>info@cosmeticru.com</a>".html_safe
      end
    end
  end
end