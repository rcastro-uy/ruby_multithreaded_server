class Q_Node
    attr_accessor :value, :next_qnode, :prev_qnode
    
    def initialize(value, next_qnode = nil, prev_qnode = nil)
        @value = value
        @next_qnode = next_qnode
        @prev_qnode = prev_qnode
    end
end
  
class Deque
    def initialize
        @first = nil
    end
  
    def pushFront(job)
        @first = Q_Node.new(job, @first, nil)
        @last = @first if @last.nil?
        @first.next_qnode.prev_qnode = @first if @first.next_qnode
    end
    
    def pushBack(job)
        pushFront(job) if @first == nil
        @last.next_qnode = Q_Node.new(job, nil,@last)
        @last = @last.next_qnode
    end
  
    def popFront
        @first = @first.next_qnode
    end
      
    def popBack
        @last = @last.prev_qnode if @last != @first
        self.popFront if @last == @first
    end
  
    def topFront
        @first.value if !@first.nil?
    end
  
    def topBack
        @last.value if !@last.nil?
    end
  
    def is_empty?
        @first.nil?
    end

    ## Calcula el tamaño de la deque, contando a partir del primer elemento hasta el último (NULL)
    def deq_size (qnode)
        if qnode.value.nil?
            0
        else
            1 + deq_size(next_qnode)
        end
    end

end


class Worker
    def self.start(num_threads:, queue_size:)
      queue = SizedQueue.new(queue_size)
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
         # there will be work that the worker performs
          while running? || actions?
            action_proc, action_payload = wait_for_action
            action_proc.call(action_payload) if action_proc
          end
        end
      end
    end
    
    def enqueue(action, payload)
      queue.push([action, payload])
    end
    
    def stop
      queue.close
      threads.each(&:exit)
      threads.clear
      true
    end
  
    private
  
    attr_reader :queue, :threads
  
    def actions?
      !queue.empty?
    end
    
    def running?
      !queue.closed?
    end
    
    def dequeue_action
      queue.pop(true)
    end
    
    def wait_for_action
      queue.pop(false)
    end
  end