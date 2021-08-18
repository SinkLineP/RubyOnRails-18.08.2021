class CreateGraduates < ActiveRecord::Migration
  def change
    create_table :graduates do |t|
      t.text :name
      t.text :description
      t.text :avatar
      t.timestamps
    end
  end
end
