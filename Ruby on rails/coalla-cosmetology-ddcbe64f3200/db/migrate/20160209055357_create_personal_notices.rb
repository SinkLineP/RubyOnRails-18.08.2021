class CreatePersonalNotices < ActiveRecord::Migration
  def change
    create_table :personal_notices do |t|
      t.text :message
      t.boolean :read, null: false, default: false
      t.references :student, index: true
      t.foreign_key :users, column: :student_id
      t.references :lecture, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
