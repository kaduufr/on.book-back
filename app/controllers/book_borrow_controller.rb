class BookBorrowController < ApplicationController

  before_action :authenticate_user!
  before_action :set_book_borrow, only: %i[ show  ]

  def create
    @book_borrow = BookBorrow.new(book_borrow_params)
    @user_book_borrows = BookBorrow.where(user_id: @book_borrow.user_id, active: true)
    @user_book_borrows.each do |user_book_borrow|
      if user_book_borrow.book_id == @book_borrow.book_id
        user_book_borrow.quantity += @book_borrow.quantity
        user_book_borrow.save
        @book_borrow.destroy
        render json: user_book_borrow
        return
      end
    end

    return cant_borrow if @book_borrow.user.has_book_overdue?

    @book_borrow.save
    render json: @book_borrow
  end

  def all
    @books_borrowed = BookBorrow.where(user_id: @current_user_id).order(created_at: :desc)
    if @books_borrowed.empty?
      render json: {
        message: "Você não possui nenhum livro emprestado."
      }, status: :no_content
      return
    end
    render json: {
      data: BookBorrowedRepresenter.new(@books_borrowed).as_json,
    }

  end

  def show
    render json: {
      data: ShowBookBorrowedRepresenter.new(@book_borrow).as_json,
    }
  end

  def update
    @book_borrow = BookBorrow.find(params[:id])
    @book_borrow.update({ active: false })
    render json: @book_borrow
  end

  private

  def set_book_borrow
    @book_borrow = BookBorrow.all.where(book_id: params[:id], active: true)
  end

  def cant_borrow
    render json: { message: "Você não pode pegar nenhum livro emprestado", error: "Você possui livro em atraso" }, status: :unprocessable_entity
  end

  def borrow_success
    render json: {
      message: "Emprestimo registrado com sucesso.",
      book_borrow: @book_borrow
    }
  end

  def book_borrow_params
    params.permit(:user_id, :book_id, :due_date, :quantity)
  end
end
