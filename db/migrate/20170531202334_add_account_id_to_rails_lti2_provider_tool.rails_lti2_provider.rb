# This migration comes from rails_lti2_provider (originally 20161207182944)
class AddAccountIdToRailsLti2ProviderTool < ActiveRecord::Migration[5.1]
  def change
    add_column :rails_lti2_provider_tools, :account_id, :integer
  end
end
