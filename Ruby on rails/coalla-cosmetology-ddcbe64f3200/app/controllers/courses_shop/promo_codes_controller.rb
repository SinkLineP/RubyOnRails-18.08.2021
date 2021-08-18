module CoursesShop
  class PromoCodesController < BaseController
    def check
      if params[:promo_code].blank?
        render json: {}
        return
      end

      promo_code = PromoCode.find_by(code: params[:promo_code].gsub("\s", ''))
      error = promo_code_error(promo_code)

      if error.present?
        render json: {error: error}
        return
      end

      render json: {id: promo_code.id}
    end

    private

    def promo_code_error(promo_code)
      return 'Некорректный код' if promo_code.blank?
      return 'Недействительный код' unless promo_code.try(&:active?)
      course_ids = GroupSubscription
                       .where(id: params[:order][:group_subscription_ids])
                       .map { |gs| gs.course.id }
      if promo_code.course_ids.present? && (promo_code.course_ids & course_ids).blank?
        'Нет подходящих курсов'
      end
    end
  end
end