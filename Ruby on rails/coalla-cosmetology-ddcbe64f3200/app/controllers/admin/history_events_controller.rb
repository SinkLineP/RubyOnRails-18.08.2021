# Контроллер раздела "История"
# @see app/views/admin/history_events
module Admin
  class HistoryEventsController < AdminController
    before_action only: %i(edit update destroy) do
      @history_event = HistoryEvent.find(params[:id])
      force_update_current_shop_id(@history_event.shop_id)
    end

    authorize_resource

    set_current_shop_for_model(HistoryEvent)

    def index
      @history_events = HistoryEvent.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @history_event = HistoryEvent.new
    end

    def create
      @history_event = HistoryEvent.new(history_event_params)
      if @history_event.save
        redirect_to edit_admin_history_event_path(@history_event)
      else
        render :new
      end
    end

    def update
      @history_event.update(history_event_params)
      render :edit
    end

    def destroy
      @history_event.destroy
      redirect_to admin_history_events_path
    end

    def sort
      @history_events = HistoryEvent.ordered
    end

    def apply_sort
      ActiveRecord::Base.connection.transaction do
        params[:history_events].keys.each_with_index do |id, idx|
          HistoryEvent.find(id).update_attribute(:position, idx)
        end
      end
      redirect_to action: :index
    end

    protected

    def history_event_params
      params.require(:history_event).permit!
    end

  end
end