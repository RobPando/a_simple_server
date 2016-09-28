require 'socket'
require 'json'

#Initializing interaction...

print "Type your request [GET or POST]: "
type = gets.strip.upcase
case type
when "GET"
	puts 'Name of the path to fetch: '
	path = gets.strip
	request = "GET #{path} HTTP/1.0\r\n"
when "POST"
	post = {}
	puts "Type the name to be posted: "
	name = gets.strip.downcase.capitalize
	puts "Type the email adress: "
	email = gets.strip
	post[:viking] = {name: name, email: email}
	puts 'Name of the path to POST: '
	path = gets.strip
	json_post = post.to_json
	content_length = json_post.length
	request = "POST #{path} HTTP/1.0 Content-Type: text/json Content-Length: #{content_length} #{json_post}\r\n"
else
	puts "Invalid Request."
end

host = 'localhost'
port = 2000

client = TCPSocket.open(host, port)
client.print(request)
response = client.read
status, body = response.split(" ", 2)

case status
	when '200'
	 puts body
	when '404'
		puts "Path Not Found."
	else
		puts "Unkown Error Occured."
end
	
client.close