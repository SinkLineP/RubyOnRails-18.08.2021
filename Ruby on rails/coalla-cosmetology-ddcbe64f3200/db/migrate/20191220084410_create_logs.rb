# frozen_string_literal: true

class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :editor_id
      t.integer :action_type
      t.text :description
      t.references :loggerable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
