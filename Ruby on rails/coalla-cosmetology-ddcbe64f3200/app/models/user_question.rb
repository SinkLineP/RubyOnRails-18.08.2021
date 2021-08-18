# == Schema Information
#
# Table name: user_questions
#
#  id         :integer          not null, primary key
#  user_name  :text             not null
#  email      :text             not null
#  question   :text             not null
#  created_at :datetime
#  updated_at :datetime
#

class UserQuestion < ActiveRecord::Base

  validates_presence_of :user_name, :question
  validates_format_of :email, with: Devise.email_regexp, allow_blank: false, presence: true

end
