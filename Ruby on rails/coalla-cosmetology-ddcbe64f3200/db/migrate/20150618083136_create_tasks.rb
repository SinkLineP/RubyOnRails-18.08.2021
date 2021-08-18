class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :type
      t.text :title
      t.text :description
      t.text :answer

      t.references :lecture
      t.index :lecture_id
      t.foreign_key :lectures

      t.integer :max_answer_length
      t.integer :max_attempts_count
      t.integer :time_limit
      t.integer :items_count

      t.timestamps
    end

    create_table :questions do |t|
      t.text :title
      t.text :image

      t.references :task
      t.index :task_id
      t.foreign_key :tasks

      t.integer :position
      t.timestamps
    end

    create_table :question_answers do |t|
      t.text :title

      t.references :question
      t.index :question_id
      t.foreign_key :questions

      t.integer :position
      t.timestamps
    end

    create_table :columns do |t|
      t.text :title

      t.references :task
      t.index :task_id
      t.foreign_key :tasks

      t.integer :position
      t.timestamps
    end

    create_table :column_variants do |t|
      t.text :title

      t.references :column
      t.index :column_id
      t.foreign_key :columns

      t.integer :position
      t.timestamps
    end

  end
end
