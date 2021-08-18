module EducationDocuments
  class WallDiploma < BaseDocument

    protected

    def write_certificate_content
      arial_text(@registration_number, 746, 3213)
      student_name_text
      group_range_text
      course_name
      small_text("(#{@course.academic_hours_for_document(@student, @item)} ак.ч.)", 1500, 2600)
    end

    def student_name_text
      names = student_name_parts(:dative)
      other = names.drop(1).join(' ')
      other.length > 24 ? course_name_text(names[0], 250, 1350) : long_text(names[0], 250, 1350) if names[0].present?
      return if other.blank?
      other.length > 24 ? course_name_text(other, 250, 1500) : long_text(other, 250, 1500)
    end

    def group_range_text
      regular_text(education_time_text(@begin_on, @end_on), 250, 1695)
    end

    def course_name
      name = @course.name_for_document(@student, @item)
      str = "«#{name}»"
      strings_array = word_wrap(str, line_width: 30).split("\n").first(3)
      position = 2130
      strings_array.each_with_index { |text, idx| course_name_text(text, 250, position + 130 * idx) }
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { font: PHILOSOPHER_FONT, size: 74, image_size: { x: 2000, y: 200 }, color: '#7E4C1D' })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { font: PHILOSOPHER_FONT, size: 160, image_size: { x: 2000, y: 200 }, color: '#7E4C1D' })
      composite!(text_image, left, right)
    end

    def course_name_text(text, left, right)
      text_image = build_text_image(text, { font: PHILOSOPHER_FONT, size: 120, image_size: { x: 2000, y: 200 }, color: '#7E4C1D' })
      composite!(text_image, left, right)
    end

    def arial_text(text, left, right)
      text_image = build_text_image(text, { font: ARIAL_FONT, size: 60, image_size: { x: 1000, y: 200 } })
      composite!(text_image, left, right)
    end

    def small_text(text, left, right)
      text_image = build_text_image(text, { font: PHILOSOPHER_FONT, size: 60, image_size: { x: 1000, y: 100 }, color: '#7E4C1D' })
      composite!(text_image, left, right)
    end
  end
end