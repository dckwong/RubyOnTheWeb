require 'socket'
require 'json'

def select_request
	begin
		puts "Do you want to make a 'GET' request or 'POST' request, or 'QUIT' to quit?"
		choice = gets.chomp.upcase
		raise  StandardError if choice != "GET" && choice != "POST" && choice != "QUIT"
	rescue StandardError
		puts "Type 'POST', 'GET', or 'QUIT'"
		retry
	else
		choice
	end
end

def get_info(hash)
	puts "What's your viking's name?"
	name = gets.chomp
	puts "What's your viking's email?"
	email = gets.chomp
	hash[:viking] = {
		:name => name,
		:email => email
	}
	hash
end

def make_GET(socket)
	path = "/index.html"
	request = "GET #{path} HTTP/1.0\r\n\r\n"
	socket.print(request)
	socket.read
end

def make_POST(socket,hash)
	path = "/thanks.html"
	viking_hash = get_info(hash)
	content = viking_hash.to_json
	request = "POST #{path} HTTP/1.0\n" + "From: #{viking_hash[:viking][:email]}\n" + "Content-Type: application/x-www-form-urlencoded\n" + "Content-Length: #{content.length}\r\n\r\n" + content + "\r\n\r\n"
	socket.print(request)
	socket.read
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
	print response
when "POST"
	response = make_POST(socket,viking_hash)
	headers, body = response.split("\r\n\r\n", 2)
	print body.chomp
when "QUIT"
	socket.close
end
