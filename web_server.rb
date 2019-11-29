# web_server

require_relative 'job_classes.rb'
require 'socket'

socket = TCPServer.open('localhost', 8080)
client = socket.accept
puts "New client! #{client}"
client.write("Hello from server")
client.close