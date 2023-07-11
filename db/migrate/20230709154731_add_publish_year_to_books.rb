class AddPublishYearToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :publishYear, :string, null: true
  end
end
