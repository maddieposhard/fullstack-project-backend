class BooksController < ApplicationController
    before_action :set_book, only: [:show, :update, :destroy]

    def index
        books = Book.all
        render json: books.as_json(only: [:id, :title, :author, :read]), status: :ok
    end

    def show
        render json: @book.as_json(only: [:id, :title, :author, :read]), status: :ok
    end

    def create
        book = Book.new(book_params)
        if book.save
          render json: book.as_json(only: [:id, :title, :author, :read]), status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end
      
      def update
        if @book.update(book_params)
          render json: @book.as_json(only: [:id, :title, :author, :read]), status: :ok
        else
          render json: @book.errors, status: :unprocessable_entity
        end
      end

    def destroy
        @book.destroy
        head :no_content
    end

    private

    def set_book
        @book = Book.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render json: { error: 'Book not found' }, status: :not_found
    end

    def book_params
        params.require(:book).permit(:title, :author, :read)
    end
end
