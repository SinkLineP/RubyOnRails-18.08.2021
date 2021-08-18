module TimeControl
  module Reports
    class ReportBuilder
      def initialize(params = {})
        params = params.with_indifferent_access
        @begin_on = params[:begin_on].presence ? Date.parse(params[:begin_on]) : Date.new(2018, 1, 1)
        @end_on = [params[:end_on].presence ? Date.parse(params[:end_on]) : Date.today, Date.today].min
        @users_emails = params[:users_emails]
        initialize_columns
      end

      def save
        package = build
        timestamp = (DateTime.now.to_f * 1000).to_i.to_s
        dir = File.join('private', 'uploads', 'attendance', timestamp[0, 4]).to_s
        FileUtils.mkdir_p(dir)
        path = File.join(dir, "Attendance #{timestamp}.xlsx").to_s
        package.serialize(Rails.root.join(path).to_s)
        path
      end

      def build
        package = Axlsx::Package.new
        package.workbook.add_worksheet(name: 'Студенты') do |sheet|
          style = OpenStruct.new(default: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER),
                                 title: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER,
                                                               b: true,
                                                               alignment: {
                                                                 horizontal: :center
                                                               }))
          #header
          sheet.add_row(build_title_row, style: style.default)
          #rows
          build_data_rows.each do |row|
            sheet.add_row(row, style: style.default)
          end
        end
        package
      end

      private

      def initialize_columns
        @columns = {
          user_fullname: ->(data) { data.user.full_name },
          user_type: ->(data) { data.user.model_name.human },
          user_groups: ->(data) {
            groups = (data.user.try(:groups) || [])
            filtered_groups = groups.select { |group| group.begin_on.between?(@begin_on, @end_on) }
            filtered_groups.map(&:title).join(', ')
          },
          date: ->(data) { data.date.strftime('%d.%m.%y') },
          in_at: ->(data) { data.in_event.regdatefull.strftime('%H:%M:%S') },
          out_at: ->(data) { data.out_event && data.out_event.regdatefull.strftime('%H:%M:%S') },
          door_name: ->(data) { data.door.doorname }
        }
      end

      def build_title_row
        @columns.keys.map { |column_name| I18n.t(column_name, scope: %i(reports attendance)) }
      end

      def build_data_rows
        result = []
        (@begin_on..@end_on).each do |date|
          groupped_events = load_groupped_events(date)
          groupped_events.each do |user_and_door, events|
            events.each_slice(2) do |pair|
              data = OpenStruct.new(
                date: date,
                user: user_and_door[0],
                door: user_and_door[1],
                in_event: pair[0],
                out_event: pair[1]
              )
              result << @columns.values.map { |colum_func| colum_func.(data) }
            end
          end
        end
        result
      end

      def load_groupped_events(date)
        events = Db::Event.preload(:user, :door).where('CAST(regdate AS date) = ?', date)
        events = events.joins(:user).where(users: { uemail: @users_emails }) if @users_emails.present?
        Db::SdoUsersPreloader.new(events).preload
        events.select(&:sdo_user).sort_by(&:regdatefull).group_by { |event| [event.sdo_user, event.door] }
      end
    end
  end
end