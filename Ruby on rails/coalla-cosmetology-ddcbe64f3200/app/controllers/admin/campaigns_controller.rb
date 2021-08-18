# Контроллер раздела "Рекламные канала"
# @see app/views/admin/campaigns
module Admin
  class CampaignsController < AdminController
    authorize_resource

    def index
      @campaigns = Campaign.ordered
    end

  end
end