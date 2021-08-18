# Контроллер раздела "Занятое время"
# @see app/views/admin/used_times
module Admin
  class UsedTimesController < ResourceController
    def index
      @q = UsedTime.ransack(params[:q])
      @used_times = @q.result.ordered.paginate(page: params[:page] || 1, per_page: per_page)
    end
  end
end