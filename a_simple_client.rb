require 'socket'

hostname = 'localhost'
port = 2000

client = TCPSocket.open(hostname, port)
while line = client.gets
	puts line.chop
end
client.close