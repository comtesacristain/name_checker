

require 'rubygems'
gem 'activerecord'
require 'yaml'
require 'active_record'
require 'csv'

#require File.join('.', 'intierra_reader.rb')
require File.join('.', 'connection.rb')
require File.join('./lib', 'entity.rb')
require File.join('./lib', 'deposit.rb')
require File.join('./lib', 'company.rb')


def find_names 
  deposits = Deposit.all

  deposits.each do |deposit|
    name = deposit.name
    name  =~ /.*\((.*)\)/
    company_name = $1
    unless company_name.blank?
      companies = check_company_name(company_name) 
	  case companies.size
	  when 0
	    puts "No companies found with #{company_name} (deposit: #{deposit.name})"
  	    puts "Split? (Y/N)"
	    answer = gets.chomp
	    if answer.upcase == 'Y'
	      check_split_company_name(company_name)
	    end
	  when 1
	    puts "Company found (company: #{company.company_name})"
	  else
	  end
    end
  end
end

def check_company_name(name)
  puts "Looking for company with name \"#{name}\" ..."
  return Company.where("upper(company_name) like '%#{name.upcase}%'")
 
end

def check_split_company_name(name)
  names = name.split(/ /)
  puts "Which name do you choose?"
  names.each_with_index do |n,i|
	puts "\t(#{i+1}) #{n}"
  end
  answer = gets.chomp
  name=names[answer.to_i-1] unless answer.to_i>names.size 
  return check_company_name(name)
  
end

def associate_ownership(deposit, company)
  
end



find_names


#companies = Company.where("upper(company_name) like '%#{company_name.upcase}%'")
    #if companies.size ==0
      #company_name=company_name.split(/ /).first
      #companies = Company.where("upper(company_name) like '%#{company_name.upcase}%'")
    #end
    #if companies.size ==1
      #puts "#{deposit.id}, #{deposit.name}, #{companies.first.id}, #{companies.first.company_name}"
    #end