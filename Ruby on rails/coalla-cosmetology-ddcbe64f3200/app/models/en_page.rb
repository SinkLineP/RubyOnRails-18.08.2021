# == Schema Information
#
# Table name: en_pages
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class EnPage < ActiveRecord::Base
end
