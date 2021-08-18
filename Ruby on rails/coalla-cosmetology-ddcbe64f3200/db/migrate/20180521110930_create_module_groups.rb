class CreateModuleGroups < ActiveRecord::Migration
  def change
    create_table :module_groups do |t|
      t.references :amo_module, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.references :group_subscription, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
