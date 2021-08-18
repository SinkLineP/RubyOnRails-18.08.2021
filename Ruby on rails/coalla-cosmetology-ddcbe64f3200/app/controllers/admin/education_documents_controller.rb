# Контроллер раздела "Выпускные документы"
# @see app/views/admin/education_documents
module Admin
  class EducationDocumentsController < ResourceController
    def edit; end

    def update
      resource.assign_attributes(resource_params)

      if resource.save
        redirect_to admin_education_documents_path
        return
      end

      render :edit
    end

    def list
      documents = EducationDocument.alphabetical_order

      if params[:term].present?
        documents = documents.where('title ilike ?', "%#{params[:term]}%")
      end

      render json: documents.first(LIST_SIZE).map { |document| {value: document.title, id: document.id} }
    end
  end
end