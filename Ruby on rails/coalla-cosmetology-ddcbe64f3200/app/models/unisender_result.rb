# == Schema Information
#
# Table name: unisender_results
#
#  id         :integer          not null, primary key
#  email      :text
#  result     :text
#  created_at :datetime
#  updated_at :datetime
#

class UnisenderResult < ActiveRecord::Base
end
