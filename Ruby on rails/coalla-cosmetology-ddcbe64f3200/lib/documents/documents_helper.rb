module Documents
  module DocumentsHelper
    def format_date_with_quotes(date)
      Russian.strftime(date, '«%d» %B %Y г.') if date.present?
    end

    def format_date_with_points(date)
      return '' if date.blank?
      date.strftime('%d.%m.%Y') if date.present?
    end

    def format_date(date)
      Russian.strftime(date, '%d %B %Y') if date.present?
    end

    def format_price_for_invoice(price)
      roubles = price.floor
      pennies = ((price - roubles) * 100).round
      "#{roubles.to_words.mb_chars.capitalize} #{Russian.p(roubles, 'рубль', 'рубля', 'рублей')} #{'%02d' % pennies} #{Russian.p(pennies, 'копейка', 'копейки', 'копеек')}"
    end

    def format_price_for_contract(price, with_pennies = true)
      roubles = price.floor
      result = "#{roubles} (#{roubles.to_words}) #{Russian.p(roubles, 'рубль', 'рубля', 'рублей')}"

      if with_pennies
        pennies = ((price - roubles) * 100).round
        result = "#{result} #{'%02d' % pennies} #{Russian.p(pennies, 'копейка', 'копейки', 'копеек')}"
      end

      result
    end

    def format_duration(hours)
      "#{hours} #{Russian.p(hours, 'час', 'часа', 'часов')}"
    end

    def full_name_form(name_string, form = :genitive)
      names = name_string.to_s.split("\s")
      if names.length == 3
        last_name, first_name, middle_name = names
        gender = Petrovich(middlename: middle_name).gender
        Petrovich(lastname: last_name,
                  firstname: first_name,
                  middlename: middle_name,
                  gender: gender).to(form).to_s
      else
        names.join("\s")
      end
    end

    def full_name_sign(name_string)
      last_name, first_name, middle_name = name_string.to_s.split("\s")
      [last_name, initial(first_name), initial(middle_name)].join("\s")
    end

    def get_days_of_month(practice_range, month_number)
      practice_range.select{ |day| day.month == month_number }.map(&:day)
    end

    def get_date_text(day, month)
      "#{day}.#{month.to_s.rjust(2, '0')}"
    end

    def time_range_format(start_time, end_time)
      "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}" if start_time.present? && end_time.present?
    end
    def document_text_format(document)
      document ? "№ #{document.number} от #{format_date(document.created_on)} г." : '-'
    end

    def academic_vacation_text(subscription)
      "#{subscription.change_group_orders.map{|order| document_text_format(order)}.join(', ')}/#{document_text_format(subscription.vacation_order)}"
    end

    def payment_type(subscription)
      return unless subscription.payments
      if subscription.payments.count == 1
        "100% предоплаты в сумме #{format_price_for_contract(subscription.price, false)}"
      else
        "поэтапной оплаты:\r\n" +
            subscription.payments.each_with_index.map { |p, idx| "#{idx + 1}-й взнос в размере #{format_price_for_contract(p.amount, false)} #{idx == 0 ? 'при заключении договора' : 'до '}#{format_date(p.payed_on) if idx != 0}" }.join(",\r\n")
      end
    end

    def practices_education_dates_text(practices)
      practices.reject(&:blank?).map { |p| [p.begin_on.try(:strftime, '%d.%m.%Y'), p.end_on.try(:strftime, '%d.%m.%Y')].reject(&:blank?).join(' - ') }.join(', ')
    end
  end
end