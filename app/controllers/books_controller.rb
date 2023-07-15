class BooksController < ApplicationController
  before_action :set_book, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: %i[ create update destroy ]
  before_action :book_query_params, only: %i[ search ]

  # GET /books
  def index
    @categories = Category.includes(:books).all
    @books = []
    @categories.each do |category|
      last_two_books = category.books.last(2)
      @books.concat(last_two_books)
    end

    render json: BookRepresenter.new(@books).as_json
  end

  # GET /books/1
  def show
    render json: BookRepresenter.new(Array(@book)).as_json
  end

  # # GET /books/search/:title
  # def search
  #   @books = Book.where("title LIKE ?", "%#{params[:title]}%")
  #   render json: @books
  # end

  # POST /books
  def create
    @book = Book.new(book_params)

    puts @book.errors
    begin
      if @book.save
        render json: @book, status: :created, location: @book
      else
        render json: @book.errors, status: :unprocessable_entity
      end
    rescue
      render json: {
        message: "Erro ao cadastrar livro."
      }, status: :unprocessable_entity
    end

  end

  # # GET /books/search?category_id=:category_id
  def search
    category_id = params[:category]
    title = params[:title].to_s

    query = Book.all

    if category_id
      query = query.where(category_id: category_id)
    end

    if title
      query = query.where("LOWER(title) LIKE ?", "%#{title.downcase}%")
    end

    limit = params[:limit] || 10
    offset = params[:offset] || 0

    total = query.count
    books = query.limit(limit).offset(offset)

    render json: {
      data: BookRepresenter.new(books).as_json,
      _meta: {
        total: total,
        limit: limit,
        offset: offset
      }
    }
  end


  def all
    @books = Book.all
    if @books.empty?
      render json: {
        message: "Não há livros cadastrados."
      }, status: :no_content
      return
    end
    render json: {
      data: BookRepresenter.new(@books).as_json,
      _meta: {
        total: Book.count,
        limit: params[:limit] || 10,
        offset: params[:offset] || 0
      }
    }
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    if @book.destroyed?
      render json: {
        message: "Livro removido com sucesso."
      }
    else
      render json: {
        message: "Erro ao remover livro."
      }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Query params to filter and paginate books
    def book_query_params
      params.permit(:category_id, :limit, :offset, :title)
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.permit(:title, :author, :category_id, :description, :section, :quantity, :image, :publishYear)
    end
end
