# web_client

require 'socket'
require_relative 'job_classes'
require_relative 'web_server'

class Client
    def initialize (socket)
        @socket = socket
        @request = send_request
        @response = listen_response

        @request.join
        @response.join
    end

    def send_request
        puts "Please enter method and job type:"
        begin
            Thread.new do
                loop do
                    msj = $stdin.gets.chomp
                    @socket.puts msj
                end
            end
        rescue IOError => exception
            puts "Request Error: #{exception}"
            socket.close          
        end
    end

    def listen_response
        begin
            Thread.new do
                loop do
                    response = socket.gets.chomp
                    puts "#{response}"
                end
            end
        rescue IOError => exception
            puts "Listen Error: #{exception}"
            socket.close
        end
    end
    





socket.close

  # Main execution

    hilos = 5
    log = Logger.new ('server_log.log') 
    socket = TCPSocket.open('localhost', 8080)
    puts 'Starting client...'
    Client.new (socket)
    worker = Worker.start (5)
    while
    output = socket.recv (100)
    puts output
    end
