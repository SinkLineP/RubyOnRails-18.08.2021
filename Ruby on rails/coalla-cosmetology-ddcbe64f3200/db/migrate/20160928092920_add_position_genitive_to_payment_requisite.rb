class AddPositionGenitiveToPaymentRequisite < ActiveRecord::Migration
  def change
    add_column :payment_requisites, :position_genitive, :text
  end
end
