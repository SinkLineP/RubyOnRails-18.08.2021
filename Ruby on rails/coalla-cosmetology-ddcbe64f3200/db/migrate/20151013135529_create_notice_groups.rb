class CreateNoticeGroups < ActiveRecord::Migration
  def change
    create_table :notice_groups do |t|
      t.references :notice, index: true
      t.foreign_key :notices
      t.references :group, index: true
      t.foreign_key :groups
      t.index [:notice_id, :group_id], unique: true
      t.integer :position, null: false, default: 0

      t.timestamps null: false
    end
  end
end
