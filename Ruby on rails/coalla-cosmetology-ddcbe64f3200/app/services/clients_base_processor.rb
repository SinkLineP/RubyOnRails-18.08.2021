class ClientsBaseProcessor
  FIRST_DATA_CELL_IDX = 20

  def self.run
    ClientsBaseProcessor.new.run
  end

  attr_reader :workbook

  def initialize
    @workbook = RubyXL::Parser.parse(File.join(Rails.root, 'tmp', 'clients.xlsx'))
  end

  def run
    worksheet = workbook[0]
    worksheet.each_with_index do |row, row_idx|
      next if row_idx == 0

      email = row[1].value

      next if email.blank?

      user = Student.find_by(email: email.strip.squish.downcase)

      next unless user

      cell_idx = FIRST_DATA_CELL_IDX

      user.group_subscriptions.actual.each_with_index do |group_subscription, idx|
        course = group_subscription.course
        worksheet.add_cell(row_idx, cell_idx + idx, course.name)

        sanitized_course_name = course.name.gsub(/[\\\/\*\[\]\:\?]+/, '')

        course_sheet = workbook[sanitized_course_name]

        unless course_sheet
          course_sheet = workbook.add_worksheet(sanitized_course_name)
        end

        course_sheet_row_idx = course_sheet.sheet_data.size

        [
            user.full_name,
            user.amocrm_url,
            user.email,
            group_subscription.group_title,
            group_subscription.price,
            group_subscription.sale_success_on.try(:strftime, '%d.%m.%Y')
        ].each_with_index do |field, idx|
          course_sheet.add_cell(course_sheet_row_idx, idx, field)
        end
      end
    end

    workbook.write(File.join(Rails.root, 'tmp', 'clients-parsed.xlsx'))
  end
end