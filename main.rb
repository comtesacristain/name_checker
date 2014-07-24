GENERIC_KEYWORDS=["Iron","Hill","Lake","Mount","and","Group","Creek",
  "North","West","Corp","Ltd","Silver","Resources","Areas","South","Eastern",
  "Minerals"]
ACRONYMS={"FMG"=>"Fortescue"}
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
    puts "Searching for companies associated with deposit '#{deposit.name}' (eno: #{deposit.eno})"
    unless company_name.blank?
      companies = check_company_name(company_name) 
    end
    unless companies.nil?
    companies.each do |company|
      associate_ownership(deposit, company)
    end
  end
  end
end

def check_company_name(name)
  ACRONYMS.keys.include?(name) ? name = ACRONYMS[name] : 
  if name.length < 3
    puts "Name '#{name}' too short to query"
    return 
  end
  if GENERIC_KEYWORDS.include?(name)
    puts "Name '#{name}' too generic to query"
    return 
  end
  puts "Looking for company with name \"#{name}\" ..."
  companies=Company.where("upper(company_name) like '%#{name.upcase}%'")
  case companies.size
  when 0
    companies = Array.new
    if name.include?("JV")
      puts "Company #{name} is a joint venture"
      name = name.split(/JV/).map{|s| s.strip}
    else
      name = name.split(/ /) 
    end
    if name.size > 1
      name.each do |n|
        companies << check_company_name(n)
      end
    else
      puts "No companies found"
      return companies
    end
    return companies.compact #remove returned nils
  when 1
    puts "Found #{companies.first.company_name} for #{name}"
    return companies
  else
    puts "Company: #{name} returns two companies"
    return companies
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
