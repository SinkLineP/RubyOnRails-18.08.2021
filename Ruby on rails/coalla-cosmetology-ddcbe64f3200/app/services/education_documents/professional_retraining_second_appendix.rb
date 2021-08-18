module EducationDocuments
  class ProfessionalRetrainingSecondAppendix < RetrainingSecondAppendix

    protected

    def write_certificate_content
      @course_works = @course.course_works.main_ordered

      @position_y = 415
      @course_works.each_with_index do |course_work, idx|
        work(idx + 1, course_work)
        break if @position_y >= 2750
      end

      regular_text("#{@course.academic_hours_for_document(@student, @item)} ак.ч.", 930, 2900)
      long_small_text('М.П.', 1160, 3100)
      long_small_text('Ректор (директор)', 1460, 3000)
      long_small_text('Секретарь', 1395, 3100)
    end

    def certificate_filename
      'retraining_second_appendix'
    end

  end
end