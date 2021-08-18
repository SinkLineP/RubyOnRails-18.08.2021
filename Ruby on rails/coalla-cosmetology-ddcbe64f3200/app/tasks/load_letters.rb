class LoadLetters
  def self.do
    errors = []

    Instructor.with_email_passwords.find_each do |instructor|
      begin
        LettersLoader.new(instructor).load!
      rescue => ex
        errors << ex
      end
    end
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/letters.log")
    logger.error('При загрузке писем произошли ошибки!')
    errors.each{|error| logger.error("Сообщение об ошибке: #{error.message}.\n#{error.backtrace.join('<br/>')}") }
  end
end