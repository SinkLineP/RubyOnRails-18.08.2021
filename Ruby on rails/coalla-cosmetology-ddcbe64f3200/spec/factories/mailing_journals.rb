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

FactoryGirl.define do
  factory :mailing_journal do
    mailing_title "MyString"
    user nil
  end
end
