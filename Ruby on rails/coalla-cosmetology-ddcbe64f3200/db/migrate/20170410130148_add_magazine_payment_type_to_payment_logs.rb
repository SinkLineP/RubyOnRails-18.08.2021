class AddMagazinePaymentTypeToPaymentLogs < ActiveRecord::Migration
  def change
    add_reference :payment_logs, :magazine_payment_type, index: true, foreign_key: true
  end
end
