# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', File.dirname(__FILE__))

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
