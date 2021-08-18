module Reports
  class Modules
    include ApplicationHelper
    include Documents::DocumentsHelper

    def generate
      courses_ids = Course.where(short_name: %w(K KO KOV KV KC SK)).pluck(:id)
      scope = GroupSubscription.joins(:group)
                .preload(:course, :student, :amo_module, group: :practices)
                .actual.not_expelled.not_academic_vacation
                .where('group_subscriptions.end_on > ?', Date.current)
                .where(groups: { course_id: courses_ids })
                .order('groups.title, group_subscriptions.id')
      package = Axlsx::Package.new
      package.workbook.add_worksheet(name: 'Студенты') do |sheet|
        write_sheet_data(sheet, scope.to_a)
      end
      package
    end

    private

    def write_sheet_data(sheet, group_subscriptions)
      style = OpenStruct.new(default: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER),
                             title: sheet.styles.add_style(border: Axlsx::STYLE_THIN_BORDER,
                                                           b: true,
                                                           alignment: {
                                                             horizontal: :center
                                                           }))

      #header
      sheet.add_row(['ФИО студента',
                     'Группа',
                     'Дата начала обучения',
                     'Дата окончания обучения',
                     'Даты практики',
                     'Модуль',
                     'Модуль поставлен в расписание'],
                    style: style.default)

      #rows
      group_subscriptions.each do |subscription|
        sheet.add_row([
                        subscription.student.full_name,
                        subscription.group.title,
                        format_date(subscription.begin_on),
                        format_date(subscription.end_on),
                        practices_education_dates_text(subscription.group.practices),
                        subscription.amo_module.try(:title) || 'Модуль не выбран',
                        ''
                      ],
                      style: style.default)
      end
    end
  end
end