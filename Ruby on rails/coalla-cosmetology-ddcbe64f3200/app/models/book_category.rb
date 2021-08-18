# == Schema Information
#
# Table name: book_categories
#
#  id         :integer          not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_book_categories_on_name  (name) UNIQUE
#


class BookCategory < ActiveRecord::Base

  has_many :books, inverse_of: :category, dependent: :destroy

  validates_presence_of :name

  scope :ordered, -> () { order(:name) }

end
