# This is a clean up script for Websites.
# Will eventually evolve into a more comprehensive cleanup package

require 'rubygems'
gem 'activerecord'
require 'yaml'
require 'active_record'
require 'csv'

require File.join('.', 'connection.rb')
require File.join('./lib', 'website.rb')

websites = Website.all

websites.each do |website|
  puts "Searching for "
  name_part = website.description.split(/ /).first.gsub(/'/,"\\'")
  found_websites = Website.where("upper(description) like '%#{name_part.upcase}%'")
  found_websites.each_with_index do |fw|
    puts "#{fw.description} #{fw.url}"
  end
end