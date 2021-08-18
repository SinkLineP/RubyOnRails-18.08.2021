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

require 'rails_helper'

RSpec.describe MailingJournal, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
