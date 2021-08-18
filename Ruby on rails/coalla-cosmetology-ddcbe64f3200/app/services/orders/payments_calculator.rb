module Orders
  class PaymentsCalculator
    def initialize(order)
      @order = order
    end

    def recalculate
      discounts_for_courses = {}
      apply_automatic_discounts(discounts_for_courses)
      apply_promo_code(discounts_for_courses)
      recalculate_payments(discounts_for_courses)
    end

    private

    attr_reader :order

    def apply_automatic_discounts(discounts_for_courses)
      # фильтруем подходящие скидки
      automatic_discounts = AutomaticDiscount.enabled.ordered.select do |automatic_discount|
        (automatic_discount.course_ids - order.current_course_ids).blank?
      end

      # для каждого курса берем первую попавшуюся и применяем
      order.current_course_ids.each do |course_id|
        automatic_discount = automatic_discounts.detect { |d| d.course_ids.include?(course_id) }
        next unless automatic_discount
        discounts_for_courses[course_id] = automatic_discount.discount.id
      end
    end

    def apply_promo_code(discounts_for_courses)
      promo_code = order.promo_code

      return unless promo_code

      discounted_course_ids = promo_code.course_ids.blank? ?
          order.current_course_ids : (order.current_course_ids & promo_code.course_ids)

      discounted_course_ids.each do |course_id|
        unless discounts_for_courses.include?(course_id)
          discounts_for_courses[course_id] = promo_code.discount_id
        end
      end
    end

    def recalculate_payments(course_discounts)
      order.current_group_subscriptions.each do |subscription|
        course_id = subscription.course.id
        subscription.discount_id = course_discounts.has_key?(course_id) ? course_discounts[course_id] : nil
        subscription.calculate_payments
      end
    end
  end
end