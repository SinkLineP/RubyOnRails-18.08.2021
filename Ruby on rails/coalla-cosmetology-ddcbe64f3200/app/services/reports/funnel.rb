module Reports
  class Funnel
    attr_reader :campaigns, :begin_on, :end_on

    def initialize(begin_on, end_on)
      @begin_on = begin_on
      @end_on = end_on
      @campaigns = Campaign.ordered.to_a
    end

    def generate
      package = Axlsx::Package.new

      query = Calculations::DataQuery.new(begin_on, end_on)
      campaigns_with_values = campaigns.map { |campaign| Calculations::CampaignWithValues.new(campaign, query) }
      total = Calculations::Total.new(campaigns_with_values)

      # menu
      package.workbook.add_worksheet(name: 'Меню') do |sheet|
        Generators::FunnelMenuSheet.new(sheet, campaigns_with_values).generate
      end

      # total sheet
      package.workbook.add_worksheet(name: 'ИТОГО') do |sheet|
        Generators::IndicesSheet.new(sheet, total).generate
      end

      # campaigns' sheets
      campaigns_with_values.each_with_index do |campaign, idx|
        package.workbook.add_worksheet(name: idx.to_s) do |sheet|
          Generators::IndicesSheet.new(sheet, campaign).generate
        end
      end

      package.use_shared_strings = true

      package
    end

  end
end