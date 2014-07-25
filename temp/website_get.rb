#!/nas/oemd/mra/apps/bin/ruby
require 'open-uri'
require 'oci8'
require 'csv'
#conn =
header = ["WEBSITENO","DESCRIPTION","URL"]
puts CSV.generate_line header, :row_sep => "\r"
sql = 'select ws.websiteno, ws.description, ws.url from mgd.websites ws where ws.websiteno in (select wd.websiteno from mgd.webdata wd) order by ws.description'
conn.exec(sql) { |row|
	begin 
		response = open row[2] 
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
	# if code == 200
		# sql = "update mgd.websites set activity_code = 'A', qa_status_code = 'C' where websiteno = #{row[0]}"
	
	# else
		# sql = "update mgd.websites set activity_code = 'I', qa_status_code = 'U' where websiteno = #{row[0]}"
		# puts CSV.generate_line row, :row_sep => "\r"
	# end
	puts CSV.generate_line row, :row_sep => "\r"
	conn.exec(sql)
	conn.commit
}
