# web_client
require 'net/telnet'
require 'socket'

# Execution of web_client (without use of class)
begin
    socket = TCPSocket.open('localhost', 8080)
    begin
        msg = socket.read_nonblock(4096)
        STDOUT.puts msg.chop
        local, peer = s.addr, s.peeraddr
    rescue SystemCallError 
        
    end

    loop do
        STDOUT.puts "Enter method and job type:"
        STDOUT.print '$>'
        STDOUT.flush 
        local = STDIN.gets
        break if !local
        socket.puts(local)
        socket.flush
        response = socket.readpartial(4096)
        puts(response.chop)
    end
rescue
    puts $!
ensure
    socket.close if socket
end
    
