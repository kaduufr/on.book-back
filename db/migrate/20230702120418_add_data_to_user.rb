class AddDataToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :document, :string
    add_column :users, :phone, :string, null: true
    add_column :users, :birth_date, :datetime, null: true
    add_column :users, :gender, :integer, null: true, default: 0
  end
end
