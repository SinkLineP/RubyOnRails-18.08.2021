# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer          not null
#  commentable_type :string           not null
#  creator_id       :integer          not null
#  creator_type     :string           not null
#  body             :text
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_creator_type_and_creator_id          (creator_type,creator_id)
#

class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  belongs_to :creator, polymorphic: true

  with_options presence: true do
    validates :commentable
    validates :creator
    validates :body
  end

end
