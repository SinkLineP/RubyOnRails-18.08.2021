class AddConfiguratorFieldsToCourse < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.integer :education_period, null: false, default: 6
      t.text :subject
      t.boolean :medical_education, null: false, default: false
      t.boolean :work_in_cosmetology, null: false, default: false
    end
  end
end
