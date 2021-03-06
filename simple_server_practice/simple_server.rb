require 'socket'
require 'json'

def do_GET(client,response)
	path = /\S+/.match(response[4..-1])
	if File.exist?(".#{path.to_s}")
		File.open(".#{path.to_s}",'r') do |file|
			client.print("HTTP/1.1 200 OK\r\n" + "Date: #{Time.now.ctime}\r\n" + "Content-Type: text/html\r\n" + "Content-Length: #{response.length}\r\n\r\n")
			client.print(file.readlines.join(""))
		end
	else
		client.print "HTTP/1.1 404 Not Found\r\n\r\n"
		client.print "404 File Not Found"
	end
end

def check_GET_or_POST(client,response)
	check_GET = /GET\s+.+\s+HTTP\/\d\.\d/.match(response)
	check_POST = /POST\s+.+\s+HTTP\/\d\.\d/.match(response)
	if check_GET
		return "GET"
	elsif check_POST
		return "POST"
	else
		return "Neither"
	end
end

def do_POST(client,response)
	print response
	head,body = response.split("\r\n\r\n",2)
	client.puts body
	params = {}
	JSON.parse(body).each do |key,val|
		params[key] = val
	end
	thanks = []
	File.open("thanks.html",'r') do |file|
		thanks = file.readlines
	end
	new_thanks = []
	thanks.each do |line|
		new_thanks << line.gsub("<%= yield %>", "<li>Name: #{params['viking']['name']}</li><li>Email: #{params['viking']['email']}</li>")
	end
	client.puts new_thanks.join("")
	new_thanks
end

server = TCPServer.open(2345)
loop do
	client = server.accept
	response = client.gets
	case check_GET_or_POST(client,response)
	when "GET"
		do_GET(client,response)
	when "POST"
		resp = []
		resp << response
		while line = client.gets
			if line
				resp << line
			else
				resp << "\n"
			end
			break if resp.length == 7
		end
		do_POST(client,resp.join(""))
	when "Neither"
		client.puts("Not a valid request")
	end
	client.close
end




