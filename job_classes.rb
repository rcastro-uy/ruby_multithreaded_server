#require ...

class Job_Print

    # Class variables

    @@no_of_jobs = 0

    # Instance variables
    def initialize (sync = false, time = 0)
    @sync= sync
    @time= time
    @job_id= add_job
    end

    attr_reader :time, :sync, :job_id
    # 1 - Execute the job in a synchronous way
    def exec_now
        puts "Ejecutando job #@job_id con metodo Exec_now ejecutado con éxito.\n"
    end
    # 2 - Enqueue a job and return its unique identifier
    def exec_later
        puts "Ejecutando job #@job_id con metodo Exec_later: ejecutado con éxito\n"
    end
    # 3 - Enqueue a job in at least <time> seconds
    def exec_in
        puts "Ejecutando job #@job_id con metodo Exec_in: ejecutado con éxito\n"
    end

    def recieved
        puts "JID = #@job_id"
    end
    # Job ID Counter - Give an unique ID to each job

    def add_job ()
        @@no_of_jobs += 1
        # puts "Actualmente hay #@@no_of_jobs jobs"
        @@no_of_jobs
    end
end

class Job_Freak_Print < Job_Print

    # Instance variables
    def initialize (sync = false, time =0)
        super
    end
    # @job_id= 0
    # @sync= false
    # @time=0

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