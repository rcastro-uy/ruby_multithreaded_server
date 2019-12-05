require 'logger'
require 'socket'
require_relative 'job_classes.rb'

class Server

    def initialize
    puts "Iniciando server..."
    @queue = Queue.new
    @server_socket = TCPServer.open('localhost', 8080)
    @mutex = Mutex.new
    @log = Logger.new ('server2.log')
    # @cond_var = ConditionVariable.new
    end
    attr_accessor :server_socket, :log

    def start_server 
        while true
            client = @server_socket.accept
            Thread.start(client) do |c|
                handle_client(c)
                #back_work = process the job in queue in FIFO way
            end.join 
            while !@queue.empty?
                back_work()
            end
        end
    end

    def handle_client (c)
        continue = true
        while continue
            request = c.gets.chomp
            break if request=="quit"
            job = parser(request)
            response = input_work(job)
            c.puts(response)
            c.flush
        end
        c.close
    end

    def parser (req)
        job = create_job(req)
        return job
    end

    def input_work (job) #Ejecuta sync (skip the queue) o encola los async
        if job.nil?
            ret = "No se ha recibido un trabajo valido"
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
        # job parser/interpeter; crea el job de acuerdo a los parametros recibidos
        backup = req
        method, params = req.split
        if(method == "exec_in")
            puts "exec_in detectado, params viene con: #{params}"
            method, time, params = backup.split
            puts "ahora time vale #{time} y params #{params}"
            time.to_i
            puts "por ultimo, time se convierte en int valiendo: #{time}"
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
            puts "Creando un Job_Print"
            job = Job_Print.new(sync, time)
        when "Job_Freak_Print"
            puts "Creando un Job_Freak_Print"
            job = Job_Freak_Print.new(sync, time)
        else
            job = nil
        end
        job.method = method if !job.nil?            
        job
    end

    def back_work
        puts "Haciendo back_work"
        while !@queue.empty?
            actual_job = @queue.pop
            method = actual_job.method
            case method
            when "exec_later"
                res = actual_job.exec_later
                @log.debug("#{res}")
            when "exec_in"
                delay = actual_job.time
                sleep(delay)
                res = actual_job.exec_in
                @log.debug("#{res}")
            end
        end
    end
end

    s = Server.new
    s.start_server