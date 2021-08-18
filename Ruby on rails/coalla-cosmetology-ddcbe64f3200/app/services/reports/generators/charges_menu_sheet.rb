module Reports
  module Generators
    class ChargesMenuSheet
      attr_reader :sheet, :groups, :style

      def initialize(sheet, groups)
        @sheet = sheet
        @groups = groups
        @style = sheet.styles.add_style(b: true,
                                        alignment: {
                                            horizontal: :center
                                        })
      end

      def generate
        sheet.add_row(['LTV'], style: style)
        sheet.add_hyperlink(location: "'LTV'!A1", ref: 'A1', target: :sheet)

        groups.each_with_index do |group, idx|
          sheet.add_row([group.title], style: style)
          sheet.add_hyperlink(location: "'#{idx}'!A1", ref: "A#{idx + 2}", target: :sheet)
        end
      end
    end
  end
end