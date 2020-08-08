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
  gem 'yard', '~> 0.9.5'
end

group :test do
  gem 'rake', '~> 13.0'
  gem 'berkshelf', '~> 7.0'
end

group :style do
  gem 'cookstyle', '~> 6.14'
  gem 'foodcritic', '~> 16.3'
  gem 'rubocop', '~> 0.88.0'
end

group :unit do
  gem 'chef', chef_version unless chef_version.nil?
  gem 'chefspec', '~> 9.2'
  gem 'simplecov', '~> 0.9'
  gem 'should_not', '~> 1.1'
end

group :integration do
  gem 'test-kitchen', '~> 2.5'
end

group :integration_docker do
  gem 'kitchen-docker', '~> 2.10'
end

group :integration_vagrant do
  gem 'vagrant-wrapper', '~> 2.0'
  gem 'kitchen-vagrant', '~> 1.7'
end

group :integration_cloud do
  gem 'kitchen-ec2', '~> 3.7'
  gem 'kitchen-digitalocean', '~> 0.11'
end

group :guard do
  gem 'guard', '~> 2.16'
  gem 'guard-foodcritic', '~> 3.0'
  gem 'guard-rubocop', '~> 1.3'
  gem 'guard-rspec', '~> 4.7'
  gem 'guard-kitchen', '~> 0.1'
end

group :travis do
  gem 'coveralls', '~> 0.8', require: false
end
