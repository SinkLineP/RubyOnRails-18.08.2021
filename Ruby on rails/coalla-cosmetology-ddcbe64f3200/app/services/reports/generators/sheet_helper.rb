module Reports
  module Generators
    module SheetHelper
      LETTERS = ('A'..'Z').to_a

      private

      def column_name(index)
        base = LETTERS.length
        current_number = index
        result = ''

        begin
          mod = current_number % base
          letter_index = result.blank? ? mod : mod - 1
          result = LETTERS[letter_index] + result
          current_number = current_number / base
        end while current_number >= 1

        result
      end
    end
  end
end