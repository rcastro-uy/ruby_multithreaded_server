require 'net/telnet'
require 'socket'

class Client
    attr_reader :socket
    def initialize
        @socket = TCPSocket.open('localhost', 8080)
    end

    def send_req (packet)
        @socket.puts packet
    end

    def recv_res
        @socket.gets
    end

end