# Контроллер раздела "Сведения об организации"
# @see app/views/admin/institution_blocks
module Admin
  class InstitutionBlocksController < AdminController
    authorize_resource

    before_action only: %i(edit update) do
      @institution_block = InstitutionBlock.find(params[:id])
    end

    def index
      @institution_blocks = InstitutionBlock.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def update
      @institution_block = InstitutionBlock.find(params[:id])
      @institution_block.update(institution_block_params)
      render :edit
    end

    protected

    def institution_block_params
      params.require(:institution_block).permit!
    end

  end
end