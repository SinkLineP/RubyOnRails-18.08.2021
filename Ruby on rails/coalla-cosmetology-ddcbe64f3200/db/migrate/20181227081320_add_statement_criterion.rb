class AddStatementCriterion < ActiveRecord::Migration
  def change
    add_column :works, :statement_criterion, :text
  end
end
