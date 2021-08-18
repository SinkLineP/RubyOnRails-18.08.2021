module CoursesShop
  module CoursesHelper
    def show_configurator_on_main?
      Lookup.configurator.try(:value) == '1'
    end

    def promotion_class(course)
      course.badge.present? ? 'has-promotion-flag' : ''
    end

    def promotion_data(course)
      course.badge.present? ? {'promotion-caption' => course.badge} : {}
    end

    def payment_state(status)
      {
          'pending_payment' => 'warning',
          'debts' => 'error',
          'full_paid' => 'success',
          'archive' => 'archive',
          'payment_not_completed' => 'warning'
      }[status]
    end

    def payment_state_text(status)
      t("payment_state_text.#{status}")
    end

    def courses_count(count)
      "#{count} #{Russian.p(count, 'курс', 'курса', 'курсов')}"
    end

  end
end