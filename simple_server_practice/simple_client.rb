require 'socket'

client = TCPSocket.open("localhost",2345)
while line = client.gets
	puts line.chop
end
client.close