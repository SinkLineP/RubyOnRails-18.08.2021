# == Schema Information
#
# Table name: classrooms
#
#  id          :integer          not null, primary key
#  title       :text             not null
#  capacity    :integer          default(0), not null
#  external_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Classroom, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
