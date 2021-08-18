class PhoneSanitizer
  PHONE_REGEXP = /\A\d{10,11}\z/

  def self.sanitize(phone)
    sanitized = phone.try(:gsub, /[\-\+\(\)\s\.\Q]/, '')

    if sanitized =~ PHONE_REGEXP && sanitized.start_with?('7', '8')
      sanitized[1..-1]
    else
      sanitized
    end
  end
end