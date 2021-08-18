module EducationDocuments
  class ModuleCertificate < BaseDocument

    protected

    def write_certificate_content
      @position_y = 1265
      arial_text(@registration_number, 1255, 2210)
      regular_text('Выдан', -350, 900)
      student_name_text
      group_range_text
      course_name
      course_modules_text
    end

    def student_name_text
      names = student_name_parts(:dative)
      long_big_text(names.join(' '), 750, 900) if names.present?
    end

    def group_range_text
      long_text("в том, что #{education_time_text(@begin_on, @end_on)}", 600, 1015)
    end

    def course_name
      name = @course.name_for_document(@student, @item)
      str = "по программе: «#{name}»"
      strings_array = word_wrap(str, line_width: 60).split("\n").first(3)
      strings_array.each do |text|
        long_text(text, 600, @position_y)
        @position_y += 85
      end
    end

    def course_modules_text
      if @course.blocks.count > 1
        blocks_count = @course.blocks.first(6).count
        size = 80 - blocks_count * 4
        position_change = 82 - blocks_count * 5
        @course.blocks.first(6).each do |block|
          small_text("модуль «#{block_name(block.name)}» (#{block.lectures.sum(:time)} ак.ч.)", 600, @position_y + 38, size)
          @position_y += position_change
        end
      else
        regular_text("(#{@course.hours} ак.ч.)", 1900, 1600)
      end
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { font: PHILOSOPHER_FONT, size: 74, image_size: { x: 2000, y: 200 }, color: '#7E4C1D' })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { font: PHILOSOPHER_FONT, size: 74, image_size: { x: 2300, y: 200 }, color: '#7E4C1D' })
      composite!(text_image, left, right)
    end

    def long_big_text(text, left, right)
      text_image = build_text_image(text, { font: PHILOSOPHER_FONT, size: 100, image_size: { x: 2300, y: 200 }, color: '#7E4C1D' })
      composite!(text_image, left, right)
    end

    def arial_text(text, left, right)
      text_image = build_text_image(text, { font: ARIAL_FONT, size: 60, image_size: { x: 1000, y: 200 } })
      composite!(text_image, left, right)
    end

    def small_text(text, left, right, size = 54)
      text_image = build_text_image(text, { font: PHILOSOPHER_FONT, size: size, image_size: { x: 2300, y: 100 }, color: '#7E4C1D' })
      composite!(text_image, left, right)
    end
  end
end