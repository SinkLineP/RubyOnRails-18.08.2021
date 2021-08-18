class BooksController < ApplicationController

  def index
    @categories = BookCategory.ordered
  end

  def show
    @book = Book.find(params[:id])
    gon.book_code = @book.code
    gon.book_secret_password = @book.secret_password if @book.secret_password.present?
    @book.increment_counter
  end

end
