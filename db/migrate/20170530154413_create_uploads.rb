class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.string :title
      t.string :description
      t.text :video_data

      t.timestamps
    end
  end
end
