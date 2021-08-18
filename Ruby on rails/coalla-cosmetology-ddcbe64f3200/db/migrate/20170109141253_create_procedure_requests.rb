class CreateProcedureRequests < ActiveRecord::Migration
  def change
    create_table :procedure_requests do |t|
      t.text :name
      t.string :email
      t.string :phone
      t.references :cosmetology_procedure, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
