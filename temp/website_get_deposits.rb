#!/nas/oemd/mra/apps/bin/ruby
require 'open-uri'
require 'oci8'
require 'csv'
CREDENTIALS=YAML.load_file('credentials.yml')
ORALOGIN= CREDENTIALS['oracle']

conn = OCI8.new(ORALOGIN['username'],ORALOGIN['password'],'mica:1521/oraprod')
header = ["ENO","DEPOSIT","COMMODITIES","WEBSITENO","URL","STATUSCODE"]
puts CSV.generate_line header, :row_sep => "\r"
sql = 'select e.eno, e.entityid, cc.commodids, ws.websiteno, ws.url
from mgd.websites ws, mgd.webdata wd, a.entities e, MGD.concat_commods cc
where e.eno = wd.eno and wd.websiteno =ws.websiteno and cc.idno=e.eno'

#sql="select e.eno, e.entityid, ws.websiteno, ws.url 
#from mgd.websites ws, mgd.webdata wd, a.entities e
#where wd.eno = e.eno
#and wd.websiteno =ws.websiteno
#and e.entity_type<>'MINERAL DEPOSIT'"
conn.exec(sql) { |row|
	begin 
		response = open row[4] 
	rescue OpenURI::HTTPError => error
		status = "#{error.io.status[0]} - #{error.io.status[1]}"
		code = error.io.status[0].to_i
	rescue
		status = "Unknown Error"
		code = 0
	else 
		status = "#{response.status[0]} - #{response.status[1]}"
		code = response.status[0].to_i
	end
	row  << status
	if code == 200
		sql = "update mgd.websites set activity_code = 'A', qa_status_code = 'C' where websiteno = #{row[3]}"
		puts CSV.generate_line row, :row_sep => "\r"	
	else
		sql = "update mgd.websites set activity_code = 'I', qa_status_code = 'U' where websiteno = #{row[3]}"
		puts CSV.generate_line row, :row_sep => "\r"
	end
	conn.exec(sql)
	conn.commit
	
}
