# == Schema Information
#
# Table name: discounts
#
#  id         :integer          not null, primary key
#  title      :text
#  type       :text
#  value      :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  archival   :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe Discount, type: :model do
  include_examples 'all attributes', %i(title type value)
end
