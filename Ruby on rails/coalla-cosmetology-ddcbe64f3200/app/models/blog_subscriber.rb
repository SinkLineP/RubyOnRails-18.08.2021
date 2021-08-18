# == Schema Information
#
# Table name: blog_subscribers
#
#  id         :integer          not null, primary key
#  email      :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_blog_subscribers_on_email    (email) UNIQUE
#  index_blog_subscribers_on_user_id  (user_id)
#


class BlogSubscriber < ActiveRecord::Base
  belongs_to :user, inverse_of: :blog_subscriber

  validates_presence_of :email, unless: :user
  validates_format_of :email, with: Devise.email_regexp, allow_blank: true

  def subscription_email
    user.try(:email) || email
  end
end
