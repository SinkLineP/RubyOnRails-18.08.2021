module Amocrm
  module Utils
    class NoteParser
      attr_reader :text, :field

      class << self
        def parse(text, field)
          new(text, field).parse
        end
      end

      def initialize(text, field)
        @text = text
        @field = field
      end

      def parse
        return unless text.present?
        str = text.mb_chars.downcase
        entry_index = str.index("#{field}:")
        return unless entry_index.present?
        text[entry_index + field.length + 1, text.length].split('(')[0]
      end

    end
  end
end