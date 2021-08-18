class CreateConsultations < ActiveRecord::Migration
  def change
    create_table :consultations do |t|
      t.text :name
      t.string :email
      t.string :phone
      t.text :comment
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
