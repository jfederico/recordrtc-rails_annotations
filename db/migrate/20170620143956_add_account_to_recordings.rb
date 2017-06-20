class AddAccountToRecordings < ActiveRecord::Migration[5.0]
  def change
    add_reference :recordings, :account, foreign_key: true
  end
end
