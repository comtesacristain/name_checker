#!/nas/oemd/mra/apps/bin/ruby
require 'net/http'
require 'oci8'
require 'yaml'
CREDENTIALS = YAML.load_file('credentials.yml')
oralogin = CREDENTIALS['oracle']
proxy = Net::HTTP::Proxy(ENV["HOST"], 5865)
conn = OCI8.new(oralogin['username'],oralogin['password'],'mica:1521/oraprod')
sql = "select ws.websiteno, ws.url from mgd.websites ws where rownum<20"
conn.exec(sql) { |row|
	url = URI.parse(row[1])
	begin
	#res = proxy.start(url.host, url.port) {|http| http.get( url.path.empty? ? "/" : url.path ) }
	res=proxy.get_response(url)
	rescue
	puts "This url: #{row[1]} is wrong"
	else
	
	print row[1]," ",res.code,res.code_type,"\n"
	end
	
	# begin 
		# response = open row[1] 
	# rescue OpenURI::HTTPError => error
		# code = error.io.status[0].to_i
	# rescue
		# code = 0
	# else 
		# code = response.status[0].to_i
	# end
	# if code == 200
		# sql = "update mgd.websites set activity_code = 'A', qa_status_code = 'C' where websiteno = #{row[0]}"
		# puts "Website No: #{row[0]}, URL: #{row[1]} - is active and QAed"
	# else
		# sql = "update mgd.websites set activity_code = 'I', qa_status_code = 'U' where websiteno = #{row[0]}"
		# puts "Website No: #{row[0]}, URL: #{row[1]} - is inactive and not QAed"
	# end
	# conn.exec(sql)
	# conn.commit

}
