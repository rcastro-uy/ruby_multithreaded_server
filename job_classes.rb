#require ...

class Job_one

    # Class variables

    @@no_of_jobs = 0

    # Instance variables
    @job_id= 0
    @sync= false
    @time=0


    # 1 - Execute the job in a synchronous way
    def exec_now
        @job_id
        @sync=true
        puts "Exec_now llamado con éxito.\nSync vale: #@sync "
        @job_id = add_job
    end
    # 2 - Enqueue a job and return its unique identifier
    def exec_later
        puts "Exec_later llamado con éxito\n"
        @job_id = add_job
    end
    # 3 - Enqueue a job in at least <time> seconds
    def exec_in time
        @time = time
        puts "Exec_in llamado con éxito, time vale: #@time \n"
        @job_id = add_job
    end

    # Job ID Counter - Give an unique ID to each job

    def add_job ()
        @@no_of_jobs += 1
        puts "Actualmente hay #@@no_of_jobs jobs"
        @@no_of_jobs
    end
end

job = Job_one.new
job.exec_now
job.exec_in (5)
job.exec_later
