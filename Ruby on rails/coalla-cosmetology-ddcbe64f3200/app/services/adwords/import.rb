module Adwords
  class Import
    attr_reader :client, :begin_on, :end_on

    def initialize(begin_on = Date.today, end_on = Date.today)
      @client = Client.new
      @begin_on = begin_on
      @end_on = end_on
    end

    def run!
      campaigns_with_adwords_id = load_capaigns_with_adwords_id
      campaigns_with_adwords_id.each do |campaign, adwords_campaign_id|
        load_statistics!(campaign, adwords_campaign_id)
      end
    end

    private

    def load_capaigns_with_adwords_id
      ad_groups = client.ad_groups

      Campaign.all.map do |campaign|
        adwords_group_with_links = ad_groups.detect do |ad_group|
          links = ad_group[:ad][:final_urls]
          links.present? && links.any? { |link| campaign.related?(link) }
        end

        next unless adwords_group_with_links

        [campaign, adwords_group_with_links[:base_campaign_id]]
      end.reject(&:blank?).to_h
    end

    def load_statistics!(campaign, adwords_campaign_id)
      rows = report.select { |row| row['campaignID'] == adwords_campaign_id.to_s }

      rows.each do |row|
        {shows: 'impressions', clicks: 'clicks', charges: 'cost'}.each do |index_name, param|
          idx = campaign.indices.find_or_initialize_by(name: index_name,
                                                       created_on: Date.parse(row['day']),
                                                       service: :google)

          if index_name == :charges
            value = row[param].to_f / 1_000_000
          else
            value = row[param].to_f
          end

          idx.value = value
          idx.save!
        end
      end
    end

    def report
      @report ||= client.campaign_performance_report(begin_on, end_on)
    end

  end
end