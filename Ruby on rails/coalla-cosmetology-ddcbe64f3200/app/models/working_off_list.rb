# == Schema Information
#
# Table name: working_off_lists
#
#  id                    :integer          not null, primary key
#  hours                 :text             not null
#  variant               :text             not null
#  user_file             :text
#  processed_on          :date             not null
#  work_id               :integer
#  group_subscription_id :integer
#  working_off_type      :text             default("not_chosen")
#  exam                  :boolean          default(FALSE), not null
#  instructor_id         :integer
#  scheduled             :boolean          default(FALSE), not null
#
# Indexes
#
#  index_working_off_lists_on_group_subscription_id  (group_subscription_id)
#  index_working_off_lists_on_instructor_id          (instructor_id)
#  index_working_off_lists_on_work_id                (work_id)
#

class WorkingOffList < ActiveRecord::Base
  extend Enumerize

  enumerize :variant, in: [:individual, :in_group], default: :individual
  enumerize :working_off_type, in: [:not_chosen, :wc_document, :wc_change_group, :wc_vip, :c_with_group, :c_individual, :wc_individual_vip], default: :not_chosen

  mount_uploader :user_file, PrivateFileUploader

  belongs_to :group_subscription, inverse_of: :working_off_lists
  belongs_to :work, inverse_of: :working_off_lists
  belongs_to :instructor, inverse_of: :working_off_lists
  has_one :working_off_sheet, as: :item, dependent: :destroy
  has_many :schedule_item_working_off_lists, dependent: :destroy, inverse_of: :working_off_list

  validates :hours,
            :variant,
            :processed_on,
            :work_id,
            :group_subscription_id,
            presence: true

  after_save :generate_document!

  def generate_document!
    (working_off_sheet || build_working_off_sheet).generate!
  end
end
