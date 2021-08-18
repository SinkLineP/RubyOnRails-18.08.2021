# Контроллер раздела "Этапы продаж"
# @see app/views/admin/amocrm_status
module Admin
  class AmocrmStatusesController < AdminController
    authorize_resource

    def index
      @amocrm_status = AmocrmStatus.preload(:pipeline).ordered
    end
  end
end