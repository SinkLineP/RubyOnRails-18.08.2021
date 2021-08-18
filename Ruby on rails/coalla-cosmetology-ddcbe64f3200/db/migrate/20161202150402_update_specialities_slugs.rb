class UpdateSpecialitiesSlugs < ActiveRecord::Migration
  def change
    Speciality.find_each{|s| s.save!}
    change_column_null :specialities, :slug, false
  end
end
