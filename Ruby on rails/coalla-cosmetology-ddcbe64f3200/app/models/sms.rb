# == Schema Information
#
# Table name: sms
#
#  id                    :integer          not null, primary key
#  number                :text
#  text                  :text
#  message_id            :integer
#  status                :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer
#  group_subscription_id :integer
#
# Indexes
#
#  index_sms_on_group_subscription_id  (group_subscription_id)
#  index_sms_on_user_id                (user_id)
#

class Sms < ActiveRecord::Base
  belongs_to :user, inverse_of: :sms
  belongs_to :group_subscription, inverse_of: :sms

  def self.send_message!(number, text, options = {})
    user = options.delete(:student)
    group_subscription = options.delete(:subscription)
    sms = new(number: number,
              text: text,
              user: user,
              group_subscription: group_subscription).send_message!
    Delayed::Job.enqueue(Amocrm::Operations::CreateSmsNote.new(sms.id)) if sms.try(:user)
  end

  def send_message!
    return if number.blank? || text.blank?

    responce = Smsc::Client.new.send_message(number, text)
    assign_attributes(message_id: responce['id'], status: 0)
    save!
    self
  end

  def update_status!
    return if message_id.blank?

    responce = Smsc::Client.new.get_message_status(number, message_id)
    update!(status: responce['status'])
  end
end
