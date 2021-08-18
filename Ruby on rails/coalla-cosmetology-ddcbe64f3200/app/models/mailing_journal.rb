# == Schema Information
#
# Table name: mailing_journals
#
#  id            :integer          not null, primary key
#  mailing_title :string
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_mailing_journals_on_mailing_title  (mailing_title)
#  index_mailing_journals_on_user_id        (user_id)
#

class MailingJournal < ActiveRecord::Base
  extend Enumerize
  belongs_to :user

  MAILING_TITLES = ["missing_docs", "final_notification"]

  enumerize :mailing_title, in: MAILING_TITLES

  def was_mailing_about?(mailing_tiltle, time_interval)
    self
        .where('mailing_title = ?', mailing_tiltle)
        .where('created_at > ?', (Date.today - time_interval))
  end

end
