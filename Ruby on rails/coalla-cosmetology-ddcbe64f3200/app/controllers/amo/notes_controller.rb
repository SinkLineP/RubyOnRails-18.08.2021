module Amo
  class NotesController < Amo::BaseController

    protected

    def resource_name
      :notes
    end

    def resource_params
      return [] if params[:leads].blank?

      params[:leads][:note].try(:values) || []
    end
  end
end