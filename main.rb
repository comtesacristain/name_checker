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
    end
  end
end

def check_company_name(name)
  puts "Looking for company with name \"#{name}\" ..."
  company=Company.where("upper(company_name) like '%#{name.upcase}%'")
  case company.size
  when 0
    if name.include?("JV")
      puts "Company #{name} is a joint venture"
      name = name.split(/JV/).map{|s| s.strip}
    else
      name = name.split(/ /) 
    end
    if name.size > 1
      name.each do |n|
        check_company_name(n)
      end
    else
      return
    end
  when 1
    puts "Found company: #{company.company_name}"
    return company
  else
    puts "Company: #{name} returns two companies"
    return
  end
  
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
