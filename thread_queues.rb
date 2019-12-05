require 'logger'
require 'socket'
require_relative 'job_classes.rb'

# class Q_Node
#     attr_accessor :job, :param, :next_qnode, :prev_qnode
    
#     def initialize(job, param, next_qnode = nil, prev_qnode = nil)
#         @job = job
#         @param = param
#         @next_qnode = next_qnode
#         @prev_qnode = prev_qnode
#     end
# end

# class Dequeue
#     def initialize
#         @first = Q_Node.new(nil, nil)
#         @last = @first

#       end
  
#     def pushFront(job, param)
#         @mutex.synchronize do
#             @first = Q_Node.new(job, param, @first, nil)
#             @last = @first if @last.nil?
#             @first.next_qnode.prev_qnode = @first if @first.next_qnode
#             @cond_var.signal
#         end
#     end
    
#     def pushBack(job, param)
#         @mutex.synchronize do
#             pushFront(job) if @first == nil
#             @last.next_qnode = Q_Node.new(job, param, nil,@last)
#             @last = @last.next_qnode
#             @cond_var.signal
#         end
#     end
    
#     # revisar booleano de bloqueo si no está al revés
#     def popFront (non_block=false)
#         @mutex.synchronize do
#             if !non_block
#                 while @first.empty?
#                     @cond_var.wait(@mutex)
#                 end
#             end
#             @first = @first.next_qnode
#         end
#     end
    
#     # def popBack //Not used for now
#     #     @last = @last.prev_qnode if @last != @first
#     #     self.popFront if @last == @first
#     # end

#     def topFront
#         @first.job if !@first.nil?
#     end
  
#     def topBack
#         @last.job if !@last.nil?
#     end
  
#     def is_empty?
#         @first.nil?
#     end

#     ## Calcula el tamaño de la deque, contando a partir del primer elemento hasta el último (NULL)
#     def deq_size ()
#         size = 0
#         if !@first.nil?
#             temp = Q_Node.new(nil)
#             temp = @first
#             while(!temp.nil?)
#                 size += 1
#                 temp = temp.next_qnode
#             end
#         end
#         size
#     end

# end

#

class Server

    def initialize
    puts "Iniciando server..."
    @queue = Queue.new
    @server_socket = TCPServer.open('localhost', 8080)
    @mutex = Mutex.new
    @log = Logger.new ('server2.log')
    # @cond_var = ConditionVariable.new
    end
    attr_accessor :@server_socket, :@log

    def start_server 
        while true
            client = @server_socket.accept
            Thread.start(client) do |c|
                handle_client(c)
                #back_work = process the job in queue in FIFO way
                back_work()
            end
        end
    end

    def handle_client (c)
        while true
            request = c.gets.chomp
            break if !request
            break if request=="quit"
            job = parser(request)
            response = input_work(job)
            c.puts (response.reverse)
            c.flush
        end
        c.close
    end

    def parser (req)
        method, params = request.split
        job = create_job(method, params)
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
        end
        @queue.push(job)
        ret = "#{job.job_id}"
        return ret
    end

    def create_job (method, params)
        # job parser/interpeter; crea el job de acuerdo a los parametros recibidos
        if(method. == "exec_in")
            time, params = params.split
            time.to_i
        else
            time = 0
        end

        if (method == "exec_now")
            sync = true
        else
            sync = false
        end
        puts "create job tiene en params: #{params}"
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
        while !@queue.is_empty?
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



class Worker

    def initialize(num_threads)
      @num_threads = num_threads
      @queue = Queue.new
      @threads = []
      @server_socket = TCPServer.open('localhost', 8080)
    end
    
    attr_reader :num_threads, :threads
    private :threads
    
    def spawn_threads

        puts 'Started server...'
        log = Logger.new ('server_log.log')
        loop{
            client_connection= @server_socket.accept
            threads << Thread.new do
            # Thread.start(client_connection) do |conn|
                request= client_connection.gets.chomp
                # en request estan los parametros que escucha conn en la conexion; es donde se guardaria la instruccion enviada desde el cliente
                # se espera recibir (method, job_type), por ej, (exec_now, JobPrint); en el caso de exec_in, se recibe(method, time, job_type)
                method, params = request.split
                puts "method vale: #{method} params vale: #{params}"
                job = create_job(method, params)
                if job.nil?
                    client_connection.puts ("El tipo de trabajo recibido no es correcto.\n")
                    puts "Cerrando conexion"
                    client_connection.close
                else
                    puts "Se creo un trabajo satisfactoriamente, que tiene los datos sync= #{job.sync}, time= #{job.time}, job_id= #{job.job_id}, method= #{job.method}"
                    tmp=job.recieved
                    log.debug(tmp)
                    if job.sync #sync job -->exec_now, put the result in the connection & close the connection
                        str=job.exec_now
                        puts "Server: ejecutando trabajo sync"
                        log.debug(str)
                        client_connection.print "Executing sync job. Result: #{str}"
                        client_connection.close 
                        client_connection.kill 
                    else
                        enqueue(job)
                        str=(job.job_id)
                        client_connection.print "Added job #{str}"
                    end
                end
            end
            threads.each(&:join) 
            # manejar excepciones, cerrar esta conexion particular pero que el thread siga activo
            while !@queue.empty?
                actual_job = queue.pop
                method = actual_job.method
                log.debug(run_job(actual_job, method))
            end
        } 

                # while running? || actions?
                #     #job = nil
                #     actual_job = wait_for_action
                    

                #     queue.mutex.synchronize do
                #         while queue.empty? 
                #             cond_var.wait(mutex) 
                #         end
                #         conn.puts 'This thread has nothing to do' if queue.size == 0
                #         job, job_type = queue.topFront
                #     end

                #     if (job.time == 0)
                #         log.debug = puts job.exec_later
                #         dequeue_action
                #     else
                #         sleep(job.time)
                #         log.debug = puts job.exec_in
                #         dequeue_action
                #     end
                # end
                # log.debug = "Job done"
                # conn.close
            # end


    end

  
    def create_job (method, params)
        # job parser/interpeter; crea el job de acuerdo a los parametros recibidos
        if(method. == "exec_in")
            time, params = params.split
            time.to_i
        else
            time = 0
        end

        if (method == "exec_now")
            sync = true
        else
            sync = false
        end
        puts "create job tiene en params: #{params}"
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

    def enqueue(job)
        @queue.push(job)
    end

    # private
  
    # attr_reader :queue, :threads
    
    # def actions?
    #     !queue.empty?
    # end

    # def running?
    # !queue.closed?
    # end

    # def dequeue_action
    # queue.pop(true)
    # end

    # def wait_for_action
    # queue.pop(false)
    # end

    
end


  num_threads = 5
  worker = Worker.new (num_threads)
  worker.spawn_threads

  