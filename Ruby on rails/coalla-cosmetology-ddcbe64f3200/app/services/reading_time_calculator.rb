class ReadingTimeCalculator
  include ActionView::Helpers::SanitizeHelper

  READING_SPEED = 1000 # symbols per minute

  def self.calculate(text)
    ReadingTimeCalculator.new.calculate(text)
  end

  # return result in minutes
  def calculate(text)
    return 1 if text.blank?
    stripped_text = strip_tags(text).mb_chars.gsub('&#13;', '').gsub(/[^a-zA-ZA-Яа-я0-9]/, '')
    symbols_count = stripped_text.length
    [(symbols_count / READING_SPEED).ceil, 1].max
  end
end