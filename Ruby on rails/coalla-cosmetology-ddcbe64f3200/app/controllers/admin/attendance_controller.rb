module Admin
  class AttendanceController < AdminController
    before_action do
      authorize! :show, :attendance
    end

    def show
      @q = TimeControl::Db::Event.preload(:door, :user).order(regdatefull: :desc).ransack(params[:q])
      @events = @q.result.paginate(page: params[:page] || 1,
                                   per_page: PER_PAGE)
      TimeControl::Db::SdoUsersPreloader.new(@events).preload
    end
  end
end