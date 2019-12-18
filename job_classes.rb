class Job
    # Class variables
    @@no_of_jobs = 0

    # Instance variables
    def initialize (sync = false, time = 0)
    @sync= sync
    @time= time
    @job_id= add_job
    @method= nil
    end

    attr_accessor :method
    attr_reader :time, :sync

    def add_job () #proteger seccion critica con mutex!!
        @@no_of_jobs += 1
    end

    def exec_now
        raise "Not implemented yet"
    end

    def exec_later
        raise "Not implemented yet"
    end

    def exec_in
        raise "Not implemented yet"
    end

end


class Job_Print < Job

    # 1 - Execute the job in a synchronous way
    def exec_now
        "Executing job #{job_id} with function exec_now\n"
    end
    # 2 - Enqueue a job and return its unique identifier
    def exec_later
        "Executing job #{job_id} with function exec_later\n"
    end
    # 3 - Enqueue a job in at least <time> seconds
    def exec_in
        "Executing job #{job_id} with function exec_in in at least #{time}\n"
    end

    def recieved
        "Recieved JID = #{job_id}"
    end


end

class Job_Freak_Print < Job

    def exec_now
        "Using the Force, jedi #@job_id executing exec_now\n"
    end
   
    def exec_later
        "Using the Force, jedi #@job_id executing exec_later\n"
    end

    def exec_in
        "Using the Force, jedi #@job_id executing exec_in in at least #@time\n"
    end
end
