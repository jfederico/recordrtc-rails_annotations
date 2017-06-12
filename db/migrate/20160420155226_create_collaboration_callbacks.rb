class CreateCollaborationCallbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :collaboration_callbacks do |t|
      t.string :request_method
      t.string :host
      t.timestamps
    end
  end
end
