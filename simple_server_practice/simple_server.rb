require 'socket'

server = TCPServer.open(2345)

loop do
	client = server.accept
	response = client.gets
	check = /GET\s+.+\s+HTTP\/\d\.\d/.match(response)
	if check
		path = /\S+/.match(response[4..-1])
		match = /HTTP.+/.match(response)
		if path.to_s == "/index.html"
			client.print "#{match} 200 OK \r\n\r\n"
			client.print "Date: #{Time.now.ctime}\n"
			client.print "Content-Type: text/html\n"
			client.print "Content-Length: #{response.length}\n"
		else
			client.print "#{match} 404 Not Found"
		end
	end
	client.puts("Closing connection now.")
	client.close
end