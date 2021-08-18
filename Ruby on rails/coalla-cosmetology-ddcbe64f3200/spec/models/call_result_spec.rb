# == Schema Information
#
# Table name: call_results
#
#  id                    :integer          not null, primary key
#  status                :string
#  group_subscription_id :integer
#  duration              :integer
#  code                  :string
#  user_input            :string
#  processed             :boolean          default(FALSE), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_call_results_on_group_subscription_id  (group_subscription_id)
#

require 'rails_helper'

RSpec.describe CallResult, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
