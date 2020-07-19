# frozen_string_literal: true

require 'rubygems'
# Set up gems listed in the Gemfile.
if File.exist?(File.expand_path('../Gemfile', __dir__))
  require 'bundler'
  Bundler.setup
end
