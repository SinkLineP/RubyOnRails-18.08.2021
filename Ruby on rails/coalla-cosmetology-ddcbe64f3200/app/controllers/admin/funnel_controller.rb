# Отчет "Воронка"
# @see app/views/admin/funnel
# @see app/views/admin/indices/show.haml
module Admin
  class FunnelController < AdminController
    def show
      render :show, layout: false
    end

    def create
      begin_on = Date.parse(params[:begin_on])
      end_on = Date.parse(params[:end_on])
      package = Reports::Funnel.new(begin_on, end_on).generate
      upload_to_google_doc(package.to_stream, begin_on, end_on) unless Rails.env.development?
      send_data(package.to_stream.read, filename: 'funnel.xlsx')
    end

    def upload_to_google_doc(stream, begin_on, end_on)
      session = GoogleDrive::Session.from_config('config/client_secret.json')
      session.upload_from_io(stream, "Воронка #{begin_on} - #{end_on} (#{Time.current.to_i}).xlsx")
    rescue => ex
      Rails.logger.error("Couldn't upload file to Google Drive. #{ex.message}")
    end
  end
end