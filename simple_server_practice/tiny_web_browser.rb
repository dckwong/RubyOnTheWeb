require 'socket'
require 'json'

def select_request
	begin
		puts "Do you want to make a 'GET' request or 'POST' request?"
		choice = gets.chomp.upcase
		raise  StandardError if choice != "GET" && choice != "POST"
	rescue StandardError
		puts "Type 'POST' or 'GET'"
		retry
	else
		choice
	end
end

def get_info
	puts "What's your viking's name?"
	name = gets.chomp
	puts "What's your viking's email?"
	email = gets.chomp
	viking_hash[:viking] = {
		:name => name,
		:email => email
	}
	viking_hash
end

def make_GET(socket)
	path = "/index.html"
	request = "GET #{path} HTTP/1.0\r\n\r\n"
	socket.print(request)
	socket.read
end

def make_POST(socket)
	path = "/thanks.html"
	get_info
	content = viking_hash.to_json
	request = "POST #{path} HTTP/1.0\n" + "From: #{viking_hash[:viking][:email]}\n" + "Content-Type: application/x-www-form-urlencoded\n" + "Content-Length: #{content.length}\r\n\r\n"


end

host = "localhost"
port = 2345
socket = TCPSocket.open(host,port)
choice = select_request
viking_hash = {}
viking_hash[:viking] = {}
case choice
when "GET"
	response = make_GET(socket)
	headers, body = response.split("\r\n\r\n", 2)
when "POST"

end


#print headers
#print body
#print response