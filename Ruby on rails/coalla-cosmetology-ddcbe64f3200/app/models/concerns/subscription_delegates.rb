module SubscriptionDelegates
  extend ActiveSupport::Concern

  included do
    delegate :name,
             :display_name,
             :hours,
             :price,
             to: :course, prefix: true, allow_nil: true

    delegate :title, to: :group, prefix: true, allow_nil: true

    delegate :start_time,
             :end_time,
             :academic_on,
             to: :group, allow_nil: true

    delegate :title,
             :short_title,
             to: :education_form, prefix: true, allow_nil: true

    delegate :online?,
             :offline?,
             to: :education_form, allow_nil: true

    delegate :title, to: :amocrm_status, prefix: true, allow_nil: true

    delegate :first_name,
             :last_name,
             :full_name,
             :passport_series,
             :passport_number,
             :passport_issued_on,
             :passport_organisation,
             :passport_address,
             :phones_string,
             :address,
             :phone,
             :education_level,
             :email, to: :student, prefix: true, allow_nil: true

    delegate :title,
             to: :faculty, prefix: true, allow_nil: true

    delegate :number,
             :created_on,
             to: :subscription_contract, allow_nil: true, prefix: true

    delegate :name,
             :address,
             :inn,
             :kpp,
             :account,
             :bik,
             :bank,
             :correspondent_account,
             :phone,
             :email,
             :position,
             :position_name,
             :position_genitive,
             :legal_address,
             :based,
             to: :payment_requisite, prefix: true, allow_nil: true

    delegate :title,
             :address,
             :inn,
             :kpp,
             :account,
             :bik,
             :bank,
             :correspondent_account,
             :phone,
             :email,
             to: :practice_basis, prefix: true, allow_nil: true
  end
end
