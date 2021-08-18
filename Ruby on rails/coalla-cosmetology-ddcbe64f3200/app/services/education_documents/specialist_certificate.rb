module EducationDocuments
  class SpecialistCertificate < BaseDocument

    protected

    def write_certificate_content
      issued_at_text = "#{Russian.strftime(@issued_at, '%d %B %Y')} года"
      regular_text(@registration_number, 200, 870)
      regular_text(CITY_NAME, 200, 940)
      long_text(issued_at_text, -27, 1035)
      student_name_text
      commission_name_text(issued_at_text)
      course_name
    end

    def student_name_text
      names = student_name_parts(:nominative)
      bold_text(names[0].mb_chars.upcase, 850, 192) if names[0].present?
      other = names.drop(1).join(' ')
      bold_text(other, 850, 227) if other.present?
    end

    def commission_name_text(date_text)
      long_text('АНО ДПО', 850, 365)
      long_text('«Институт КЭМВИ-ДРК»', 850, 405)
      long_text("от #{date_text}", 850, 435)
    end

    def course_name
      name = @course.name_for_document(@student, @item)
      strings_array = word_wrap(name, line_width: 40).split("\n")
      long_text(strings_array[0], 850, 710)
      other = strings_array.drop(1).join(' ')
      long_text(other, 850, 750) if other.present?
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { size: 30, weight: Magick::LighterWeight, image_size: { x: 400, y: 100 } })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { size: 30, image_size: { x: 850, y: 100 } })
      composite!(text_image, left, right)
    end

    def bold_text(text, left, right)
      text_image = build_text_image(text, { font: BOLD_FONT, size: 30, image_size: { x: 850, y: 100 } })
      composite!(text_image, left, right)
    end
  end
end