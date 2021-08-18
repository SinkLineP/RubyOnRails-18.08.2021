class AddAdditionalReferencesToSms < ActiveRecord::Migration
  def change
    add_reference :sms, :user, index: true, foreign_key: true
    add_reference :sms, :group_subscription, index: true, foreign_key: true
  end
end
