# == Schema Information
#
# Table name: square_banners
#
#  id           :integer          not null, primary key
#  active       :boolean          default(FALSE), not null
#  desktop_text :text             not null
#  mobile_text  :text             not null
#  image        :text
#  mobile_image :text
#  btn_title    :text
#  link         :text
#  shop_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_square_banners_on_shop_id  (shop_id)
#

FactoryGirl.define do
  factory :square_banner do
    
  end
end
