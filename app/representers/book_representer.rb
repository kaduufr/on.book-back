class BookRepresenter

  attr_reader :books
  def initialize(books)
    @books = books
  end

  def as_json
    books.map do |book|
      {
        id: book.id,
        title: book.title,
        author: book.author,
        category: book.category.name,
        description: book.description,
        section: book.section,
        quantity: book.quantity,
        image: book.image_url,
        available: book.available?,
        published_at: book.publishYear || "N/A",
        category_id: book.category_id,
        category_name: book.category.name
      }
    end
  end

end