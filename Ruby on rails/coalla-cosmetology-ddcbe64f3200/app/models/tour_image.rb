# == Schema Information
#
# Table name: about_images
#
#  id         :integer          not null, primary key
#  type       :text
#  name       :text
#  image      :text
#  created_at :datetime
#  updated_at :datetime
#  shop_id    :integer
#
# Indexes
#
#  index_about_images_on_shop_id  (shop_id)
#

class TourImage < AboutImage
end
