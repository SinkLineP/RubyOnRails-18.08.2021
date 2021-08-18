require 'csv'

module Mindbox
  class UsersCsv
    class << self
      def export
        file_path = Rails.root.join('public', 'users.csv')
        CSV.open(file_path, 'wb', col_sep: ';') do |csv|
          csv << %w(Websiteid FirstName LastName MiddleName MobilePhone Email BirthDate SourceDateTime IsSubscribed)
          Student.ordered.find_each(batch_size: 5000) do |student|
            csv << [
              student.id,
              student.first_name,
              student.last_name,
              student.middle_name,
              student.phone,
              student.email,
              student.birthday && student.birthday.strftime('%Y-%m-%d'),
              student.created_at.strftime('%Y-%m-%d %H:%M'),
              student.subscribed_on_blog
            ]
          end
        end
      end
    end
  end
end