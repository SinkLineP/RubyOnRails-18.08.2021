class CreateEducationForms < ActiveRecord::Migration
  def up
    create_table :education_forms do |t|
      t.text :short_title, null: false
      t.text :title, null: false

      t.timestamps null: false
    end

    EducationForm.create!(short_title: 'О', title: 'Очная')
    EducationForm.create!(short_title: 'ОД', title: 'Очная с применением дистанционных образовательных технологий')
  end

  def down
    drop_table :education_forms
  end
end
