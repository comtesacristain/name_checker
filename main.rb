GENERIC_KEYWORDS=["Iron","Hill","Lake","Mount","and","Group","Creek",
  "North","West","Corp","Ltd","Silver","Resources","Areas","South","Eastern",
  "Minerals","Metal","Resource"]
ACRONYMS={"FMG"=>"Fortescue"}
require 'rubygems'
gem 'activerecord'
require 'yaml'
require 'active_record'
require 'csv'


require File.join('.', 'connection.rb')
require File.join('./lib', 'entity.rb')
require File.join('./lib', 'deposit.rb')
require File.join('./lib', 'company.rb')


def find_names 
  deposits = Deposit.all

  deposits.each do |deposit|
    name = deposit.name
    name  =~ /.*\((.*)\)/ #Find text between parentheses
    company_name = $1  
    unless company_name.blank?
      puts "Searching for companies associated with deposit '#{deposit.name}' (eno: #{deposit.eno})"
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
  companies=Company.by_name(name)
  case companies.size
  when 0
    companies = Array.new
    if name.include?("JV")
      puts "Company #{name} is a joint venture"
      names = name.split(/JV/).map{|s| s.strip}
    else
      names = name.split(/ /) 
    end
    if names.size > 1
      names.each do |n|
        companies << check_company_name(n)
      end
    else
      puts "No companies found"
      return companies
    end
    return companies.compact # compact removes nils returned from recursive searches
  when 1
    puts "Found #{companies.first.company_name} for #{name}"
    return companies
  else
    puts "Company: #{name} returns two or more companies"
    companies.each_with_index do |company,i|
      puts "(#{i}) #{company.company_name}"
    end
    return companies
  end
  
end



def associate_ownership(deposit, company)
  
end



find_names
