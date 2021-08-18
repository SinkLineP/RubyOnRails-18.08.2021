module EducationDocuments
  class RetrainingFirstAppendix < BaseDocument

    protected

    def write_certificate_content
      regular_text(@registration_number, 1430, 270)
      name_text
      education_level_title
      group_range_text
      institution_name_text
      course_name
      traineeship_institution_name_text
      graduation_work_name_text
    end

    def registration_date_text(date)
      date_array = Russian.strftime(date, '%d %b %y').split
      italic_text(date_array[0], 185, 880)
      italic_text(date_array[1], 260, 880, 200)
      italic_text(date_array[2], 490, 880)
    end

    def attestation_date_text(date)
      date_array = Russian.strftime(date, '%d %b %Y').split
      regular_text(date_array[0], 1125, 670)
      long_text("#{date_array[1]} #{date_array[2]}", 1070, 670)
    end

    def name_text
      names = student_name_parts(:nominative)
      long_text(names[0].to_s, 375, 430) if names[0].present?
      long_text(names[1].to_s, 375, 605) if names[1].present?
      long_text(names.drop(2).join(' ').to_s, 375, 780) if names.drop(2).present?
    end

    def group_range_text
      start_date, end_date = Russian.strftime(@begin_on, '%d %B %Y'), Russian.strftime(@end_on, '%d %B %Y')
      start_date_array, end_date_array = start_date.split, end_date.split
      regular_text(start_date_array[0], -275, 1360)
      regular_text(start_date_array[1], 40, 1360)
      regular_text(start_date_array[2], 308, 1360)
      regular_text(end_date_array[0], 595, 1360)
      regular_text(end_date_array[1], 860, 1360)
      regular_text(end_date_array[2], 1140, 1360)
    end

    def institution_name_text
      regular_text('АНО ДПО "Институт', 1285, 1565)
      long_text('косметологии, эстетической медицины и визажного искусства -', 130, 1735)
      long_text('Дом Русской Косметики"', 130, 1918)
    end

    def traineeship_institution_name_text
      long_text('АНО ДПО "Институт косметологии,', 450, 2440)
      long_text('эстетической медицины и визажного искусства - Дом Русской Косметики"', 130, 2625)
    end

    def graduation_work_name_text
      long_text('"Комплексная программа коррекции', 450, 2823)
      long_text('морфофункциональных изменений покровных тканей лица и тела"', 130, 3000)
    end

    def education_level_title
      education_level = @student.education_level
      return unless education_level
      str = education_level.education_document_name.presence || education_level.title
      strings_array = word_wrap(str, line_width: 40).split("\n")
      long_text(strings_array[0], 530, 990)
      other = strings_array.drop(1).join(' ')
      long_text(other, 130, 1160) if other.present?
    end

    def course_name
      name = @course.name_for_document(@student, @item)
      strings_array = word_wrap(name, line_width: 50).split("\n")
      long_text(strings_array[0], 270, 2100)
      other = strings_array.drop(1).join(' ')
      long_text(other, 130, 2275) if other.present?
    end

    def regular_text(text, left, right)
      text_image = build_text_image(text, { size: 60, weight: Magick::LighterWeight, image_size: { x: 1000, y: 120 } })
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image(text, { size: 60, image_size: { x: 2200, y: 120 } })
      composite!(text_image, left, right)
    end
  end
end