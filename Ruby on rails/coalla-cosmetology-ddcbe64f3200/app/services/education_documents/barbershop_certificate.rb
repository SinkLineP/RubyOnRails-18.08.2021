module EducationDocuments
  class BarbershopCertificate < BaseDocument

    protected

    def write_certificate_content
      student_name_text
      group_range_text
      long_big_text("«#{@course.name_for_document(@student, @item)}»", 415, 1465)
      @position_y = 1562
      course_modules_text
      regular_bold_text(@registration_number, 2640, 2185)
    end

    def student_name_text
      names = student_name_parts(:nominative)
      return unless names.present?
      long_big_text(names[0], 395, 1034, 160)
      long_big_text(names.drop(1).join(' '), 415, 1203, 160)
    end

    def group_range_text
      long_text("#{education_time_text(@begin_on, @end_on)} прошел(а) обучение по программе", 415, 1380)
    end

    def course_modules_text
      @course.blocks.each do |block|
        module_text("модуль «#{block_name(block.name)}» (#{block.lectures.sum(:time)} ак.ч.)")
      end
    end

    def module_text(text)
      parts = word_wrap(text, line_width: 80).split("\n")
      last_part_coordinate = @position_y + 90 * (parts.count - 1)
      return if last_part_coordinate > 1922
      parts.each do |str|
        long_text(str, 415, @position_y)
        @position_y += 90
      end
    end

    def regular_bold_text(text, left, right)
      text_image = build_text_image(text, { font: BOLD_MONOTYPE_FONT, size: 50, image_size: { x: 1000, y: 200 }, color: '#000000' })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { font: MONOTYPE_FONT, size: 66, image_size: { x: 2800, y: 400 }, color: '#000000' })
      composite!(text_image, left, right)
    end

    def long_big_text(text, left, right, size = 75)
      text_image = build_text_image(text, { font: BOLD_MONOTYPE_FONT, size: size, image_size: { x: 2800, y: 400 }, color: '#000000' })
      composite!(text_image, left, right)
    end
  end
end