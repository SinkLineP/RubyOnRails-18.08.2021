# == Schema Information
#
# Table name: authentications
#
#  id                  :integer          not null, primary key
#  uid                 :text             not null
#  provider            :text             not null
#  access_token        :text             not null
#  access_token_secret :text
#  url                 :text
#  user_id             :integer
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_authentications_on_uid      (uid)
#  index_authentications_on_user_id  (user_id)
#

class Authentication < ActiveRecord::Base
  belongs_to :user, inverse_of: :authentications
end
