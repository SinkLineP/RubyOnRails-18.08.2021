module EducationDocuments
  class TrainingCertificate < BaseDocument

    protected

    def write_certificate_content
      @course_works = @course.course_works.main_ordered

      small_text(LICENSE_NUMBER_FIRST, 530, 2265)
      small_text(LICENSE_NUMBER_SECOND, 530, 2320)
      regular_text(@registration_number, 2410, 510)
      name_text
      group_range_text
      course_name
      regular_text("#{@course.academic_hours_for_document(@student, @item)} ак. ч.", 2100, 1305)
      regular_text(@issued_at.strftime('%Y'), 2339, 2255)

      @position = 1630
      @course_works.first(6).each do |course_work|
        work(course_work)
      end
    end

    def registration_date_text(date)
      date_array = Russian.strftime(date, '%d %b %y').split
      italic_text(date_array[0], 215, 855)
      italic_text(date_array[1], 290, 855, 200)
      italic_text(date_array[2], 520, 855)
    end

    def name_text
      names = student_name_parts(:dative)
      long_text(names[0].to_s, 2200, 618)
      long_text("#{names.drop(1).join(' ')}", 1900, 722)
    end

    def group_range_text
      start_date, end_date = Russian.strftime(@begin_on, '%d %B %Y'), Russian.strftime(@end_on, '%d %B %Y')
      start_date_array, end_date_array = start_date.split, end_date.split
      regular_text(start_date_array[0], 2088, 810)
      regular_text("#{start_date_array[1]} #{start_date_array[2]}", 2330, 810)
      regular_text(end_date_array[0], 2727, 810)
      regular_text("#{end_date_array[1]} #{end_date_array[2]}", 2947, 810)
    end

    def course_name
      name = @course.name_for_document(@student, @item)
      str = "программе #{name}"
      strings_array = word_wrap(str, line_width: 80).split("\n").first(3)
      position = 1150
      strings_array.each_with_index { |text, idx| long_text(text, 1865, position + 72 * idx, 1400, 38) }
    end

    def work(course_work)
      work_name(course_work.title)
      marks_text(course_work.hours.to_s, 2440, @position)

      student_work_result = @student.student_work_results_for_group(@group_subscription.group).sort_by { |s| s.total_mark }.reverse.detect { |w| w.work == course_work.work }
      mark = course_work.lecture.present? ? @student.best_result_for_lecture(course_work.lecture).try(:percent).try(:to_i) : student_work_result.try(:display_total_mark)
      marks_text(mark.to_s, 2760, @position)
      @position += 62
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { size: 52, weight: Magick::LighterWeight, image_size: { x: 400, y: 100 } })
      composite!(text_image, left, right)
    end

    def small_text(text, left, right)
      text_image = build_text_image(text, { size: 46, weight: Magick::LighterWeight, image_size: { x: 800, y: 100 } })
      composite!(text_image, left, right)
    end

    def marks_text(text, left, right)
      text_image = build_text_image(text, { size: 40, weight: Magick::LighterWeight, image_size: { x: 800, y: 100 } })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right, width = 1400, font_size = 52)
      text_image = build_text_image(text, { size: font_size, image_size: { x: width, y: 100 } })
      composite!(text_image, left, right)
    end

    def work_name_text(text, left, right)
      text_image = build_text_image(text, { size: 30, image_size: { x: 800, y: 100 }, gravity: Magick::WestGravity })
      composite!(text_image, left, right)
    end

    def work_name(text)
      strings_array = word_wrap(text, line_width: 38).split("\n")
      work_name_text(strings_array[0], 1870, @position)
      other = strings_array.drop(1).join(' ')
      work_name_text(other, 1870, @position + 22) if other.present?
    end
  end
end