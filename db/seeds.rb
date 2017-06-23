# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

RailsLti2Provider::Tool.create!(uuid: ENV['LTI_KEY'], shared_secret: ENV['LTI_SECRET'], lti_version: 'LTI-1p0', tool_settings:'none')
