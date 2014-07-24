class Company < ActiveRecord::Base
  

  self.table_name = "mgd.companies"
  self.primary_key = :companyid

  set_date_columns :entrydate, :qadate, :lastupdate 

  
  def self.by_name(name)
    where("upper(company_name) like '%#{name.upcase}%'")
  end
 
  def name
    return company_name
  end
end
