# This migration comes from rails_lti2_provider (originally 20151204000125)
class AddRailsLti2ProviderRegistrationCorrelationId < ActiveRecord::Migration[5.0]
  def change
    add_column :rails_lti2_provider_registrations, :correlation_id, :text
    add_index :rails_lti2_provider_registrations, :correlation_id, :unique => true
  end
end
