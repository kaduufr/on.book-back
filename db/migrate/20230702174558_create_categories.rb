class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, default: ""
      t.text :description, null: true

      t.timestamps
    end
  end
end
