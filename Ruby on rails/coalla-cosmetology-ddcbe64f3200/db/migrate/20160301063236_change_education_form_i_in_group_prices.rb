class ChangeEducationFormIInGroupPrices < ActiveRecord::Migration
  def change
    remove_column :group_prices, :education_form, :text
    add_reference :group_prices, :education_form, index: true, foreign_key: true
  end
end
