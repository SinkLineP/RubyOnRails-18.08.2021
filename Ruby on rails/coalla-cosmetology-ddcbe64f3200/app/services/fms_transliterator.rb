class FmsTransliterator
  mattr_accessor :dictionary
  @@dictionary = YAML.load_file('config/dictionary.yml')

  def self.transliterate(str)
    return if str.blank?
    letters = str.split('')
    letters.map do |letter|
      dictionary[letter] || dictionary[letter.mb_chars.downcase.to_s].try(:mb_chars).try(:capitalize) || letter
    end.join
  end

end