# == Schema Information
#
# Table name: group_transfers
#
#  id                    :integer          not null, primary key
#  new_group_id          :integer
#  old_group_id          :integer
#  group_subscription_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class GroupTransfer < ActiveRecord::Base

  has_one :change_group_order, as: :item, dependent: :destroy
  has_one :student, through: :group_subscription
  belongs_to :group_subscription, inverse_of: :group_transfers

  accepts_nested_attributes_for :change_group_order

  scope :ordered, -> { order(created_at: :asc) }

  def old_group
    @old_group ||= Group.with_deleted.find(old_group_id)
  end

  def new_group
    @new_group ||= Group.with_deleted.find(new_group_id)
  end

  def correct?
    old_group && new_group
  end

end
