# == Schema Information
#
# Table name: meta_tags
#
#  id             :integer          not null, primary key
#  identifier     :text             not null
#  site           :text             default(""), not null
#  title          :text             default(""), not null
#  description    :text             default(""), not null
#  image          :text
#  url            :text
#  keywords       :text
#  og_title       :text
#  og_description :text
#  og_image       :text
#  og_url         :text
#  created_at     :datetime
#  updated_at     :datetime
#  shop_id        :integer
#
# Indexes
#
#  index_meta_tags_on_identifier_and_shop_id  (identifier,shop_id) UNIQUE
#  index_meta_tags_on_shop_id                 (shop_id)
#

class SiteMetaTags < ActiveRecord::Base
  self.table_name = 'meta_tags'

  mount_uploader :image, MetaTagsImageUploader
  mount_uploader :og_image, MetaTagsImageUploader

  scope :ordered, -> { order(:created_at) }

  class << self
    def default_tags
      where(identifier: :default).first
    end
  end

  def identifier_text
    identifier == 'default' ? 'Тэги по умолчанию' : identifier
  end
end
