class Company < ActiveRecord::Base
  

  self.table_name = "mgd.companies"
  self.primary_key = :companyid

  set_date_columns :entrydate, :qadate, :lastupdate 

  
  def check_name(name)
    where("upper(company_name) like '%#{name.upcase}%'")
  end
 
end
