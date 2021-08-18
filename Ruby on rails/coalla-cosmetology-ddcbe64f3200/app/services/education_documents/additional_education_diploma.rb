module EducationDocuments
  class AdditionalEducationDiploma < BaseDocument

    def first_appendix
      AdditionalEducationFirstAppendix.new(@item).generate
    end

    protected

    def write_certificate_content
      small_text(LICENSE_NUMBER_FIRST, 460, 1770)
      small_text(LICENSE_NUMBER_SECOND, 460, 1815)
      regular_text(@registration_number, 1985, 415)
      student_name_text
      group_range_text
      institution_name_text
      faculty_title if @course.faculty_title.present?
      course_name
      regular_text(@issued_at.strftime('%Y'), 1970, 1950)
    end

    def group_range_text
      start_date, end_date = Russian.strftime(@begin_on, '%d %B %y'), Russian.strftime(@end_on, '%d %B %y')
      start_date_array, end_date_array = start_date.split, end_date.split
      regular_text(start_date_array[0], 1546, 697)
      regular_text(start_date_array[1], 1740, 697)
      regular_text(start_date_array[2], 1967, 697)
      regular_text(end_date_array[0], 2118, 697)
      regular_text(end_date_array[1], 2310, 697)
      regular_text(end_date_array[2], 2540, 697)
    end

    def student_name_text
      names = student_name_parts(:dative)
      long_text(names[0], 1770, 535) if names[0].present?
      other = names.drop(1).join(' ')
      long_text(other, 1600, 623) if other.present?
    end

    def institution_name_text
      italic_text('АНО ДПО', 1700, 795)
      italic_text('«Институт КЭМВИ-ДРК»', 1570, 882)
    end

    def faculty_title
      str = "факультете #{@course.faculty_title.mb_chars.downcase}"
      strings_array = word_wrap(str, line_width: 45).split("\n").first(4)
      long_text(strings_array[0], 1622, 965)
      strings_array.drop(1).each_with_index do |string, idx|
        long_text(string, 1570, 1048 + 74 * idx)
      end
    end

    def course_name
      name = @course.name_for_document(@student, @item)
      strings_array = word_wrap(name, line_width: 40).split("\n").first(4)
      long_text(strings_array[0], 1685, 1292)
      strings_array.drop(1).each_with_index do |string, idx|
        long_text(string, 1570, 1368 + 74 * idx)
      end
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { size: 54, weight: Magick::LighterWeight, image_size: { x: 600, y: 100 } })
      composite!(text_image, left, right)
    end

    def italic_text(text, left, right)
      text_image = build_text_image(text, { font: ITALIC_FONT, size: 54, image_size: { x: 1200, y: 100 } })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { size: 54, image_size: { x: 1200, y: 100 } })
      composite!(text_image, left, right)
    end

    def small_text(text, left, right)
      text_image = build_text_image(text, { size: 44, image_size: { x: 600, y: 100 } })
      composite!(text_image, left, right)
    end

  end
end