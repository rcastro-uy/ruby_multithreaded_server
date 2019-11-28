#require ...

class Job_one

    # Class variables

    @@no_of_jobs = []

    def initialize time=0
    # Instance variables; time = 0 and sync = false by default
    @sync= false
    @time=time
    end

    # 1 - Execute the job in a synchronous way
    def Exec_now
        @sync=true
    end
    # 2 - Enqueue a job and return its unique identifier
    def Exec_later

    end
    # 3 - Enqueue a job in at least <time> seconds
    def Exec_in time
        @time = time
    end

end

