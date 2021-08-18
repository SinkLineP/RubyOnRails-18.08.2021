class AddCriterionToWork < ActiveRecord::Migration
  def change
    add_column :works, :criterion, :text
  end
end
