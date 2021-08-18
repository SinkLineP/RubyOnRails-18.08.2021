module CoursesHelper

  def simple_format_course_price(course)
    if course.price_per_month > 0
      "#{format_money(course.price_per_month)}/мес".html_safe
    elsif course.total_price > 0
      "#{format_money(course.total_price)}".html_safe
    end
  end

  def format_course_price(course)
    if course.price_per_month > 0
      "от #{format_money(course.price_per_month)}/мес".html_safe
    elsif course.total_price > 0
      "от #{format_money(course.total_price)}".html_safe
    end
  end

  def course_small_image(course)
    course.small_image_url(:thumb).presence || 'https://placehold.it/260x260?text=∴'
  end

  def display_total_hours(course)
    display_hours(course.total_hours)
  end

  def display_passed_hours(course)
    display_hours(current_user.total_passed_hours(course))
  end

  def display_rest_hours(course)
    display_hours(current_user.total_rest_hours(course))
  end

  def display_hours(hours)
    "#{hours} #{pluralize_hours(hours)}"
  end

  def pluralize_hours(hours)
    hours = hours.to_i
    Russian.p(hours, 'час', 'часа', 'часов')
  end

  def display_minutes(minutes)
    minutes = minutes.to_i
    "#{minutes} #{Russian.p(minutes, 'минута', 'минуты', 'минут')}"
  end

  def display_total_tasks(course)
    count = course.total_tasks
    "#{count} #{Russian.p(count, 'задание', 'задания', 'заданий')}"
  end

  def display_course_counts(count)
    "#{count} #{Russian.p(count, 'занятие', 'занятия', 'занятий')}"
  end

  def material_image_tag(material)
    image_tag material.preview_url(:main) || 'material_image.png', alt: material.name.html_safe, class: 'book_cover'
  end

  def group_select(groups, selected = nil)
    select_options = options_for_select(groups.active.unscope(:order).ascending_name.map { |g| [g.title, g.id, {'data-students-count' => students_count(g)}] }, selected.try(:id))
    select_tag('group_ids[]', select_options, prompt: 'Выберите группу', class: 'selectordie js-group-select', data: {size: 5})
  end

  def students_count(group)
    "#{group.students_count} #{Russian.p(group.students_count, 'студент', 'студента', 'студентов')}"
  end

  def display_progress(course)
    "#{current_user.try(:progress_for_course, course).to_i}%"
  end

  def end_date_num
    end_date_components[0]
  end

  def end_date_month
    end_date_components[1]
  end

  def end_date_year
    end_date_components[2]
  end

  def result_name(result)
    I18n.t("activerecord.models.#{result.task.class.name.underscore}").mb_chars.downcase
  end

  def lecture_class(lecture, course)
    classes = []
    classes << 'open' if lecture == @lecture

    if current_user.try(:demo?)
      classes << 'passed'
    else
      classes << lecture_attributes(lecture, course)[0]
    end

    classes.join(' ')
  end

  def lecture_tooltip(lecture, course)
    return 'Демо-доступ' if current_user.try(:demo?)
    lecture_attributes(lecture, course)[1]
  end

  def block_class(block, course)
    return :passed if current_user.try(:demo?)
    block_attributes(block, course)[0]
  end

  def block_tooltip(block, course)
    return 'Демо-доступ' if current_user.try(:demo?)
    block_attributes(block, course)[1]
  end

  def course_marks_popup_id(course)
    "marks#{course.id}"
  end

  def block_name_with_number(course, block)
    "#{course.try(:block_position, block)}. #{block.name}"
  end

  private

  def end_date_components
    @end_date_components ||= create_date_components
  end

  def create_date_components
    return [] unless current_user.respond_to?(:group_subscription_for_course)
    end_date = current_user.group_subscription_for_course(@course).try(:end_on)
    return [] if end_date.blank?
    Russian::strftime(end_date, '%d %B %Y').split(/\s/)
  end

  BLOCK_ATTRIBUTES = {
      passed: ['', 'Блок пройден'],
      current: ['', 'Текущий блок'],
      unavailable: ['disabled', 'Блок еще не доступен']
  }

  def block_attributes(block, course)
    return [] unless current_user.respond_to?(:block_status)
    status = current_user.block_status(block, course)
    BLOCK_ATTRIBUTES[status]
  end

  def lecture_attributes(lecture, course)
    return '' unless current_user.respond_to?(:lecture_status)
    status = current_user.lecture_status(lecture, course)
    LECTURE_ATTRIBUTES[status]
  end

  def economy_text(course)
    course.groups_has_early_booking? && !course.economy.zero? ? course.economy.to_i : ''
  end

  def training_suspended_text(group_subscription)
    "Добрый день, #{group_subscription.student.first_name}. У вас есть задолженность по оплате обучения по курсу #{group_subscription.course.name} в размере #{format_money_without_wrap(group_subscription.current_debt_sum, 'руб')}. Пожалуйста, оплатите задолженность и сообщите об этом в учебную часть. Доступ сразу откроют.".html_safe
  end

  LECTURE_ATTRIBUTES = {
      passed: ['', 'Лекция пройдена'],
      current: ['', 'Текущая лекция'],
      unavailable: ['disabled', 'Лекция ещё не доступна']
  }

end
