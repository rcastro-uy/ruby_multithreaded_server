# web_client

require 'socket'

socket = TCPSocket.open('localhost', 8080)
output = socket.recv (100)
puts output
socket.close
