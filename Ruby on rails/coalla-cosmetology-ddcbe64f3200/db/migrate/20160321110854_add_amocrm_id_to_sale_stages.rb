class AddAmocrmIdToSaleStages < ActiveRecord::Migration
  def change
    add_column :sale_stages, :amocrm_id, :integer, null: false
  end
end
