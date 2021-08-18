# Контроллер раздела "Рейтинг"
# @see app/views/admin/ratings
module Admin
  class RatingsController < AdminController
    def index
      @q = GroupSubscription
             .actual
             .not_expelled
             .not_academic_vacation
             .not_ended
             .ransack(params[:q])
      @group_subscriptions = params[:q].present? ? @q.result.ordered_by_rating_score : []
    end

    def create
      @group_subscriptions = GroupSubscription
                               .actual
                               .not_expelled
                               .not_academic_vacation
                               .where(end_on: params[:begin_on].to_date..params[:end_on].to_date)
                               .top_rating
                               .ordered_by_rating_place
      render layout: false
    end
  end
end