class StatisticForPeriodBuilder
  include ::ActiveSupport::NumberHelper
  include ApplicationHelper
  include ProgressHelper
  include MyStudentHelper
  include UserActivityHelper

  def run
    period = Date.new(2016, 9, 1)..Date.new(2017, 8, 31)
    scope = GroupSubscription.where(begin_on: period).actual.preload(:payments,
                                                                     :group,
                                                                     course: { blocks: { lectures: :task } },
                                                                     subscription_documents: :education_document,
                                                                     group: :payment_logs,
                                                                     student: [:results, student_work_results: :work])
    package = Axlsx::Package.new
    package.workbook.add_worksheet(name: 'Студенты') do |sheet|
      write_sheet_data(sheet, scope.to_a)
    end
    package.serialize('report.xlsx')
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
    sheet.add_row(['Фамилия',
                   'Имя',
                   'Основной email',
                   'Телефон',
                   'ID в AMO',
                   'Ответственный менеджер',
                   'Уровень образования',
                   'ID сделки в АМО',
                   'Дата сделки',
                   'Дата успешно реализовано',
                   'Время, проведенное в СДО по сделке',
                   'Задание',
                   'Попытка',
                   'Результат',
                   'Занятие',
                   'Результат занятия',
                   'Уч. группа',
                   'Уч. год',
                   'Дата нач. обуч.',
                   'Дата ок. обуч.',
                   'Даты практики',
                   'Время практики',
                   'Сумма договора',
                   'Скидки',
                   'Количество платежей',
                   'Выпускные документы готовы к выдаче (да/нет, по наличию галочки в СДО)',
                   'Приказ об отчислении',
                   'Приказ об академическом отпуске',
                   'Приказ о переводе в другую группу'],
                  style: style.default)

    group_subscriptions.each do |subscription|
      student = subscription.student
      course_activities = student.user_activities_for_course(subscription.course)
      total_time = course_activities.sum(&:spent_time)
      results_activities = course_activities.select(&:result?)
      results_activities.sort_by(&:last_tracked_at).each do |activity|
        sheet.add_row([
                        student.last_name,
                        student.first_name,
                        student.email,
                        student.phone,
                        student.amocrm_id,
                        subscription.responsible_name,
                        student.education_level.try(:title).to_s,
                        subscription.amocrm_id,
                        format_date(subscription.created_at),
                        format_date(subscription.sale_success_on),
                        display_total_time(total_time),
                        activity_name(activity),
                        activity.trackable.attempt_text,
                        result_description(activity.trackable),
                        '',
                        '',
                        subscription.group.try(:title).to_s,
                        subscription.try(:begin_on).try(:year).to_s,
                        format_date(subscription.try(:begin_on)),
                        format_date(subscription.try(:end_on)),
                        subscription.group.try(:all_practice_times_text).to_s,
                        subscription.group.try(:all_practice_dates_text).to_s,
                        subscription.price,
                        subscription.group_price && subscription.discount ? subscription.discount_amount : '',
                        subscription.payments.size,
                        subscription.subscription_documents.select(&:ready_to_issue).map { |sd| sd.education_document.title }.join(', '),
                        [subscription.subscription_contract.try(:number).to_s, format_date(subscription.subscription_contract.try(:created_on))].reject(&:blank?).join(', '),
                        [subscription.vacation_order.try(:number).to_s, format_date(subscription.vacation_order.try(:created_on))].reject(&:blank?).join(', '),
                        [subscription.change_group_order.try(:number).to_s, format_date(subscription.change_group_order.try(:created_on))].reject(&:blank?).join(', ')
                      ], style: style.default)
      end
      student.student_work_results_for_group(subscription.group).each do |student_work_result|
        sheet.add_row([
                        student.last_name,
                        student.first_name,
                        student.email,
                        student.phone,
                        student.amocrm_id,
                        subscription.responsible_name,
                        student.education_level.try(:title).to_s,
                        subscription.amocrm_id,
                        format_date(subscription.created_at),
                        format_date(subscription.sale_success_on),
                        display_activity_total_time(student, subscription.course),
                        '',
                        '',
                        '',
                        student_work_result.work_title,
                        student_work_result.display_total_mark,
                        subscription.group.try(:title).to_s,
                        subscription.try(:begin_on).try(:year).to_s,
                        format_date(subscription.try(:begin_on)),
                        format_date(subscription.try(:end_on)),
                        subscription.group.try(:all_practice_times_text).to_s,
                        subscription.group.try(:all_practice_dates_text).to_s,
                        subscription.price,
                        subscription.group_price && subscription.discount ? subscription.discount_amount : '',
                        subscription.payments.size,
                        subscription.subscription_documents.select(&:ready_to_issue).map { |sd| sd.education_document.title }.join(', '),
                        [subscription.subscription_contract.try(:number).to_s, format_date(subscription.subscription_contract.try(:created_on))].reject(&:blank?).join(', '),
                        [subscription.vacation_order.try(:number).to_s, format_date(subscription.vacation_order.try(:created_on))].reject(&:blank?).join(', '),
                        [subscription.change_group_order.try(:number).to_s, format_date(subscription.change_group_order.try(:created_on))].reject(&:blank?).join(', ')
                      ], style: style.default)
      end
    end
  end

  def result_description(result)
    return 'Не сдан. Время истекло' if result.time_expired?
    return 'Ожидает оценки' if result.on_mark?
    if result.passed?
      "Сдано. Оценка: #{result.mark} из #{result.max_mark}"
    else
      "Не сдано. Оценка: #{result.mark} из #{result.max_mark}"
    end
  end
end