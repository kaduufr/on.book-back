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
        created_at: borrow.created_at,
        due_date: borrow.due_date,
        quantity: borrow.quantity,
        active: borrow.active
      }
    end
  end

end