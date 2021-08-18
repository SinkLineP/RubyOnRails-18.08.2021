module Api
  class DocumentsController < Api::ApplicationController
    def load
      document = GeneratedDocument.find(params[:id])
      send_file document.path
    end
  end
end