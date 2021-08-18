class AddBasedToPaymentsReqisites < ActiveRecord::Migration
  def change
    add_column :payment_requisites, :based, :text
  end
end
