class CreateUserQuestions < ActiveRecord::Migration
  def change
    create_table :user_questions do |t|
      t.text :user_name, null: false
      t.text :email, null: false
      t.text :question, null: false
      t.timestamps
    end
  end
end
