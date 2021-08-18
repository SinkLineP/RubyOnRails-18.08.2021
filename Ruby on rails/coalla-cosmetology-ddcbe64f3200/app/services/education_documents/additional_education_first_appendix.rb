module EducationDocuments
  class AdditionalEducationFirstAppendix < BaseDocument

    protected

    def write_certificate_content
      @course_works = @course.course_works
      course_name
      name_text
      long_text('изучил(а) нижеперечисленные дисциплины и прошел(а) промежуточную аттестацию по дисциплинам:', 215, 1052)
      regular_text('В.Е. Бельченко', 1500, 3200)
      total_hours_text

      @position_y = 1320
      @course_works.each_with_index do |course_work, idx|
        work(idx + 1, course_work)
        @position_y += 70
        break if idx >= 22
      end
    end

    def name_text
      names = student_name_parts(:nominative).join(' ')
      big_bold_text(names, 215, 988)
    end

    def total_hours_text
      hours = @course.academic_hours_for_document(@student, @item)
      bold_text('ИТОГО:', 1360, 3000)
      bold_text(hours.to_s, 1630, 3000)
      position = 3000
      program_volume_text(hours).split.each do |str|
        left_bold_text(str, 2000, position)
        position += 50
      end
    end

    def work(idx, course_work)
      student_work_result = @student.student_work_results_for_group(@group_subscription.group).sort_by { |s| s.total_mark }.reverse.detect { |w| w.work == course_work.work }

      bold_text(idx.to_s, 125, @position_y)
      if student_work_result
        work_title = student_work_result.work.final_work? ? 'Выпускная работа' : student_work_result.work_title
      else
        work_title = course_work.work.title
      end
      left_regular_text(work_title, 400, @position_y)
      regular_text(course_work.hours.to_s, 1240, @position_y)

      mark = course_work.lecture.present? ? @student.best_result_for_lecture(course_work.lecture).try(:percent).try(:to_i) : student_work_result.try(:display_total_mark)
      regular_text(mark.to_s, 1578, @position_y)
    end

    def course_name
      position = 832
      name = @course.name_for_document(@student, @item)
      word_wrap("«#{name}»", line_width: 50).split("\n").first(2).each_with_index do |str, idx|
        big_bold_text(str, 215, position + 80 * idx)
      end
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { size: 46, weight: Magick::LighterWeight, image_size: { x: 1200, y: 100 } })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { size: 46, image_size: { x: 2200, y: 100 } })
      composite!(text_image, left, right)
    end

    def big_bold_text(text, left, right)
      text_image = build_text_image(text, { font: BOLD_FONT, size: 66, image_size: { x: 2200, y: 100 } })
      composite!(text_image, left, right)
    end

    def bold_text(text, left, right)
      text_image = build_text_image(text, { font: BOLD_FONT, size: 46, image_size: { x: 400, y: 100 } })
      composite!(text_image, left, right)
    end

    def left_bold_text(text, left, right)
      text_image = build_text_image(text, { font: BOLD_FONT, size: 46, image_size: { x: 400, y: 100 }, gravity: Magick::WestGravity })
      composite!(text_image, left, right)
    end

    def left_regular_text(text, left, right)
      text_image = build_text_image(text, { size: 46, image_size: { x: 1280, y: 100 }, gravity: Magick::WestGravity })
      composite!(text_image, left, right)
    end
  end
end