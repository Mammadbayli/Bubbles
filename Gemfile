source "http://rubygems.org"

gem "fastlane"
gem "cocoapods", '~> 1.16.1'
gem 'pry'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

gem "concurrent-ruby", "= 1.3.4"
