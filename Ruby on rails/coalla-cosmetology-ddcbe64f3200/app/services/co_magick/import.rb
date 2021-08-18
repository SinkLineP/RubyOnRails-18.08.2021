module CoMagick
  class Import

    attr_reader :client, :begin_on, :end_on

    def initialize(begin_on = Date.today, end_on = Date.today)
      @client = Client.new
      @begin_on = begin_on
      @end_on = end_on
    end

    def run!
      load_campaigns!
      load_statistics!
    end

    private

    def load_campaigns!
      campaigns = client.campaigns
      campaigns.each do |data|
        create_or_update_campaign!(data)
      end
      create_or_update_campaign!({'id' => '-1', 'name' => 'Посетители без рекламной кампании'})

      Campaign.where(name: 'Поисковое продвижение').update_all(seopult_id: '5563751')
    end

    def load_statistics!
      site_id = client.sites.first['id']

      (begin_on..end_on).each do |date|
        Campaign.find_each do |campaign|
          stats = client.stats(site_id, campaign.co_magick_id, date)
          create_or_update_index!(campaign, stats, date)
        end
      end
    end

    def create_or_update_campaign!(data)
      campaign = Campaign.find_or_initialize_by(co_magick_id: data['id'])
      campaign.name = data['name']

      campaign_conditions = client.campaign(data['id'])
      campaign.utm_sources = extract_conditions(campaign_conditions, 'utm_source')
      campaign.utm_mediums = extract_conditions(campaign_conditions, 'utm_medium')
      campaign.utm_campaigns = extract_conditions(campaign_conditions, 'utm_campaign')

      site_block = campaign_conditions['site_blocks'].try(:first)

      if site_block
        campaign.phone_type = site_block['phone_type']
        campaign.phone = site_block['numb']
      end

      campaign.save!
    end

    def create_or_update_index!(campaign, stats, date)
      [:visits, :calls].each do |index_name|
        idx = campaign.indices.find_or_initialize_by(created_on: date,
                                                     name: index_name,
                                                     service: :co_magick)
        idx.assign_attributes(value: stats["#{index_name}_count"].to_i)
        idx.save!
      end
    end

    def extract_conditions(campaign_conditions, parameter_name)
      if campaign_conditions['ac_conditions']
        campaign_conditions['ac_conditions']
            .select { |condition| condition['ac_parameter'] == parameter_name }
            .map { |condition| condition['value'].strip.squish.gsub("#{parameter_name}=", '') }
      else
        []
      end
    end
  end
end