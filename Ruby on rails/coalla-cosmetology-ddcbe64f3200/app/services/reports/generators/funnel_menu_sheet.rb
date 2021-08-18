module Reports
  module Generators
    class FunnelMenuSheet
      attr_reader :sheet, :campaigns, :style

      def initialize(sheet, campaigns)
        @sheet = sheet
        @campaigns = campaigns
        @style = sheet.styles.add_style(b: true,
                                        alignment: {
                                            horizontal: :center
                                        })
      end

      def generate
        sheet.add_row(['ИТОГО'], style: style)
        sheet.add_hyperlink(location: "'ИТОГО'!A1", ref: 'A1', target: :sheet)

        campaigns.each_with_index do |campaign, idx|
          sheet.add_row([campaign.name, idx.to_s], style: style)
          sheet.add_hyperlink(location: "'#{idx}'!A1", ref: "A#{idx + 2}", target: :sheet)
        end
      end
    end
  end
end