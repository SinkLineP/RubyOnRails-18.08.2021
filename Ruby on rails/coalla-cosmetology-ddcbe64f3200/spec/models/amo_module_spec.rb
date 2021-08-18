# == Schema Information
#
# Table name: amo_modules
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AmoModule, type: :model do
  include_examples 'all attributes', %i(title)
end
