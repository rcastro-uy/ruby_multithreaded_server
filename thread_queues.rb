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

end


class Worker
    def self.start(num_threads:, queue_size:)
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
        num_threads.times do
            threads << Thread.new do
                while session? || actions?
                    job = nil
                    mutex.synchronize do
                        while queue.is_empty? 
                            cond_var.wait(mutex) 
                        end
                        puts 'This thread has nothing to do' if queue.size == 0
                        job = queue.topFront
                        #guardar este output en log
                        puts "Por ejecutar la tarea: #{job.job_id}"
                    end
                    if (job.time == 0)
                        job.exec_later
                        queue.dequeue_action
                    else
                        sleep(job.time)
                        puts job.exec_in
                        queue.dequeue_action
                    end
            # # wait for actions, blocks the current thread    
            # action_proc, action_payload = wait_for_action
            # # la accion se realiza desde un topFront para recibir el Job; luego se debe hacer popFront para sacar el elemento consultado
            # action_proc.call(action_payload) if action_proc
                end
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
    # Llamar metodo cuando se cierra sesion
    def stop
      queue.close
      threads.each(&:exit)
      threads.clear
      true
    end
  
    private
  
    attr_reader :queue, :threads
  
    def actions?
      !queue.is_empty?
    end
    
    def session?
      #para terminar el programa, llamar a esta funcion y retornar false
    end
    
    def dequeue_action
      queue.popFront(false)
    end
    
  end