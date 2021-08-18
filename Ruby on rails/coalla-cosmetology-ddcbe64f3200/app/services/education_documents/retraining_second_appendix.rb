module EducationDocuments
  class RetrainingSecondAppendix < BaseDocument

    protected

    def write_certificate_content
      @course_works = @course.course_works

      @position_y = 415
      @course_works.each_with_index do |course_work, idx|
        work(idx + 1, course_work)
        break if @position_y >= 2750
      end

      regular_text("#{@course.academic_hours_for_document(@student, @item)} ак.ч.", 930, 2900)
      long_small_text('М.П.', 1160, 3100)
      long_small_text('Ректор (директор)', 1460, 3000)
      long_small_text('Секретарь', 1395, 3100)
    end

    def work(idx, course_work)
      student_work_result = @student.student_work_results_for_group(@group_subscription.group).sort_by { |s| s.total_mark }.reverse.detect { |w| w.work == course_work.work }

      regular_text(idx.to_s, 175, @position_y)
      regular_text(course_work.hours.to_s, 1400, @position_y)

      mark = course_work.lecture.present? ? @student.best_result_for_lecture(course_work.lecture).try(:percent).try(:to_i) : student_work_result.try(:display_total_mark)
      regular_text(mark == 0 ? '' : mark.to_s, 1900, @position_y)

      work_title = course_work.work.final_work? ? 'Выпускная работа' : course_work.title
      work_name(work_title)
    end

    def work_name(name)
      strings_array = word_wrap(name, line_width: 38).split("\n")
      strings_array.each do |text|
        left_long_text(text, 475, @position_y)
        @position_y += 55
      end
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { size: 48, weight: Magick::LighterWeight, image_size: { x: 400, y: 100 } })
      composite!(text_image, left, right)
    end

    def left_long_text(text, left, right)
      text_image = build_text_image(text, { size: 48, image_size: { x: 1000, y: 100 }, gravity: Magick::WestGravity })
      composite!(text_image, left, right)
    end

    def long_small_text(text, left, right)
      text_image = build_text_image(text, { size: 36, weight: Magick::LighterWeight, image_size: { x: 400, y: 100 } })
      composite!(text_image, left, right)
    end
  end
end