class CreateDeletedNotices < ActiveRecord::Migration
  def change
    create_table :deleted_notices do |t|
      t.references :student, index: true
      t.foreign_key :users, column: :student_id
      t.references :notice, index: true
      t.foreign_key :notices
      t.index [:student_id, :notice_id], unique: true

      t.timestamps null: false
    end
  end
end
