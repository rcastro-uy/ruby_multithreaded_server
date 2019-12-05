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
        ret = "Executing job #@job_id with function exec_now\n"
        return ret
    end
    # 2 - Enqueue a job and return its unique identifier
    def exec_later
        ret = "Executing job #@job_id with function exec_later\n"
        return ret
    end
    # 3 - Enqueue a job in at least <time> seconds
    def exec_in
        ret = "Executing job #@job_id with function exec_in in at least #@time\n"
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
        ret = "Using the Force, jedi #@job_id executing exec_now\n"
        return ret
    end
   
    def exec_later
        ret = "Using the Force, jedi #@job_id executing exec_later\n"
        return ret
    end

    def exec_in
        ret = "Using the Force, jedi #@job_id executing exec_in in at least #@time\n"
        return ret
    end
end

describe Job_Print do
    context "When calling exec_now method" do
        it "Should return a string 'Executing job @job_id with function exec_now\n', where @job_id is the job.job_id value" do
            job = Job_Print.new
            message= job.exec_now
            expect(message).to eq "Executing job #{job.job_id} with function exec_now\n"
        end
    end

    context "When calling exec_later method" do
        it "Should return a string 'Executing job @job_id with function exec_later\n', where @job_id is the job.job_id value" do
            job = Job_Print.new
            message= job.exec_later
            expect(message).to eq "Executing job #{job.job_id} with function exec_later\n"
        end
    end

    context "When calling exec_in method" do
        it "Should return a string 'Executing job @job_id with function exec_in in at least @time\n', where @job_id is the job.job_id value, and @time is job.time" do
            job = Job_Print.new
            tiempo = 3
            job.time = tiempo
            message= job.exec_in
            expect(message).to eq "Executing job #{job.job_id} with function exec_in in at least #{tiempo}\n"
        end
    end

    context "When calling recieved method" do
        it "Should return a string 'Recieved JID = @job_id', where @job_id is the job.job_id value" do
            job = Job_Print.new
            message= job.recieved
            expect(message).to eq "Recieved JID = #{job.job_id}"
        end
    end

    context "When calling add_job method" do
        it "Should increment the no_of_jobs in 1, and return a new identifier for the job using this class variable" do
            job = Job_Print.new
            next_job_id = job.add_job
            expect(next_job_id).not_to eq job.job_id
        end
    end
end


describe Job_Freak_Print do
    context "When calling exec_now method" do
        it "Should return a string 'Using the Force, jedi @job_id executing exec_now\n', where @job_id is the job.job_id value" do
            job = Job_Freak_Print.new
            message= job.exec_now
            expect(message).to eq "Using the Force, jedi #{job.job_id} executing exec_now\n"
        end
    end

    context "When calling exec_later method" do
        it "Should return a string 'Using the Force, jedi @job_id executing exec_later\n', where @job_id is the job.job_id value" do
            job = Job_Freak_Print.new
            message= job.exec_later
            expect(message).to eq "Using the Force, jedi #{job.job_id} executing exec_later\n"
        end
    end

    context "When calling exec_in method" do
        it "Should return a string 'Using the Force, jedi @job_id executing exec_in in at least @time\n', where @job_id is the job.job_id value and @time is job.time" do
            job = Job_Freak_Print.new
            tiempo = 5
            job.time = tiempo
            message= job.exec_in
            expect(message).to eq "Using the Force, jedi #{job.job_id} executing exec_in in at least #{tiempo}\n"
        end
    end

    context "When calling recieved method" do
        it "Should return a string 'Recieved JID = @job_id', where @job_id is the job.job_id value" do
            job = Job_Freak_Print.new
            message= job.recieved
            expect(message).to eq "Recieved JID = #{job.job_id}"
        end
    end

    context "When calling add_job method" do
        it "Should increment the no_of_jobs in 1, and return a new identifier for the job using this class variable" do
            job = Job_Freak_Print.new
            next_job_id = job.add_job
            expect(next_job_id).not_to eq job.job_id
        end
    end
end