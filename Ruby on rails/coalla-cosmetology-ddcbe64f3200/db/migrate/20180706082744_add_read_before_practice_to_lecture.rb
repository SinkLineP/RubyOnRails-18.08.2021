class AddReadBeforePracticeToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :read_before_practice, :boolean, null: false, default: false
  end
end
