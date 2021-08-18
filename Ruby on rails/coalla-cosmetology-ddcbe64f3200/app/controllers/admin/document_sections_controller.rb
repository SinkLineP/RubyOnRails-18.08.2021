# Контроллер раздела "Разделы документов"
# @see app/views/admin/document_sections
module Admin
  class DocumentSectionsController < AdminController
    load_and_authorize_resource

    before_action :store_path_history

    def index
      @document_sections = DocumentSection.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      if @document_section.save
        redirect_to last_uri
      else
        render :new
      end
    end

    def update
      @document_section.assign_attributes(document_section_params)
      if @document_section.save
        redirect_to last_uri
      else
        render :edit
      end
    end

    def destroy
      @document_section.destroy
      redirect_to last_uri
    end

    private

    def document_section_params
      params.require(:document_section).permit!
    end

  end
end