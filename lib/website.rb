class Website < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
  self.table_name="mgd.websites"
  self.primary_key=:websiteno

  has_many :weblinks, :class_name => "Weblink", :foreign_key => :websiteno

  has_many :deposits, :through => :weblinks

  set_date_columns :entrydate, :qadate, :lastupdate

  def self.by_description(name)
    where("upper(description) like '%#{name.upcase}%'")
  end
  
  def self.to_delete
    where(:remark=>'DELETE')
  end
  
  

end
