class AddUserToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :user_id, :integer
    add_foreign_key :works, :users
  end
end
