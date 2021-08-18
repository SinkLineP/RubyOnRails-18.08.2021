class CreateAmocrmImports < ActiveRecord::Migration
  def change
    create_table :amocrm_imports do |t|
      t.boolean :completed, null: false, default: false
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
