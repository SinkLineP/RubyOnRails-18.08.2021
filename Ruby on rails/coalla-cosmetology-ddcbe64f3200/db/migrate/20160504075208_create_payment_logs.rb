class CreatePaymentLogs < ActiveRecord::Migration
  def change
    create_table :payment_logs do |t|
      t.date :payed_on
      t.float :amount
      t.text :payment_type
      t.text :appointment
      t.text :comment
      t.references :group, index: true, foreign_key: true
      t.references :student, index: true
      t.foreign_key :users, column: :student_id

      t.timestamps null: false
    end
  end
end
