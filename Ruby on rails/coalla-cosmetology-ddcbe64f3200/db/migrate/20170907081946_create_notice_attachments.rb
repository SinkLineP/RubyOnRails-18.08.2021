class CreateNoticeAttachments < ActiveRecord::Migration
  def change
    create_table :notice_attachments do |t|
      t.references :notice, foreign_key: true, index: true
      t.text :file
      t.timestamps
    end
  end
end
