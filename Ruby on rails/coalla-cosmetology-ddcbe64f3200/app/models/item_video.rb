# == Schema Information
#
# Table name: item_videos
#
#  id                :integer          not null, primary key
#  uploaded_video_id :integer
#  item_id           :integer
#  item_type         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ItemVideo < ActiveRecord::Base

  belongs_to :uploaded_video, inverse_of: :item_videos
  belongs_to :item, polymorphic: true

end
