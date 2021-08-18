class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.text :message

      t.timestamps null: false
    end
  end
end
