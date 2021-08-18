# == Schema Information
#
# Table name: blog_categories
#
#  id          :integer          not null, primary key
#  category_id :integer
#  article_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  shop_id     :integer
#
# Indexes
#
#  index_blog_categories_on_article_id   (article_id)
#  index_blog_categories_on_category_id  (category_id)
#  index_blog_categories_on_shop_id      (shop_id)
#

class BlogCategory < ActiveRecord::Base

  belongs_to :category, inverse_of: :blog_categories
  belongs_to :article, inverse_of: :blog_categories

  scope :ordered, -> { order(:created_at) }

end
