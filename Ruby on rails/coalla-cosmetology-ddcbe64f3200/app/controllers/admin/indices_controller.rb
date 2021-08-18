# Контроллер раздела "Статистика кампаний"
# @see app/views/admin/indices
module Admin
  class IndicesController < AdminController
    def show
      params[:q] = { service_eq: :co_magick, created_on_eq: Date.current.strftime('%d.%m.%Y') } if params[:q].blank?
      @q = CampaignIndex.includes(:campaign).order('campaigns.name').ransack(params[:q])
      campaign_indices = @q.result.uniq

      @indices = campaign_indices.group_by { |i| i.campaign }.map do |campaign, indices|
        fields = { campaign: campaign.name }

        %w(clicks shows visits calls).each do |index_name|
          index_value = indices.detect { |i| i.name == index_name }.try(:value)
          fields[index_name] = index_value ? index_value.to_i : '-'
        end

        fields['charges'] = indices.detect { |i| i.name == 'charges' }.try(:value) || '-'

        OpenStruct.new(fields)
      end
    end
  end
end