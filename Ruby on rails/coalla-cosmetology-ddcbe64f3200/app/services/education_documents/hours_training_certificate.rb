module EducationDocuments
  class HoursTrainingCertificate < BaseDocument

    protected

    def write_certificate_content
      bold_text(@registration_number, 530, 1600)
      regular_text(CITY_NAME, 530, 1765)
      registration_date_text
      name_text
      group_range_text
      institute_name
      course_name
      long_text(program_volume(@course.academic_hours_for_document(@student, @item)), 1600, 1740)
    end

    def registration_date_text
      date_array = Russian.strftime(@issued_at, '%d %B %y').split
      regular_text(date_array[0], 210, 1940)
      regular_text(date_array[1], 520, 1940)
      regular_text(date_array[2], 830, 1940)
    end

    def group_range_text
      start_date, end_date = Russian.strftime(@begin_on, '%d %B %Y'), Russian.strftime(@end_on, '%d %B %Y')
      regular_text("с #{start_date}", 1900, 1400)
      regular_text(end_date, 2420, 1400)
    end

    def name_text
      names = student_name_parts(:nominative)
      long_text(names.join(' '), 1600, 320)
    end

    def course_name
      name = @course.name_for_document(@student, @item)
      str = "по программе \"#{name}\""
      strings_array = word_wrap(str, line_width: 56).split("\n").first(7)
      position = 1200
      strings_array.each_with_index { |text, idx| long_text(text, 1600, position + 50 * idx) }
    end

    def institute_name
      long_text('АНО ДПО «Институт косметологии, эстетической', 1600, 700)
      long_text('медицины и визажного искусства –', 1600, 750)
      long_text('Дом Русской Косметики»', 1600, 800)
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { size: 52, weight: Magick::LighterWeight, image_size: { x: 800, y: 100 } })
      composite!(text_image, left, right)
    end

    def bold_text(text, left, right)
      text_image = build_text_image(text, { size: 52, font: BOLD_FONT, image_size: { x: 800, y: 100 } })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { size: 52, image_size: { x: 2000, y: 100 } })
      composite!(text_image, left, right)
    end
  end
end