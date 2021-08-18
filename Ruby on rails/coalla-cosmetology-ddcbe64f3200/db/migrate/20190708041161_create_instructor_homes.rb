# frozen_string_literal: true

class CreateInstructorHomes < ActiveRecord::Migration
  def change
    create_table :instructor_homes do |t|
      t.text :description
      t.boolean :active, null: false, default: false
      t.belongs_to :instructor

      t.timestamps null: false
    end
  end
end
