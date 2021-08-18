# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string
#  user_id      :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_api_keys_on_access_token              (access_token) UNIQUE
#  index_api_keys_on_access_token_and_user_id  (access_token,user_id) UNIQUE
#  index_api_keys_on_user_id                   (user_id)
#

class ApiKey < ActiveRecord::Base
  belongs_to :user, inverse_of: :api_key

  def self.generate_key!(user)
    key = ApiKey.new

    key.user = user

    begin
      key.access_token = SecureRandom.hex
    end while exists?(access_token: key.access_token)

    key.save!
    key
  end
end
