# Отчет зачисленных/отчисленных за период студентов
# @see app/views/admin/contingents
# @see app/views/admin/students/index.html.haml
module Admin
  class PeriodOrdersController < AdminController
    layout false

    def new; end

    def create
      @begin_at = params[:begin_at].presence
      @end_at = params[:end_at].presence
      options = {begin_at: Date.parse(@begin_at), end_at: Date.parse(@end_at), date: Date.parse(params[:date]), number: params[:number]}

      file_path = params[:type] == 'AdditionPeriodOrder' ? Reports::AdditionPeriodOrderBuilder.build(options) :
                                                           Reports::ExpulsionPeriodOrderBuilder.build(options)

      filename = t("order_title.#{params[:type]}")
      temp_pdf_path = Documents::DocumentBuilder.new(params[:type]).convert_to_pdf(file_path, filename)
      File.delete(file_path)
      send_file temp_pdf_path, filename: "#{filename}.pdf", type: 'application/pdf', disposition: 'attachment'
    end
  end
end