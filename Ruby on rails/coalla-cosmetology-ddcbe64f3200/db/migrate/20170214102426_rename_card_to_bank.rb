class RenameCardToBank < ActiveRecord::Migration
  def change
    PaymentLog.where(payment_type: 'card').update_all(payment_type: 'bank')
  end
end
