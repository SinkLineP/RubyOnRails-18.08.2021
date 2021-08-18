class CreateVacancyGroups < ActiveRecord::Migration
  def change
    create_table :vacancy_groups do |t|
      t.text :name, null: false
      t.timestamps
    end
  end
end
