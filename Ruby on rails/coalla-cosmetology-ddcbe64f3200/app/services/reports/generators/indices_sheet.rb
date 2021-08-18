module Reports
  module Generators
    class IndicesSheet
      include ::ActiveSupport::NumberHelper
      include SheetHelper

      # ../lib/axlsx/stylesheet/num_fmt.rb
      PERCENT_STYLE = 10
      FLOAT_STYLE = 2

      attr_reader :sheet, :item, :style

      def initialize(sheet, item)
        @sheet = sheet
        @item = item
        @style = OpenStruct.new(default: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER),
                                percent: sheet.styles.add_style(num_fmt: PERCENT_STYLE, border: Axlsx::STYLE_THIN_BORDER),
                                float: sheet.styles.add_style(num_fmt: FLOAT_STYLE, border: Axlsx::STYLE_THIN_BORDER),
                                title: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER,
                                                              b: true,
                                                              alignment: {
                                                                  horizontal: :center
                                                              }))
      end

      def generate
        # back link
        sheet.add_row(['Меню'],
                      style: style.title)
        sheet.add_hyperlink(location: "'Меню'!A1", ref: 'A1', target: :sheet)

        # empty row
        sheet.add_row(['Показатель',
                       'Значение'],
                      style: style.title)

        #header
        [
            'Показы',
            'Клики',
            'Заявки',
            'Звонки',
            'Продажи',
            'CTR, %',
            'CV клик в заявку, %',
            'CV клик в звонок, %',
            'CV заявка в продажу, %',
            'CV звонка в продажу, %',
            'CV клик в продажу, %',
            'Доходы всего, руб',
            'Расходы на рекламу, руб',
            'Чистая прибыль, руб',
            'Средний чек, руб',
            'Стоимость клиента, руб',
            'Стоимость заявки, руб',
            'Стоимость звонка, руб',
            'Цена клика, руб',
            'ROI'
        ].each_with_index do |title, idx|
          sheet.add_row([title], style: style.default)
        end

        #indices
        sheet.rows[2].add_cell(item.shows, style: style.default) # показы
        sheet.rows[3].add_cell(item.clicks, style: style.default) # клики
        sheet.rows[4].add_cell(item.requests, style: style.default) # заявки
        sheet.rows[5].add_cell(item.calls, style: style.default) # звонки
        sheet.rows[6].add_cell(item.subscriptions, style: style.default) # продажи
        sheet.rows[7].add_cell(item.clicks_on_shows, style: style.percent) # CTR
        sheet.rows[8].add_cell(item.requets_on_clicks, style: style.percent) # CV клик в заявку
        sheet.rows[9].add_cell(item.calls_on_clicks, style: style.percent) # CV клик в звонок
        sheet.rows[10].add_cell(item.subscriptions_on_requests, style: style.percent) # CV заявка в продажу
        sheet.rows[11].add_cell(item.subscriptions_on_calls, style: style.percent) # CV звонка в продажу
        sheet.rows[12].add_cell(item.subscriptions_on_clicks, style: style.percent) # CV клик в продажу
        sheet.rows[13].add_cell(item.profit, style: style.float) # Доходы всего
        sheet.rows[14].add_cell(item.charges, style: style.float) # Расходы на рекламу
        sheet.rows[15].add_cell(item.net_profit, style: style.float) # Чистая прибыль
        sheet.rows[16].add_cell(item.averrage_bill, style: style.float) # Средний чек
        sheet.rows[17].add_cell(item.subscription_cost, style: style.float) # Стоимость клиента
        sheet.rows[18].add_cell(item.request_cost, style: style.float) # Стоимость заявки
        sheet.rows[19].add_cell(item.call_cost, style: style.float) # Стоимость звонка
        sheet.rows[20].add_cell(item.click_cost, style: style.float) # Цена клика
        sheet.rows[21].add_cell(item.roi, style: style.float) # ROI

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