# This migration comes from rails_lti2_provider (originally 20141015204601)
class CreateRailsLti2ProviderLtiLaunches < ActiveRecord::Migration[5.1]
  def change
    create_table :rails_lti2_provider_lti_launches do |t|
      t.string :tool_proxy_id
      t.string :nonce
      t.text :message

      t.timestamps
    end
  end
end
