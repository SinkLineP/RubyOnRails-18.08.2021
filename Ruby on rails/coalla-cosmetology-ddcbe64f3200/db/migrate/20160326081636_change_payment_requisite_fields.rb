class ChangePaymentRequisiteFields < ActiveRecord::Migration
  def change
    change_table :payment_requisites do |t|
      t.change :inn, :text
      t.change :kpp, :text
      t.change :account, :text
      t.change :bik, :text
      t.change :correspondent_account, :text
    end
  end
end
