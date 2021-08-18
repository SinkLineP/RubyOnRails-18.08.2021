module EducationDocuments
  class BarbershopDiploma < BaseDocument

    protected

    def write_certificate_content
      student_name_text
      group_range_text
      @position_y = 1780
      course_title
      regular_bold_text(@registration_number, 800, 3165)
    end

    def student_name_text
      names = student_name_parts(:nominative)
      return unless names.present?
      long_big_text(names[0], 280, 1230, 142)
      long_big_text(names.drop(1).join(' '), 305, 1400, 142)
    end

    def group_range_text
      long_text("#{education_time_text(@begin_on, @end_on)}", 300, 1600)
      long_text('прошел(а) обучение по программе', 300, 1690)
    end

    def course_title
      word_wrap("«#{@course.name_for_document(@student, @item)}»", line_width: 34).split("\n").each do |str|
        long_big_text(str, 300, @position_y)
        @position_y += 90
      end
    end

    def regular_bold_text(text, left, right)
      text_image = build_text_image(text, { font: BOLD_MONOTYPE_FONT, size: 50, image_size: { x: 1000, y: 200 }, color: '#000000' })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { font: MONOTYPE_FONT, size: 70, image_size: { x: 2000, y: 400 }, color: '#000000' })
      composite!(text_image, left, right)
    end

    def long_big_text(text, left, right, size = 75)
      text_image = build_text_image(text, { font: BOLD_MONOTYPE_FONT, size: size, image_size: { x: 2000, y: 400 }, color: '#000000' })
      composite!(text_image, left, right)
    end
  end
end