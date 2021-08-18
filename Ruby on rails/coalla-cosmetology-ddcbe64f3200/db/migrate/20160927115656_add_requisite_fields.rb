class AddRequisiteFields < ActiveRecord::Migration
  def up
    add_column :payment_requisites, :position, :text
    add_column :payment_requisites, :position_name, :text
    add_column :payment_requisites, :legal_address, :text
  end

  def down
    remove_column :payment_requisites, :position
    remove_column :payment_requisites, :position_name
    remove_column :payment_requisites, :legal_address, :text
  end
end
