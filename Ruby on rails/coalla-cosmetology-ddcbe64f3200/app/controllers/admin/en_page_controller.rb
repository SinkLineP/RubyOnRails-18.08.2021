# Контроллер раздела "Страница на английском"
# @see app/views/admin/en_page
module Admin
  class EnPageController < AdminController
    def edit
      @en_page = EnPage.first
    end

    def update
      @en_page = EnPage.first
      @en_page.assign_attributes(params[:en_page].permit!)

      if @en_page.save
        redirect_to edit_admin_en_page_path
      else
        render :edit
      end
    end
  end
end