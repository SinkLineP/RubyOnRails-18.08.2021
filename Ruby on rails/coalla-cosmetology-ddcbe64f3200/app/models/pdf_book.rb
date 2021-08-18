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

class PdfBook < Book
  validates_presence_of :pdf

  def filename
    pdf.try(:file).try(:filename)
  end
end
