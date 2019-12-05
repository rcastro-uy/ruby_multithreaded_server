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
        ret = "Executing job #@job_id with function Exec_now\n"
        return ret
    end
    # 2 - Enqueue a job and return its unique identifier
    def exec_later
        ret = "Executing job #@job_id with function Exec_later\n"
        return ret
    end
    # 3 - Enqueue a job in at least <time> seconds
    def exec_in
        ret = "Executing job #@job_id with function Exec_in #@time\n"
        return ret
    end

    def recieved
        ret = "Recieved JID = #@job_id"
        return ret
    end

    def add_job ()
        @@no_of_jobs += 1
        @@no_of_jobs
    end
end

class Job_Freak_Print < Job_Print

    # Instance variables
    def initialize (sync = false, time =0)
        super
    end

    def exec_now
        ret = "Using the Force, jedi #@job_id Executing exec_now\n"
        return ret
    end
   
    def exec_later
        ret = "Using the Force, jedi #@job_id Executing exec_later\n"
        return ret
    end

    def exec_in
        ret = "Using the Force, jedi #@job_id Executing exec_in in at least #@time\n"
        return ret
    end
end

describe Job_Print do
    context "When calling exec_now method" do
        it "Should return a string 'Executing job #@job_id with function Exec_now\n'" do
            job = Job_Print.new
            message= job.exec_now
            expect(message).to eq "Executing job #@job_id with function Exec_now\n"
        end
    end
end