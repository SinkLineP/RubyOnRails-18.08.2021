class AddTrainingFormInGroupPrices < ActiveRecord::Migration
  def change
    add_column :group_prices, :education_form, :text, default: 'academic'
  end
end
