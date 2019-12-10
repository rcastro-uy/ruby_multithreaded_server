require 'logger'
require 'socket'
require_relative 'job_classes.rb'
require_relative 'web_server.rb'
require_relative 'client.rb'


describe Server do
    before (:example) do
        @server = Server.new('spec.log')
        Thread.new do
            @server.start 
        end

        sleep 1 #Wait a time to allow server to start, the client doesn't send data until the socket of the server is ready
        @client = Client.new
        @packet = 'Hello'
        @client.send_data (packet)
    end
    after (:example) do
        @server.close
        @client.socket.close
    end
    describe 'back_work' do
        context "when the queue is empty" do
            it "" do
                
            end
        end
    end

    context "" do
        it "" do
            
        end
    end
    context "" do
        it "" do
            
        end
    end
    context "" do
        it "" do
            
        end
    end
    context "" do
        it "" do
            
        end
    end
    context "" do
        it "" do
            
        end
    end
end