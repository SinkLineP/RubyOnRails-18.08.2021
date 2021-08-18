class PdfConverter
  def initialize(pdf)
    @pdf = pdf
  end

  def each_image_file
    return [] if @pdf.try(:file).blank?

    (0).upto(pages_count - 1) do |page|
      img = Magick::Image.read("#{@pdf.file.path}[#{page}]"){
        self.format = 'JPG'
        self.quality = 100
        self.density = '300'
      }.first

      FileUtils::mkdir_p('public/tmp/')
      file_path = "public/tmp/#{Digest::MD5.hexdigest((Time.now.to_i + rand(999)).to_s)}.jpg"
      img.write(file_path)
      file = File.new(file_path)

      yield(file, page)

      File.delete(file.path)

      # hack for memory leak in rmagick pdf reading
      GC.start

      page
    end

    []
  end

  private

  def pages_count
    @pages_count ||= PDF::Reader.new(@pdf.file.path).page_count
  end
end