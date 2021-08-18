class AddDatesToSubscription < ActiveRecord::Migration
  def change
    change_table :group_subscriptions do |t|
      t.datetime :appendix_signed_on
      t.datetime :appendix_expired_on
      t.datetime :practice_agreement_signed_on
      t.datetime :payer_agreement_signed_on
    end
  end
end