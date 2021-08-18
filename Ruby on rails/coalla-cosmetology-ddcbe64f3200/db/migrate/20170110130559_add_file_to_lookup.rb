class AddFileToLookup < ActiveRecord::Migration
  def change
    add_column :lookups, :file, :text
    Lookup.create!(code: :director_photo, value: '', type_code: :file, category: :about)
    Lookup.create!(code: :director_name, value: 'Светлана Сикорская', type_code: :string, category: :about)
    Lookup.create!(code: :director_position, value: 'Научный руководитель', type_code: :string, category: :about)
  end

  def down
    Lookup.where(code: %w(director_photo director_name director_position)).destroy_all
    remove_column :lookups, :file
  end
end
