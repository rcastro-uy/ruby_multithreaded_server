# web_server
require 'logger'
require 'socket'
require_relative 'job_classes.rb'

class Server

    def initialize (file = 'server.log', port = 8080)
    @queue = Queue.new
    @server_socket = TCPServer.open("localhost", port)
    @log = Logger.new (file)
    log.datetime_format = '%Y-%m-%d %H:%M:%S'
    log.debug("Starting server...")
    @cond_var = ConditionVariable.new
    @mutex = Mutex.new
    end
    attr_accessor :server_socket, :log, :mutex
    
    def start_server
        puts "Starting server..."
        t=Thread.new do
            while true
                @mutex.synchronize do
                    while @queue.empty?
                        @cond_var.wait(@mutex)
                    end
                    back_work()
                end
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

    def queue_not_empty
        if @queue.empty?
            false
        else
            true
        end
    end

    def handle_client (c)
        while true
            request = c.gets.chomp
            if request=="quit"
                break
            end
            job = create_job(request)
            response = input_work(job)
            c.puts(response)
            c.flush
        end
        puts "Closing connection"
        c.close
    end

    def input_work (job) 
        if job.nil?
            return "Invalid command, please try again"
        end
        if job.sync
            ret = job.exec_now
            @log.debug("#{ret}")
            return ret
        else
            w=Thread.new do
                sleep(job.time)
                @mutex.synchronize do
                    @queue.push(job)
                    @cond_var.signal
                end
            end
            ret = "#{job.job_id}"
            return ret
        end
    end

    def create_job (req)
        backup = req
        method, params = req.split
        case method
        when "exec_in"
            method, time, params = backup.split
            time = time.to_i
        when "exec_later"
            time = 0
        when "exec_now"
            sync = true
        else
            job = nil
            return job
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
            @log.debug("#{actual_job.exec_later}")
        when "exec_in"
            @log.debug("#{actual_job.exec_in}")
        end
    end
end

