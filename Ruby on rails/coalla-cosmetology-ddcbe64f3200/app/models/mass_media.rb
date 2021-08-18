# == Schema Information
#
# Table name: articles
#
#  id               :integer          not null, primary key
#  type             :text
#  title            :text
#  slug             :text
#  announce         :text
#  main_image       :text
#  main_image_title :text
#  preview_image    :text
#  preview_announce :text
#  content          :text
#  published        :boolean          default(FALSE), not null
#  created_at       :datetime
#  updated_at       :datetime
#  tag_title        :text
#  tag_description  :text
#  shop_id          :integer
#  button_text      :text
#  button_link      :text
#  for_main         :boolean          default(FALSE), not null
#  button_type      :string
#
# Indexes
#
#  index_articles_on_shop_id  (shop_id)
#

class MassMedia < Article

end
