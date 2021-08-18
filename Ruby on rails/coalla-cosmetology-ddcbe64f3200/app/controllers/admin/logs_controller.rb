# frozen_string_literal: true

module Admin
  class LogsController < AdminController
    PER_PAGE = 50

    def show
      @log = Log.find(params[:id]) if params[:id]
      render layout: false
    end
    def index
      @actions = params[:actions].presence || [0, 1, 2, 3]
      @begin_at = params[:begin_at].presence.try(:to_date) || Log.minimum(:created_at).to_date
      @end_at = params[:end_at].presence.try(:to_date) || Log.maximum(:created_at).to_date
      @editor = params[:editor].to_i || 0
      @editors = [{ id: "0", label: "Все" }]
      @editors += Log.joins(:editor).all.map { |e| { id: e.editor.id, label: "#{e.editor.full_name} (#{e.editor.email})" } }.uniq
      scope = Log.all.paginate(page: params[:page] || 1, per_page: PER_PAGE)
                 .where("created_at BETWEEN ? AND ?", @begin_at.beginning_of_day, @end_at.end_of_day)
                 .where(action_type: @actions)
      scope = scope.where(editor_id: @editor) if  @editor.present? && @editor > 0
      @logs = scope
      if request.xhr?
        render json: { logs: render_to_string(partial: "admin/logs/logs") }
        return
      end
    end
  end
end
