module Direct
  class Import
    attr_reader :client, :begin_on, :end_on

    def initialize(begin_on = Date.today, end_on = Date.today)
      @client = Client.new
      @begin_on = begin_on
      @end_on = end_on
    end

    def run!
      direct_campaigns_with_links = load_direct_campaigns_with_links
      campaigns_with_direct_id = load_capaigns_with_direct_id(direct_campaigns_with_links)
      campaigns_with_direct_id.each do |campaign, direct_id|
        load_statistics!(campaign, direct_id)
      end
    end

    private

    def load_direct_campaigns_with_links
      direct_campaigns = client.campaigns

      direct_campaigns.map do |direct_campaign|
        ads = client.ads(direct_campaign[:Id])
        [direct_campaign, ads.map { |ad| ad[:TextAd][:Href] }.uniq]
      end.to_h
    end

    def load_capaigns_with_direct_id(direct_campaigns_with_links)
      Campaign.all.map do |campaign|
        direct_campaign_with_links = direct_campaigns_with_links.detect do |direct_campaign, links|
          links.any? { |link| campaign.related?(link) }
        end

        next unless direct_campaign_with_links

        [campaign, direct_campaign_with_links.first[:Id]]
      end.reject(&:blank?).to_h
    end

    def load_statistics!(campaign, direct_id)
      statistics = client.statistics(direct_id, begin_on, end_on)

      statistics.each do |stat_item|
        {shows: [
            'ShowsSearch',
            'ShowsContext'],
         clicks: [
             'ClicksSearch',
             'ClicksContext'],
         charges: [
             'SumSearch',
             'SumContext']}.each do |index_name, params|
          idx = campaign.indices.find_or_initialize_by(name: index_name,
                                                       created_on: Date.parse(stat_item['StatDate']),
                                                       service: :yandex)

          idx.value = params.sum { |param| stat_item[param].to_f }
          idx.save!
        end
      end
    end
  end
end