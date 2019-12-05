# web_client

require 'socket'
require_relative 'job_classes'
# require_relative 'thread_queues'

begin
    server = TCPSocket.open('localhost', 8080)
    begin
        msg = server.read_nonblock(4096)
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
        server.puts(local)
        server.flush

        response = server.readpartial(4096)
        puts(response.chop)
    end
rescue
    puts $!
ensure
    server.close if server
end
    
