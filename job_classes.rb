#require ...

class Job_print

    # Class variables

    @@no_of_jobs = 0

    # Instance variables
    @job_id= 0
    @sync= false
    @time=0


    # 1 - Execute the job in a synchronous way
    def exec_now
        @sync=true
        # puts "Exec_now llamado con éxito.\nSync vale: #@sync "
        @job_id = add_job
        puts "JID = #@job_id"
    end
    # 2 - Enqueue a job and return its unique identifier
    def exec_later
        # puts "Exec_later llamado con éxito\n"
        @job_id = add_job
        puts "JID = #@job_id"
    end
    # 3 - Enqueue a job in at least <time> seconds
    def exec_in time
        @time = time
        # puts "Exec_in llamado con éxito, time vale: #@time \n"
        @job_id = add_job
        puts "JID = #@job_id, con time = #@time\n"
    end

    # Job ID Counter - Give an unique ID to each job

    def add_job ()
        @@no_of_jobs += 1
        # puts "Actualmente hay #@@no_of_jobs jobs"
        @@no_of_jobs
    end
end

class Job_freak_print < Job_print

    # Instance variables
    @job_id= 0
    @sync= false
    @time=0

    def exec_now
        super
        puts "May the Force be with you Now\n"
    end
   
    def exec_later
        super
        puts "Use the Force\n"
    end

    def exec_in time
        super
        puts "The Force is my ally!\n"
    end
end

#sector de pruebas
=begin
job = Job_print.new
job2 = Job_freak_print.new
job.exec_now
job.exec_in (5)
job.exec_later
puts "Using the Force, please wait...\n"
sleep(2)
job2.exec_now
job2.exec_in (5)
job2.exec_later
=end