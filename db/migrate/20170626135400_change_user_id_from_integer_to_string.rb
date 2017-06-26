class ChangeUserIdFromIntegerToString < ActiveRecord::Migration[5.0]
  def change
    change_column :accounts, :user_id, :string
  end
end
