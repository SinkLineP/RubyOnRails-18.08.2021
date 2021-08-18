module Api
  class PrivateFilesController < Api::ApplicationController
    def load
      file = File.open(File.join(PrivateFileUploader.root, params[:file]))
      send_file file
    end
  end
end