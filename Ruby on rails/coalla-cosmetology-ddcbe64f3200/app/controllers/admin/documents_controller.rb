# Контроллер раздела "Документы"
# @see app/views/admin/documents
module Admin
  class DocumentsController < AdminController
    load_and_authorize_resource

    before_action :store_path_history

    def index
      @documents = Document.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      if @document.save
        redirect_to last_uri
      else
        render :new
      end
    end

    def update
      @document.assign_attributes(document_params)
      if @document.save
        redirect_to last_uri
      else
        render :edit
      end
    end

    def destroy
      @document.destroy
      redirect_to last_uri
    end

    private

    def document_params
      params.require(:document).permit!
    end
  end
end