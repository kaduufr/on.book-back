class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.references :category, null: false, foreign_key: true
      t.text :description
      t.string :section
      t.integer :quantity

      t.timestamps
    end
  end
end
