# Контроллер раздела "Расходы"
# @see app/views/admin/campaign_indices
module Admin
  class CampaignIndicesController < ResourceController

    def index
      @campaign_indices = CampaignIndex.sikorsky.ordered.paginate(page: params[:page] || 1,
                                                                  per_page: per_page)
    end

    protected

    def save_and_response
      resource.assign_attributes(service: :sikorsky, name: :charges)

      if resource.save
        render json: {redirect_url: url_for(action: :index)}
      else
        render json: {errors: resource.errors}
      end
    end

  end
end