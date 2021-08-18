class CreateUnisenderResults < ActiveRecord::Migration
  def change
    create_table :unisender_results do |t|
      t.text :email
      t.text :result
      t.timestamps
    end
  end
end
