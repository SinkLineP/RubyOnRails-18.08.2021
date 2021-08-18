# == Schema Information
#
# Table name: blog_square_banners
#
#  id               :integer          not null, primary key
#  article_id       :integer
#  square_banner_id :integer
#  position         :integer          default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_blog_square_banners_on_article_id        (article_id)
#  index_blog_square_banners_on_square_banner_id  (square_banner_id)
#

class BlogSquareBanner < ActiveRecord::Base

  belongs_to :square_banner, inverse_of: :blog_square_banners
  belongs_to :article, inverse_of: :blog_square_banners

end
