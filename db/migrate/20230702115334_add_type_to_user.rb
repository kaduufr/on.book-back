class AddTypeToUser < ActiveRecord::Migration[7.0]
  create_enum :user_type, %w[admin user employee]
  def change
    add_column :users, :type_user, :user_type, default: 'user'
  end
end
