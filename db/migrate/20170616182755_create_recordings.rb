class CreateRecordings < ActiveRecord::Migration[5.0]
  def change
    create_table :recordings do |t|
      t.string :title
      t.string :description
      t.text :video_data

      t.timestamps
    end
  end
end
