require 'socket'
require_relative 'job_classes.rb'
require_relative 'web_server.rb'

describe Server do
    describe ' #start_server' do

        context "when a client sends a wrong request of job execution" do
            it "can't create a job -create a nil job-, and returns an error message 'Invalid command, please try again'" do
                server = Server.new("spec.log", 8080)
                job = server.create_job('Wrong input')
                response = server.input_work(job)
                expect(response).to eq 'Invalid command, please try again'
            end
        end

        context "When a client sends one of the accepted inputs" do
            it "should create a valid job" do
                server = Server.new("spec.log", 8081)
                selector = rand(3)
                case selector
                when 0
                    method = "exec_in 5"
                when 1
                    method = "exec_later"
                when 2
                    method = "exec_now"
                end
                selector = rand(2)
                case selector
                when 0
                    params = "Job_Print"
                when 1
                    params = "Job_Freak_Print"
                end
                req = method
                req.concat(" ")
                req.concat(params)
                job = server.create_job(req)
                expect(job).to be_kind_of Job_Print
            end
        end

        context "When the request is execute a job in a synchronous way" do
            it "should execute the job request immediately" do
                server = Server.new("spec.log", 8082)
                req = "exec_now"
                selector = rand(2)
                case selector
                when 0
                    params = "Job_Print"
                when 1
                    params = "Job_Freak_Print"
                end
                req.concat(" ")
                req.concat(params)
                job = server.create_job(req)
                response = server.input_work(job)
                case selector
                when 0
                    expect(response).to eq "Executing job #{job.job_id} with function exec_now\n"
                when 1
                    expect(response).to eq "Using the Force, jedi #{job.job_id} executing exec_now\n"
                end
            end
        end

        context "When the request is execute a job in a synchronous way" do
            it "should skip the queue" do
                server = Server.new("spec.log", 8083)
                req = "exec_now"
                selector = rand(2)
                case selector
                when 0
                    params = "Job_Print"
                when 1
                    params = "Job_Freak_Print"
                end
                req.concat(" ")
                req.concat(params)
                job = server.create_job(req)
                response = server.input_work(job)
                expect(server.queue_not_empty).to be false             
            end
        end

        context "When the request is execute a job in an asynchronous way" do
            it "should return the job ID number in a string" do
                server = Server.new("spec.log", 8084)
                selector = rand(2)
                case selector
                when 0
                    method = "exec_in 5"
                when 1
                    method = "exec_later"
                end
                selector = rand(2)
                case selector
                when 0
                    params = "Job_Print"
                when 1
                    params = "Job_Freak_Print"
                end
                req = method
                req.concat(" ")
                req.concat(params)
                job = server.create_job(req)
                response = server.input_work(job)
                expect(response).to eq "#{job.job_id}"
            end
        end

        context "When the request is execute a job in an asynchronous way" do
            it "should enqueue the job" do
                server = Server.new("spec.log", 8085)
                selector = rand(2)
                case selector
                when 0
                    method = "exec_in 0"
                when 1
                    method = "exec_later"
                end
                selector = rand(2)
                case selector
                when 0
                    params = "Job_Print"
                when 1
                    params = "Job_Freak_Print"
                end
                req = method
                req.concat(" ")
                req.concat(params)
                puts req
                job = server.create_job(req)
                response = server.input_work(job)
                sleep 0.1 #wait for enqueue
                expect(server.queue_not_empty).to be true
            end
        end
    end
end