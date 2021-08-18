# == Schema Information
#
# Table name: group_prices
#
#  id                      :integer          not null, primary key
#  amount                  :integer          default(0), not null
#  payments_text           :text             not null
#  group_id                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  education_form_id       :integer
#  early_booking           :boolean          default(FALSE)
#  bank_installment        :boolean          default(FALSE)
#  bank_installment_months :integer          default(0)
#
# Indexes
#
#  index_group_prices_on_education_form_id  (education_form_id)
#  index_group_prices_on_group_id           (group_id)
#

require 'rails_helper'

RSpec.describe GroupPrice, type: :model do
  include_examples 'all attributes', %i(group_id payments_text amount)
end
