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
        ret = "Ejecutando job #@job_id con metodo Exec_now ejecutado con éxito.\n"
        return ret
    end
    # 2 - Enqueue a job and return its unique identifier
    def exec_later
        ret = "Ejecutando job #@job_id con metodo Exec_later: ejecutado con éxito\n"
        return ret
    end
    # 3 - Enqueue a job in at least <time> seconds
    def exec_in
        ret = "Ejecutando job #@job_id con metodo Exec_in #@time: ejecutado con éxito\n"
        return ret
    end

    def recieved
        ret = "Recieved JID = #@job_id"
        return ret
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

    def exec_now
        ret = "Entrenando con la Fuerza, jedi #@job_id ejecutando metodo exec_now\n"
        return ret
    end
   
    def exec_later
        ret = "Entrenando con la Fuerza, jedi #@job_id ejecutando metodo exec_later\n"
        return ret
    end

    def exec_in
        ret = "Entrenando con la Fuerza, jedi #@job_id ejecutando metodo exec_in con tiempo #@time\n"
        return ret
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