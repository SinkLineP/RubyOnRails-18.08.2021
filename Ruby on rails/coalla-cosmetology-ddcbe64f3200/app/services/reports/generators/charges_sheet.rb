module Reports
  module Generators
    class ChargesSheet
      include ::ActiveSupport::NumberHelper
      include SheetHelper

      # ../lib/axlsx/stylesheet/num_fmt.rb
      FLOAT_STYLE = 2

      attr_reader :sheet, :items, :style

      def initialize(sheet, items)
        @sheet = sheet
        @items = items
        @style = OpenStruct.new(default: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER),
                                float: sheet.styles.add_style(num_fmt: FLOAT_STYLE, border: Axlsx::STYLE_THIN_BORDER),
                                title: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER,
                                                              b: true,
                                                              alignment: {
                                                                  horizontal: :center
                                                              }))
      end

      def generate
        #back link
        sheet.add_row(['Меню'],
                      style: style.title)
        sheet.add_hyperlink(location: "'Меню'!A1", ref: 'A1', target: :sheet)

        #header
        sheet.add_row(['Студент',
                       'Сумма, руб. (без скидки)',
                       'Дата продажи',
                       'Рекламный канал',
                       'Скидка',
                       'Расходы на привлечение',
                       'Расходы на СМС',
                       'Себестоимость сделки',
                       'Дата внесения в CRM'], style: style.title)

        #indices
        @items.each_with_index do |item, idx|
          row = idx + 2
          sheet.add_row
          sheet.rows[row].add_cell(item.student_full_name, style: style.default) # студент
          sheet.rows[row].add_cell(item.price_without_discount, style: style.float) # сумма, руб. (без скидки)
          sheet.rows[row].add_cell(item.sale_success_on.strftime('%d.%m.%Y'), style: style.default) # дата продажи
          sheet.rows[row].add_cell(item.campaign_name, style: style.default) # рекламный канал
          sheet.rows[row].add_cell(item.discount_amount, style: style.float) # скидка
          sheet.rows[row].add_cell(item.attraction_charges, style: style.float) # расходы на привлечение
          sheet.rows[row].add_cell(item.sms_cost, style: style.float) # расходы на СМС
          sheet.rows[row].add_cell(item.course_cost, style: style.float) # себестоимость сделки
          sheet.rows[row].add_cell(item.student_amo_created_at, style: style.default) # дата внесения в CRM
        end

        # freeze first column
        sheet.sheet_view.pane do |pane|
          pane.top_left_cell = "B2"
          pane.state = :frozen_split
          pane.y_split = 1
          pane.x_split = 0
          pane.active_pane = :bottom_right
        end
      end
    end
  end
end