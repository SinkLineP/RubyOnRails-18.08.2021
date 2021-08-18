module EducationDocuments
  class RetrainingCertificate < BaseDocument

    def first_appendix
      RetrainingFirstAppendix.new(@item).generate
    end

    def second_appendix
      RetrainingSecondAppendix.new(@item).generate
    end

    protected

    def write_certificate_content
      regular_text(@registration_number, 380, 858)
      registration_date_text(@issued_at)
      regular_text(CITY_NAME, 315, 973)
      long_small_text(LICENSE_NUMBER_FIRST, 160, 1028)
      long_small_text(LICENSE_NUMBER_SECOND, 160, 1058)
      name_text
      group_range_text
      institution_name_text
      attestation_date_text
      course_name
      long_text(student_name_parts(:genitive).join(' '), 900, 710)
      diploma_title
    end

    private

    def registration_date_text(date)
      date_array = Russian.strftime(date, '%d %B %y').split
      italic_text(date_array[0], 178, 910)
      italic_text(date_array[1], 265, 910, 200)
      italic_text(date_array[2], 500, 910)
    end

    def attestation_date_text
      date_array = Russian.strftime(@issued_at, '%d %B %Y').split
      regular_text(date_array[0], 1180, 632)
      long_text("#{date_array[1]} #{date_array[2]}", 1100, 632)
    end

    def name_text
      names = student_name_parts(:dative)
      long_text(names[0].to_s, 1000, 233)
      long_text("#{names.drop(1).join(' ')}", 900, 278)
    end

    def group_range_text
      start_date, end_date = Russian.strftime(@begin_on, '%d %B %Y'), Russian.strftime(@end_on, '%d %B %Y')
      start_date_array, end_date_array = start_date.split, end_date.split
      regular_text(start_date_array[0], 987, 323)
      regular_text("#{start_date_array[1]} #{start_date_array[2]}", 1095, 323)
      regular_text(end_date_array[0], 1253, 323)
      regular_text("#{end_date_array[1]} #{end_date_array[2]}", 1355, 323)
    end

    def institution_name_text
      regular_text('АНО ДПО', 1345, 365)
      long_text('"Институт косметологии, эстетической медицины и ', 900, 413)
      long_text('визажного искусства - Дом Русской Косметики"', 900, 457)
    end

    def course_name
      name = @course.name_for_document(@student, @item)
      str = "программе #{name}"
      strings_array = word_wrap(str, line_width: 60).split("\n").first(3)
      position = 500
      strings_array.each_with_index { |text, idx| long_small_text(text, 900, position + 40 * idx) }
    end

    def diploma_title
      document_name = @course.diploma_title_for_document(@student, @item)
      title = document_name.presence || SPHERE
      strings_array = word_wrap(title, line_width: 46).split("\n").first(3)
      position = 802
      strings_array.each_with_index { |text, idx| long_text(text, 900, position + 30 * idx) }
    end

    def long_small_text(text, left, right)
      text_image = build_text_image(text, { size: 20, image_size: { x: 600, y: 100 } })
      composite!(text_image, left, right)
    end
  end
end