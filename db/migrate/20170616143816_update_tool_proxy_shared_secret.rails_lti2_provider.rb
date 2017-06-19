# This migration comes from rails_lti2_provider (originally 20150817183400)
class UpdateToolProxySharedSecret < ActiveRecord::Migration[5.0]
  def change
    change_column :rails_lti2_provider_tools, :shared_secret, :text, limit: nil
  end
end
