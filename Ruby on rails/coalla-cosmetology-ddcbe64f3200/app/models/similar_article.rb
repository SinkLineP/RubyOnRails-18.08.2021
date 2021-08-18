# == Schema Information
#
# Table name: similar_articles
#
#  id         :integer          not null, primary key
#  similar_id :integer
#  article_id :integer
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_similar_articles_on_article_id  (article_id)
#  index_similar_articles_on_position    (position)
#  index_similar_articles_on_similar_id  (similar_id)
#

class SimilarArticle < ActiveRecord::Base

  belongs_to :article, inverse_of: :similar_articles
  belongs_to :similar, inverse_of: :similar_articles, class_name: :Article

end
