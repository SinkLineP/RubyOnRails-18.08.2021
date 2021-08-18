class UpdateTranslitName < ActiveRecord::Migration
  def up
    Student.find_each do |s|
      next unless [s.first_name, s.last_name].all?(&:present?)
      translit_name = [s.first_name, s.last_name].map { |str| I18n.transliterate(str) }.join("\s")
      s.update_columns(translit_name: translit_name)
    end
  end

  def down
  end
end
