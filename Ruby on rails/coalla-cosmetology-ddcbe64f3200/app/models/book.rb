# == Schema Information
#
# Table name: books
#
#  id               :integer          not null, primary key
#  author           :text
#  name             :text
#  book_category_id :integer
#  description      :text
#  code             :integer
#  cover            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  views_count      :integer          default(0)
#  delta            :boolean          default(TRUE), not null
#  secret_password  :text
#  pdf              :text
#  pdf_status       :text
#  type             :text
#
# Indexes
#
#  index_books_on_book_category_id  (book_category_id)
#


class Book < ActiveRecord::Base
  extend Enumerize
  include Pdf

  belongs_to :category, class_name: 'BookCategory', foreign_key: 'book_category_id', inverse_of: :books

  attr_accessor :category_name

  validates_presence_of :author, :name, :book_category_id, :description

  scope :ordered, -> () { order(created_at: :desc) }
  scope :published, ->(){ where('type = ? OR pdf_status = ?', 'ScribdBook', :completed) }

  mount_uploader :cover, CoverUploader

  alias_attribute :search_content, :name

  def not_processed?
    pdf_status.present? && pdf_status == :in_progress
  end

  def increment_counter
    increment!(:views_count)
  end

  def pdf?
    is_a?(PdfBook)
  end

  def scribd?
    is_a?(ScribdBook)
  end

end
