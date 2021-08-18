# Отчет "Модули"
# @see app/views/admin/students/show.haml
module Admin
  class ModulesReportController < AdminController
    def create
      package = Reports::Modules.new.generate
      Reports::Storage.upload(package.to_stream, "Модули.xlsx")
      send_data(package.to_stream.read, filename: 'modules.xlsx')
    end
  end
end