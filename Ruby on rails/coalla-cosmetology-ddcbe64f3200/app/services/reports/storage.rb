module Reports
  class Storage
    class << self
      def upload(stream, filename)
        config = "config/google_drive/#{Rails.env.to_s}.json"
        session = GoogleDrive::Session.from_config(config)
        file = session.file_by_title(filename)
        file.present? ? file.update_from_io(stream) : session.upload_from_io(stream, filename)
      rescue => ex
        Rails.logger.error("Couldn't upload file to Google Drive. #{ex.message}")
      end
    end
  end
end