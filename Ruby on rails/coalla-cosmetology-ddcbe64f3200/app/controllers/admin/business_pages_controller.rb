# Контроллер раздела "Для бизнеса"
# @see AbstractPagesController
# @see app/views/admin/abstract_pages
module Admin
  class BusinessPagesController < AbstractPagesController
    def scope_name
      'business'
    end

    def redirect_url
      admin_business_pages_path
    end
  end
end