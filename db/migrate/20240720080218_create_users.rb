class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :telephone_number, :string
  end
end
