# This migration comes from rails_lti2_provider (originally 20141014213753)
class CreateRailsLti2ProviderToolProxies < ActiveRecord::Migration[5.0]
  def change
    create_table :rails_lti2_provider_tool_proxies do |t|
      t.string :uuid
      t.string :shared_secret
      t.text :proxy_json

      t.timestamps
    end
  end
end
