class BookBorrowController < ApplicationController
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
    @books_borrowed = BookBorrow.where(user_id: @current_user_id)
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

  private

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
