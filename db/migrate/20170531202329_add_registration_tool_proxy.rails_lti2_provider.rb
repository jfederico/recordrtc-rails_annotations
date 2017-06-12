# This migration comes from rails_lti2_provider (originally 20141103173121)
class AddRegistrationToolProxy < ActiveRecord::Migration[5.1]
  def change
    add_column :rails_lti2_provider_registrations, :tool_proxy_id, :integer
  end
end
