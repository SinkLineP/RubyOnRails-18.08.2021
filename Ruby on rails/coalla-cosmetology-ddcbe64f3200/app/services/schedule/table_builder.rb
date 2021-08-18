module Schedule
  class TableBuilder
    def initialize(year = Date.current.year)
      @year = year
      @schedule_items = ScheduleItem.preload(:classroom,
                                             :instructor,
                                             :work,
                                             :groups)
                          .where(day: Date.new(year, 1, 1)..Date.new(year, 12, 31))
                          .order(:day)
      @classrooms = Classroom.all.sort_by { |classroom| [classroom.number, classroom.correct_title] }
    end

    def build
      package = Axlsx::Package.new
      @schedule_items.group_by { |item| [item.day.year, item.day.month] }.each do |month_and_year, schedule_items|
        date = Date.new(month_and_year[0], month_and_year[1], 1)
        package.workbook.add_worksheet(name: Russian.strftime(date, '%B %Y')) do |sheet|
          write_sheet_data(sheet, schedule_items)
        end
      end
      package
      package.serialize("Расписание #{@year}.xlsx")
      ::Reports::Storage.upload(package.to_stream, "Расписание #{@year}.xlsx")
      true
    end

    private

    def write_sheet_data(sheet, schedule_items)
      styles = OpenStruct.new(default: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER,
                                                              alignment: {
                                                                wrap_text: true
                                                              }),
                              title: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER,
                                                            b: true,
                                                            alignment: {
                                                              horizontal: :center,
                                                              wrap_text: true
                                                            }))

      #header
      sheet.add_row(%w(Дата д/н) + @classrooms.map(&:title), style: styles.title)

      #rows
      schedule_items.group_by(&:day).each do |day, items|
        sorted_items = items.sort_by(&:begin_at)
        rows = []
        begin
          row = sheet.add_row
          row.add_cell(rows.blank? ? Russian.strftime(day, '%d.%m.%Y') : '', style: styles.default)
          row.add_cell(rows.blank? ? Russian.strftime(day, '%a') : '', style: styles.default)
          classrooms_items = @classrooms.map { |classroom| sorted_items.detect { |item| item.classroom == classroom } }
          classrooms_items.each do |item|
            style = item ? cell_style(sheet, item, styles) : styles.default
            text = item ? cell_text(item) : ''
            row.add_cell(text, style: style)
          end
          rows << row
          sorted_items.delete_if { |item| classrooms_items.include?(item) }
        end while sorted_items.present?
        sheet.merge_cells(rows.map { |row| row.cells[0] })
        sheet.merge_cells(rows.map { |row| row.cells[1] })
      end
    end

    def cell_text(item)
      lines = []
      lines << "#{Russian.strftime(item.begin_at, '%H:%M')}-#{Russian.strftime(item.end_at, '%H:%M')}"
      lines << "#{item.work.title} #{item.work_index}"
      lines << (item.groups.map(&:title) + item.working_off_lists.map { |list| "#{list.group_subscription.student_full_name} (отработка)" }).join(', ')
      lines.join("\n")
    end

    def cell_style(sheet, item, styles)
      courses = item.groups.map(&:course).uniq
      return styles.default if courses.count > 1
      sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER,
                             bg_color: bg_color(courses.first),
                             alignment: {
                               wrap_text: true
                             })
    end

    def bg_color(course)
      return 'ff5a6e' if %w(SK K KO KOV KC KV).include?(course.short_name)
      return 'ffc0cb' if %w(MM SPA-M).include?(course.short_name)
      return 'ffcebe' if course.shop.cosmetic?
      return '0099ff' if %w(PO PE PV BR).include?(course.short_name)
      '00cdcd' if course.shop.barbershop?
    end
  end
end