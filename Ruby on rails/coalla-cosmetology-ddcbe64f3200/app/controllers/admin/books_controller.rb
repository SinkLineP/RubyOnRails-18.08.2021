# Контроллер раздела "Библиотека"
# @see app/views/admin/books
module Admin
  class BooksController < AdminController
    authorize_resource

    def index
      @books = Book.ordered
      gon.book_category_names = BookCategory.ordered.pluck(:name)
    end

    def create
      book = Book.new(params[:book].permit!)
      book_processing(book)
    end

    def cover_create
      uploader = CoverUploader.new
      begin
        uploader.cache!(params[:book][:cover])

        render json: {coverCache: uploader.cache_name, coverFilename: uploader.filename}
      rescue => ex
        render json: {error: upload_error(ex)}
      end
    end

    def edit
      @book = Book.find(params[:id])
      @book.category_name = @book.category.name
      render '_edit', layout: false
    end

    def update
      book = Book.find(params[:id])
      book.assign_attributes(params[:book].permit!)
      book_processing(book)
    end

    def destroy
      @book = Book.find(params[:id])
      @book.destroy
      redirect_to admin_books_path
    end

    def book_processing(book)
      category = BookCategory.find_or_create_by(name: params[:book][:category_name])
      book.assign_attributes(book_category_id: category.id)

      if book.save
        render json: {status: :ok, redirectUrl: admin_books_path}
      else
        render json: {status: :error, errors: book.errors}
      end
    end
  end
end