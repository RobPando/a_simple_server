require 'socket'
require 'json'

def path_handler(path) #Handles the path recieved. Returns file if it exists and returns status code accordingly 
	if File.exists?(path)
		file_content = File.read(path)
		return "200", file_content
	else
		return "404", nil
	end
end

def get_request(path)
	status, content = path_handler(path)
	if content == nil
		return status
	else
		return "#{status} #{content}"
	end
end

def get_json(data) #parses json content
	retrieved = JSON.parse(data)
	return retrieved
end

def post_request(file, content)
	status, path = path_handler(file)
	if path == nil
		return status
	else
		json_content = get_json(content)
		html_content = "<li>Name: #{json_content["viking"]["name"]}</li> <li>Email: #{json_content["viking"]["email"]}</li>"
		return "#{status} #{path.gsub("<%= yield %>", html_content)}"
	end
end


server = TCPServer.open(2000)
loop {
	client = server.accept
	response = client.gets
	request = response.split(" ")
	
	header = request[0]
	path = request[1]

	case header
	when 'GET'
		client.puts get_request(path)
	when 'POST'
		client.puts post_request(path, request.last)
	else
		client.puts "Request '#{request[0]}': Not valid."
	end
	client.puts "Closing the connection..."
	client.close
}

