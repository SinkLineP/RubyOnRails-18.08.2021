require 'adwords_api'

module Adwords
  class Client
    PER_PAGE = 10000

    def ad_groups
      selector = {
          fields: [
              'AdGroupId',
              'BaseCampaignId',
              'CreativeFinalUrls'
          ],
          ordering: [{
                         field: 'AdGroupId',
                         sort_order: 'ASCENDING'
                     }],
          paging: {
              start_index: 0,
              number_results: PER_PAGE
          }
      }
      service = api.service(:AdGroupAdService)
      service.get(selector)[:entries]
    end

    def campaign_performance_report(begin_on, end_on = nil)
      report_definition = {
          selector: {
              fields: ['CampaignId', 'Clicks', 'Impressions', 'Cost', 'Date'],
              date_range: {
                  min: "#{begin_on.strftime('%Y%m%d')}",
                  max: "#{(end_on || begin_on).strftime('%Y%m%d')}"
              }
          },
          report_name: "#{begin_on.to_s} #{(end_on || begin_on).to_s} CAMPAIGN_PERFORMANCE_REPORT",
          report_type: 'CAMPAIGN_PERFORMANCE_REPORT',
          download_format: 'XML',
          date_range_type: 'CUSTOM_DATE',
      }

      api.include_zero_impressions = true
      report_utils = api.report_utils()
      report_xml = report_utils.download_report(report_definition)
      Hash.from_xml(report_xml)['report']['table']['row']
    end

    def api
      @api ||= AdwordsApi::Api.new(File.join(Rails.root, 'config', 'adwords_api.yml'))
    end
  end
end