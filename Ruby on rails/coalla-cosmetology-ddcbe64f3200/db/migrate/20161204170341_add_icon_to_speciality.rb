class AddIconToSpeciality < ActiveRecord::Migration
  def up
    add_column :specialities, :icon, :string

    icons = ['mirror', 'candle', 'mascara', 'briefcase']
    Speciality.root.ordered.each_with_index do |speciality, i|
      speciality.update_columns(icon: icons[i])
    end
  end

  def down
    remove_column :specialities, :icon
  end
end
