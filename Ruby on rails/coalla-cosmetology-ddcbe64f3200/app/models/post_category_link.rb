# == Schema Information
#
# Table name: post_category_links
#
#  id               :integer          not null, primary key
#  post_category_id :integer
#  post_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_post_category_links_on_post_category_id  (post_category_id)
#  index_post_category_links_on_post_id           (post_id)
#


class PostCategoryLink < ActiveRecord::Base
  belongs_to :post_category, inverse_of: :post_category_links
  belongs_to :post, inverse_of: :post_category_link
end
