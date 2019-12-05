require 'logger'
require 'socket'
require_relative 'job_classes.rb'

class Server

    def initialize
    puts "Starting server..."
    @queue = Queue.new
    @server_socket = TCPServer.open('localhost', 8080)
    @log = Logger.new ('server.log')
    log.datetime_format = '%Y-%m-%d %H:%M:%S'
    log.debug("Starting server...")
    # @cond_var = ConditionVariable.new
    end
    attr_accessor :server_socket, :log
    
    def start_server
        t=Thread.new do
            while true
                back_work()
            end
        end
       
        while true
            client = @server_socket.accept
            puts "New client!"
            Thread.start(client) do |c|
                handle_client(c)
            end
        end
    end

    def handle_client (c)
        while true
            request = c.gets.chomp
            if request=="quit"
                break
            end
            job = parser(request)
            response = input_work(job)
            c.puts(response)
            c.flush
        end
        puts "Closing connection"
        c.close
    end

    def parser (req)
        job = create_job(req)
        return job
    end

    def input_work (job) #Ejecuta sync (skip the queue) o encola los async
        if job.nil?
            ret = "Invalid job, please try again"
            return ret
        end
        if job.sync
            ret = job.exec_now
            @log.debug("#{ret}")
            return ret
        else
            @queue.push(job)
            ret = "#{job.job_id}"
            return ret
        end
    end

    def create_job (req)
        backup = req
        method, params = req.split
        if(method == "exec_in")
            method, time, params = backup.split
            time.to_i
        else
            time = 0
        end

        if (method == "exec_now")
            sync = true
        else
            sync = false
        end
        case params
        when "Job_Print"
            job = Job_Print.new(sync, time)
        when "Job_Freak_Print"
            job = Job_Freak_Print.new(sync, time)
        else
            job = nil
        end
        job.method = method if !job.nil?            
        job
    end

    def back_work
        actual_job = @queue.pop
        method = actual_job.method
        case method
        when "exec_later"
            res = actual_job.exec_later
            @log.debug("#{res}")
        when "exec_in"
            clock = actual_job.time.to_i
            sleep(clock)
            @log.debug("#{actual_job.exec_in}")
        end
    end
end

describe Server do
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
    context "" do
        it "" do
            
        end
    end
end