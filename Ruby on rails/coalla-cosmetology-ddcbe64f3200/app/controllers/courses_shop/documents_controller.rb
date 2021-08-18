module CoursesShop
  class DocumentsController < BaseController
    before_action :authenticate_user!

    before_action only: %i(destroy show) do
      @document = current_user.send(association).find(params[:id])
    end

    def index
      @documents = current_user.all_documents
    end

    def show
      file = File.open(@document.file.path)
      send_file file
    end

    def create
      document = current_user.send(association).build(document_params)

      if document.save
        responce = {location: courses_shop_profile_documents_path}
      else
        responce = {errors: document.errors}
      end

      respond_to do |format|
        format.js { render(json: responce) }
      end
    end

    def destroy
      @document.destroy! if @document.loaded_by_user?
      redirect_to courses_shop_profile_documents_path
    end

    private

    def document_params
      if params[:document_type] == 'document_copy'
        options = params.require(:document).permit(:file)
        options.merge({loaded_by_user: true})
      else
        options = params.require(:document).permit(:file, :title)
        options.merge({loaded_by_user: true, document_type: params[:document_type]})
      end
    end

    def association
      params[:document_type] == 'document_copy' ? :document_copies : :student_documents
    end

  end
end