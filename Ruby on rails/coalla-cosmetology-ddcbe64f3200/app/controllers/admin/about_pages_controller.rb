# Контроллер раздела "Об институте"
# @see AbstractPagesController
# @see app/views/admin/abstract_pages
module Admin
  class AboutPagesController < AbstractPagesController
    def scope_name
      'about'
    end

    def redirect_url
      admin_about_pages_path
    end
  end
end