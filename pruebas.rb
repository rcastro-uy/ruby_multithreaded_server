require_relative 'job_classes.rb'

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
        @first = Q_Node.new(nil)
        @last = @first
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
        return size
    end
    # def deq_size ()
    #     if @first.nil?
    #         0
    #     else
    #         1 + deq_size(next_qnode) + (deq_size())
    #     end
    # end

end

class Pruebas < Deque
    puts "Probando deque...\n"
    deq = Deque.new
    job = Job_print.new
    deq.pushBack(job.exec_now)
    job2 = Job_freak_print.new
    deq.pushBack(job2.exec_now)
    job3 = Job_freak_print.new
    deq.pushFront(job3.exec_in(5))
    puts "Deque lista tiene tamanio: #{deq.deq_size()}\n"
    job4 = Job_freak_print.new
    deq.popFront()
end
