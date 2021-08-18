class AddTermToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :term, :integer
  end
end
