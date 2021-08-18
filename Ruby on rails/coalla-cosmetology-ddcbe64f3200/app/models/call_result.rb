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

class CallResult < ActiveRecord::Base
  extend Enumerize

  MAXIMUM_CALLS = 3
  SUCCESS_STATUSES = %w(connected message_played)

  belongs_to :group_subscription, inverse_of: :call_results

  enumerize :status, in: %i(in_progress failed connected message_played voicemail), default: :in_progress, predicates: true

  scope :not_processed, ->() { where(processed: false) }
  scope :success, ->() { where(status: SUCCESS_STATUSES) }
  scope :not_success, ->() { where.not(status: SUCCESS_STATUSES) }

  def success?
    SUCCESS_STATUSES.include?(status)
  end

  def callback_requested?
    user_input.to_s.include?('2')
  end
end
