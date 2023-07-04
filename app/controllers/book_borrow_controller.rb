class BookBorrowController < ApplicationController
  def create
    @book_borrow = BookBorrow.new(book_borrow_params)
    @book_borrow.save
    render json: @book_borrow
  end

  private

  def book_borrow_params
    params.permit(:user_id, :book_id, :borrow_date, :return_date)
  end
end
