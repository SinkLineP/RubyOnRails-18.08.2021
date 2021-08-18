# Запуск испорта из AmoCRM
# @see app/views/admin/students/index.html.haml
module Admin
  class AmocrmImportController < AdminController
    def run
      last_import = AmocrmImport.last

      if last_import.blank? || last_import.completed?
        AmocrmImport.enqueue!
      end

      redirect_to admin_students_path
    end
  end
end