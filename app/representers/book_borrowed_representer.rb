class BookBorrowedRepresenter

  attr_reader :borrows
  def initialize(borrows)
    @borrows = borrows
  end

  def as_json
    borrows.map do |borrow|
      {
        id: borrow.id,
        title: borrow.book.title,
        published_at: borrow.book.publishYear,
        due_date: borrow.due_date,
        quantity: borrow.quantity,
        active: borrow.active
      }
    end
  end

end