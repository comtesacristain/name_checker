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
  puts "Searching for #{website.description} with URL #{website.url} (websiteno: #{website.websiteno})"
  name_part = website.description.split(/ /).first.gsub(/'/,"\\'")
  found_websites = Website.by_description(name_part)
  found_websites.each_with_index do |fw, i|
    puts "Is #{fw.description} with URL #{fw.url} (websiteno: #{website.websiteno}) a duplicate? (y/n)"
    answer=gets.chomp
  end
end

def clean_deleted
  deleted_websites  = Website.to_delete
  deleted_websites.each do |dw|
    dw.delete
  end
end

# Codes for website clean up
# DELETE:DUPLICATE
# DELETE:BROKEN