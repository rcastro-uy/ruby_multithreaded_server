require 'logger'
require 'socket'
require_relative 'job_classes.rb'

class Q_Node
    attr_accessor :value, :next_qnode, :prev_qnode
    
    def initialize(job, param, next_qnode = nil, prev_qnode = nil)
        @job = job
        @param = param
        @next_qnode = next_qnode
        @prev_qnode = prev_qnode
    end
end
  
class Dequeue
    def initialize
        @first = Q_Node.new(nil)
        @last = @first
        @mutex = Mutex.new
        @cond_var = ConditionVariable.new 
      end
  
    def pushFront(job, param)
        @mutex.synchronize do
            @first = Q_Node.new(job, param, @first, nil)
            @last = @first if @last.nil?
            @first.next_qnode.prev_qnode = @first if @first.next_qnode
            @cond_var.signal
        end
    end
    
    def pushBack(job, param)
        @mutex.synchronize do
            pushFront(job) if @first == nil
            @last.next_qnode = Q_Node.new(job, param, nil,@last)
            @last = @last.next_qnode
            @cond_var.signal
        end
    end
    
    # revisar booleano de bloqueo si no está al revés
    def popFront (non_block=false)
        @mutex.synchronize do
            if !non_block
                while @first.empty?
                    @cond_var.wait(@mutex)
                end
            end
            @first = @first.next_qnode
        end
    end
    
    # def popBack //Not used for now
    #     @last = @last.prev_qnode if @last != @first
    #     self.popFront if @last == @first
    # end

    def topFront
        @first.job if !@first.nil?
    end
  
    def topBack
        @last.job if !@last.nil?
    end
  
    def is_empty?
        @first.nil?
    end

    ## Calcula el tamaño de la deque, contando a partir del primer elemento hasta el último (NULL)
    def deq_size ()
        size = 0
        if !@first.nil?
            temp = Q_Node.new(nil)
            temp = @first
            while(!temp.nil?)
                size += 1
                temp = temp.next_qnode
            end
        end
        size
    end

end


class Worker

    def self.start(num_threads:)
      queue = Dequeue.new
      worker = new(num_threads: num_threads, queue: queue)
      worker.spawn_threads
      worker
    end
  
    def initialize(num_threads:, queue:)
      @num_threads = num_threads
      @queue = queue
      @threads = []
    end
    
    attr_reader :num_threads, :threads
    private :threads
    
    def spawn_threads
        server = TCPServer.open('localhost', 8080)
        puts 'Started server...'
        num_threads.times do #loop
            client_connection = server.accept
            threads << Thread.new 
                Thread.current (client_connection) do |conn|
                request = conn.gets.chomp
                # en request estan los parametros que escucha conn en la conexion; es donde se guardaria la instruccion enviada desde el cliente
                # se espera recibir (method, job_type), por ej, (exec_now, JobPrint); en el caso de exec_in, se recibe(method, time, job_type)
                method, job_type = request.split
                # job parser/interpeter; crea el job de acuerdo a los parametros recibidos
                if(method == "exec_in")
                    time, job_type = job_type.split
                    time.to_i
                else
                    time = 0
                end
                if (method == "exec_now")
                    sync = true
                else
                    sync = false
                end
                case job_type
                when "Job_Print"
                    job = Job_Print.new(sync, time)
                conn.puts "Se recibió el #{job.recieved}\n"
                when "Job_Freak_Print"
                    job = Job_Freak_Print.new(sync, time)
                else
                    puts ("El tipo de trabajo recibido no es correcto.\n")
                    # manejar excepciones, cerrar esta conexion particular pero que el thread siga activo
                end
                while session? || actions?
                    job = nil
                    mutex.synchronize do
                        while queue.is_empty? 
                            cond_var.wait(mutex) 
                        end
                        puts 'This thread has nothing to do' if queue.size == 0
                        job = queue.topFront
                    end
                    if (job.time == 0)
                        log.debug = puts job.exec_later
                        dequeue_action
                    else
                        sleep(job.time)
                        log.debug = puts job.exec_in
                        dequeue_action
                    end
                end
                log.debug = puts "Job done. Closing connection."
                conn.close
            end
        end
        threads.each(&:join)
    end
    
    def enqueue(job)
        if job.sync
            queue.pushFront(job)
            # manda true al pop
            queue.popFront(true)
        else
            queue.pushBack(job)
            # manda true al pop
            queue.popFront(true)
        end
    end
    # Llamar metodo cuando se cierra sesion
    def stop
      # queue.close
      threads.each(&:exit)
      threads.clear
      queue = nil
      true
    end
  
    private
  
    attr_reader :queue, :threads
  
    def actions?
      !queue.is_empty?
    end
    
    def session?
      #para terminar el programa, llamar a esta funcion y retornar false
      !stop
    end
    
    def dequeue_action
      queue.popFront(false)
    end
    
  end


  