module TasksHelper
  def lecture_link
    link_to 'ВЕРНУТЬСЯ К ЛЕКЦИИ', course_lecture_path(@course, @lecture), class: 'link__big'
  end

  def result_header
    @result.passed? || @result.on_mark? ? 'СПАСИБО' : 'РЕЗУЛЬТАТЫ'
  end

  def go_back_to_lecture_link
    link_to 'EЩЁ РАЗ ПРОЧИТАТЬ ЛЕЦИЮ И ПОПРОБОВАТЬ СНОВА', course_lecture_path(@course, @lecture), class: 'link_next'
  end

  def go_to_next_lecture_link(options = {})
    link_class = options.fetch(:class, 'link_next')
    link_text = options.fetch(:text, 'ПЕРЕЙТИ К СЛЕДУЮЩЕЙ ЛЕКЦИИ')
    next_lecture = current_user.current_lecture_for_course(@course)
    if course_not_finished?
      link_to link_text, course_lecture_path(@course, next_lecture), class: link_class
    else
      link_to 'Завершить курс', progress_path, class: link_class
    end
  end

  def course_not_finished?
    next_lecture = current_user.current_lecture_for_course(@course)
    next_lecture.present? && can?(:show, next_lecture, course: @course) && next_lecture != @task.lecture
  end

  def course_finished?
    !course_not_finished?
  end

  def contacts_link
    link_to 'СВЯЗАТЬСЯ С УЧЕБНОЙ ЧАСТЬЮ', feedback_path(course_id: @course.id), class: 'link_next'
  end
end