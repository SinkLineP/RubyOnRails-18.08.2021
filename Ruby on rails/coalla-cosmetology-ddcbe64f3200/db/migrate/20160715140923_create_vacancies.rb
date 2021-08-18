class CreateVacancies < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.text :name, null: false
      t.text :content_type, null: false
      t.text :content
      t.text :file
      t.references :vacancy_group, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
