module EducationDocuments
  class BaseDocument
    include CertificateHelper
    include ActionView::Helpers::TextHelper

    REGULAR_FONT_PATH = File.join(Rails.root, 'lib', 'fonts', 'Times_New_Roman_Cyr.ttf')
    REGULAR_FONT = Pathname.new(REGULAR_FONT_PATH).relative_path_from(Pathname.pwd)
    ITALIC_FONT_PATH = File.join(Rails.root, 'lib', 'fonts', 'Times_Italic.ttf')
    ITALIC_FONT = Pathname.new(ITALIC_FONT_PATH).relative_path_from(Pathname.pwd)
    BOLD_FONT_PATH = File.join(Rails.root, 'lib', 'fonts', 'Times_New_Roman_Bold.ttf')
    BOLD_FONT = Pathname.new(BOLD_FONT_PATH).relative_path_from(Pathname.pwd)
    PHILOSOPHER_FONT_PATH = File.join(Rails.root, 'lib', 'fonts', 'Philosopher_Regular.ttf')
    PHILOSOPHER_FONT = Pathname.new(PHILOSOPHER_FONT_PATH).relative_path_from(Pathname.pwd)
    ARIAL_FONT_PATH = File.join(Rails.root, 'lib', 'fonts', 'Arial.ttf')
    ARIAL_FONT = Pathname.new(ARIAL_FONT_PATH).relative_path_from(Pathname.pwd)
    MONOTYPE_FONT_PATH = File.join(Rails.root, 'lib', 'fonts', 'Monotype_Posterama_Text.ttf')
    MONOTYPE_FONT = Pathname.new(MONOTYPE_FONT_PATH).relative_path_from(Pathname.pwd)
    BOLD_MONOTYPE_FONT_PATH = File.join(Rails.root, 'lib', 'fonts', 'Monotype_Posterama_Text_Bold.ttf')
    BOLD_MONOTYPE_FONT = Pathname.new(BOLD_MONOTYPE_FONT_PATH).relative_path_from(Pathname.pwd)
    CITY_NAME = 'Москва'
    LICENSE_NUMBER_FIRST = '77Л010010389,'
    LICENSE_NUMBER_SECOND = 'р.н. 039512 от 25.07.2018'
    SPHERE = 'косметологии'

    def initialize(item)
      @item = item
      @group_subscription = @item.group_subscription
      @student = @group_subscription.student
      @course = @item.course
      @issued_at = @item.issued_at || Date.current
      @registration_number = @item.registration_number.to_s
      if @course == @group_subscription.course
        @begin_on = @group_subscription.begin_on
        @end_on = @group_subscription.end_on
      else
        @begin_on = @issued_at - 10.days
        @end_on = @issued_at + 10.days
      end
    end

    def generate
      open_certificate_image
      write_certificate_content
      save_to_file
    end

    def first_appendix
      #hook
    end

    def second_appendix
      #hook
    end

    protected

    def open_certificate_image
      image_path = Rails.root.join('lib', 'documents', 'templates', "#{certificate_filename}.jpg")
      @certificate_image = Magick::Image.read(image_path).first
    end

    def save_to_file
      folder_path = create_folders
      certificate_path = File.join(folder_path,  "#{certificate_filename}.jpg")
      file = @certificate_image.write(certificate_path)
      File.open(file.filename)
    end

    def certificate_filename
      self.class.name.demodulize.underscore
    end

    def write_certificate_content
      #hook
    end

    def create_folders
      certificates_folder = "#{Rails.root.to_s}/documents/certificates"
      user_folder = certificates_folder + "/#{@group_subscription.student_id}"
      subscription_folder = user_folder + "/#{@group_subscription.id}"
      FileUtils.mkdir_p(subscription_folder)
    end

    def build_text_image(text, options = {})
      gc = Magick::Draw.new
      gc.font(options[:font] || REGULAR_FONT)
      gc.font_size(options[:size])
      gc.font_weight(options[:weight] || Magick::NormalWeight)
      gc.font_stretch(options[:stretch] || Magick::ExpandedStretch)
      gc.fill(options[:color] || 'black')
      gc.gravity(options[:gravity] ||= Magick::CenterGravity)
      gc.text(0, options[:text_offset] || 0, text.to_s) if text.present?
      text_image = Magick::Image.new(options[:image_size][:x], options[:image_size][:y]) { |i| i.background_color= 'Transparent' }
      gc.draw(text_image)
      text_image
    end

    def italic_text(text, left, right, x = 40)
      text_image = build_text_image( text, {font: ITALIC_FONT, size: 24, image_size: {x: x, y: 100}} )
      composite!(text_image, left, right)
    end

    def regular_text(text, left, right)
      text_image = build_text_image( text, {size: 24, weight: Magick::LighterWeight, image_size: {x: 200, y: 100}} )
      composite!(text_image, left, right)
    end

    def long_text(text, left, right)
      text_image = build_text_image( text, {size: 24, image_size: {x: 600, y: 100}} )
      composite!(text_image, left, right)
    end

    def bold_text(text, left, right)
      text_image = build_text_image( text, {font: BOLD_FONT, size: 24, image_size: {x: 200, y: 100}} )
      composite!(text_image, left, right)
    end

    def composite!(text_image, left, right)
      @certificate_image.composite!(text_image, left, right, Magick::OverCompositeOp)
    end

    def student_name_parts(case_symbol)
      result = []
      name_parts_with_case = names_array(@student, case_symbol)
      name_parts = [@student.last_name, @student.first_name, @student.middle_name].reject(&:blank?)
      [@item.decline_last_name?, @item.decline_first_name?, @item.decline_middle_name?].each_with_index do |val, idx|
        result << (val ? name_parts_with_case[idx] : name_parts[idx])
      end
      result.compact
    end
  end
end