# encoding: UTF-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# More info at http://bundler.io/gemfile.html
#
# Many of the gem versions installed here are based on the versions installed
# by ChefDK.

source 'https://rubygems.org'

chef_version = ENV.key?('CHEF_VERSION') ? ENV['CHEF_VERSION'] : nil

group :doc do
  gem 'yard'
end

group :test do
  gem 'rake'
  gem 'berkshelf'
end

group :style do
  gem 'foodcritic'
  gem 'rubocop'
end

group :unit do
  gem 'chef', chef_version unless chef_version.nil?
  gem 'chefspec'
  gem 'simplecov'
  gem 'should_not'
end

group :integration do
  gem 'test-kitchen'

group :integration_docker do
  gem 'kitchen-docker'
end

group :integration_vagrant do
  gem 'vagrant-wrapper'
  gem 'kitchen-vagrant'
end

group :integration_cloud do
  gem 'kitchen-ec2'
  gem 'kitchen-digitalocean'
end

group :guard do
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-rubocop'
  gem 'guard-rspec'
  # Temporary disabled: Error is: cannot load such file -- guard/kitchen
  # gem 'guard-kitchen', '~> 0.0'
end

group :travis do
  gem 'coveralls', require: false
end
