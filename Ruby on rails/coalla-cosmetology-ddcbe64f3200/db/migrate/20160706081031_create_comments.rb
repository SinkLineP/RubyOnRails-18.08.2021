class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.with_options polymorphic: true, null: false, index: true do |tt|
        tt.belongs_to :commentable
        tt.belongs_to :creator
      end
      t.text :body
      t.timestamps
    end
  end
end
