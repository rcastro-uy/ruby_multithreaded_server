#require ...

class Job_Print

    # Class variables

    @@no_of_jobs = 0

    # Instance variables
    def initialize (sync = false, time = 0)
    @sync= sync
    @time= time
    @job_id= add_job
    @method= nil
    end

    attr_accessor :time, :sync, :job_id, :method

    # 1 - Execute the job in a synchronous way
    def exec_now
        return "Executing job #@job_id with function exec_now\n"
    end
    # 2 - Enqueue a job and return its unique identifier
    def exec_later
        return "Executing job #@job_id with function exec_later\n"
    end
    # 3 - Enqueue a job in at least <time> seconds
    def exec_in
        return "Executing job #@job_id with function exec_in in at least #@time\n"
    end

    def recieved
        return "Recieved JID = #@job_id"
    end

    def add_job ()
        @@no_of_jobs += 1
    end
end

class Job_Freak_Print < Job_Print

    # Instance variables
    def initialize (sync = false, time =0)
        super
    end

    def exec_now
        return "Using the Force, jedi #@job_id executing exec_now\n"
    end
   
    def exec_later
        return "Using the Force, jedi #@job_id executing exec_later\n"
    end

    def exec_in
        return "Using the Force, jedi #@job_id executing exec_in in at least #@time\n"
    end
end
