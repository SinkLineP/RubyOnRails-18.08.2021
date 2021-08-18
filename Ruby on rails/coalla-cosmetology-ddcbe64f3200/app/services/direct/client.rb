module Direct
  class Client
    # Не стал прикручивать получение данных в цикле (limit + offset).
    # На данный момент дефолтный лимит - 10 000.
    # Вряд ли он когда-нибудь будет выбран, т.к. сейчас задано всего 53 ссылки.

    def campaigns
      response = api_v5.campaigns.get(fields: [:id, :name],
                                      criteria: {
                                          states: [:ARCHIVED, :CONVERTED, :ENDED, :OFF, :ON, :SUSPENDED]
                                      },
                                      page: {offset: 0})
      response.result[:Campaigns] || []
    end

    def ads(campaign_id)
      response = api_v5.ads.get(fields: [:id, :campaign_id, :type, :subtype],
                                TextAdFieldNames: [:Href, :SitelinkSetId],
                                criteria: {
                                    campaign_ids: [campaign_id]
                                },
                                page: {offset: 0})
      response.result[:Ads] || []
    end

    def statistics(campaign_id, begin_on, end_on = nil)
      api_v4.request('GetSummaryStat', {
          CampaignIDS: [campaign_id],
          Currency: 'RUB',
          StartDate: begin_on.to_s,
          EndDate: (end_on || begin_on).to_s
      })
    end

    private

    def api_v5
      @api_v5 ||= Direct::API::V5.client
    end

    def api_v4
      @api_v4 ||= Yandex::API::Direct
    end
  end
end