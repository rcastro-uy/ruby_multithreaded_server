require 'logger'
require 'socket'
require_relative 'job_classes.rb'
require_relative 'web_server.rb'
require_relative 'client.rb'


describe Server do
    # before (:example) do
    # @server = Server.new('spec.log')
    #     Thread.new do
    #         @server.start 
    #     end

    #     sleep 1 #Wait a time to allow server to start, the client doesn't send data until the socket of the server is ready
    #     @client = Client.new
    #     @packet = 'Hello'
    #     @client.send_data (packet)
    # end
    # after (:example) do
    #     @server.close
    #     @client.socket.close
    # end
    describe ' #start_server' do
        context "when a client sends a wrong request of job execution" do
            it "can't create a job -create a nil job-, and returns an error message 'Invalid command, please try again'" do
                server = Server.new ('spec.log')
                job = server.create_job('Wrong input')
                response = server.input_work(job)
                expect(response).to eq 'Invalid command, please try again'
            end
        end

        context "When a client sends one of the accepted inputs" do
            it "should create a valid job" do
                server = Server.new ('spec.log')
                selector = rand(3)
                case selector
                when 0
                    method = "exec_in 5"
                when 1
                    method = "exec_later"
                when 2
                    method = "exec_now"
                end
                puts method
                selector = rand(2)
                case selector
                when 0
                    params = "Job_Print"
                when 1
                    params = "Job_Freak_Print"
                end
                puts params
                req = method
                req.concat(" ")
                req.concat(params)
                puts req
                job = server.create_job(req)
                expect(job).not_to be_nil
            end
        end
    end

    # describe "#create_job" do
    #     context "when recieves a string with the wrong request of job execution" do
    #         it "returns a nil job object" do
    #             server = Server.new('spec.log')
    #             job=server.create_job('Wrong input')
    #             expect(job).to be_nil
    #         end
    #     end
    # end

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