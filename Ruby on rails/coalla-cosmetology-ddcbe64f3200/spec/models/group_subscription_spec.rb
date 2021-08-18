# == Schema Information
#
# Table name: group_subscriptions
#
#  id                            :integer          not null, primary key
#  student_id                    :integer
#  group_id                      :integer
#  begin_on                      :date
#  end_on                        :date
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  deleted_at                    :datetime
#  education_form_id             :integer
#  discount_id                   :integer
#  price                         :float            default(0.0), not null
#  payer                         :text
#  amocrm_id                     :text
#  group_price_id                :integer
#  amocrm_status_id              :integer
#  imported_from_amo             :boolean          default(FALSE), not null
#  practice                      :text
#  practice_basis_id             :integer
#  payer_type                    :text
#  appendix_signed_on            :datetime
#  appendix_expired_on           :datetime
#  practice_agreement_signed_on  :datetime
#  payer_agreement_signed_on     :datetime
#  itec                          :text
#  expelled                      :boolean          default(FALSE), not null
#  academic_vacation             :boolean          default(FALSE), not null
#  vacation_begin_on             :date
#  vacation_end_on               :date
#  sale_success_on               :datetime
#  created_by_user               :boolean          default(FALSE)
#  pending_payment_at            :datetime
#  responsible_name              :text
#  amocrm_tags                   :text             is an Array
#  amo_module_id                 :integer
#  rating_place                  :integer          default(0)
#  rating_score                  :integer          default(0)
#  shop_id                       :integer
#  one_time_payment              :boolean          default(FALSE), not null
#  created_from_module           :boolean          default(FALSE), not null
#  module_group_id               :integer
#  practice_entrance_agree       :boolean          default(FALSE), not null
#  practice_entrance_agree_at    :datetime
#  practice_entrance_disagree    :boolean          default(FALSE), not null
#  practice_entrance_disagree_at :datetime
#  practice_date                 :datetime
#  practice_date_at              :datetime
#  amo_module_at                 :datetime
#  promotion_id                  :integer
#  promotion_source              :text
#  update_job_id                 :integer
#  double_created                :boolean          default(FALSE), not null
#
# Indexes
#
#  index_group_subscriptions_on_amo_module_id            (amo_module_id)
#  index_group_subscriptions_on_amocrm_status_id         (amocrm_status_id)
#  index_group_subscriptions_on_deleted_at               (deleted_at)
#  index_group_subscriptions_on_discount_id              (discount_id)
#  index_group_subscriptions_on_education_form_id        (education_form_id)
#  index_group_subscriptions_on_group_id_and_student_id  (group_id,student_id) UNIQUE
#  index_group_subscriptions_on_group_price_id           (group_price_id)
#  index_group_subscriptions_on_module_group_id          (module_group_id)
#  index_group_subscriptions_on_practice_basis_id        (practice_basis_id)
#  index_group_subscriptions_on_promotion_id             (promotion_id)
#  index_group_subscriptions_on_shop_id                  (shop_id)
#

require 'rails_helper'

RSpec.describe GroupSubscription, type: :model do
  include_examples 'all attributes', %i(group_id begin_on end_on)
end
