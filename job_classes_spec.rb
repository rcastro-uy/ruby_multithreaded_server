require_relative 'job_classes'

RSpec.describe Job_Print do
    context "When calling exec_now method" do
        it "Should return a string 'Executing job @job_id with function exec_now\n', where @job_id is the job.job_id value" do
            job = described_class.new
            expect(job.exec_now).to eq "Executing job #{job.job_id} with function exec_now\n"
        end
    end

    context "When calling exec_later method" do
        it "Should return a string 'Executing job @job_id with function exec_later\n', where @job_id is the job.job_id value" do
            job = described_class.new
            expect(job.exec_later).to eq "Executing job #{job.job_id} with function exec_later\n"
        end
    end

    context "When calling exec_in method" do
        it "Should return a string 'Executing job @job_id with function exec_in in at least @time\n', where @job_id is the job.job_id value, and @time is job.time" do
            job = described_class.new (time = rand())
            expect(job.exec_in).to eq "Executing job #{job.job_id} with function exec_in in at least #{job.time}\n"
        end
    end

    context "When calling recieved method" do
        it "Should return a string 'Recieved JID = @job_id', where @job_id is the job.job_id value" do
            job = described_class.new
            expect(job.recieved).to eq "Recieved JID = #{job.job_id}"
        end
    end

    context "When calling add_job method" do
        it "Should increment the no_of_jobs in 1, and return a new identifier for the job using this class variable" do
            job = described_class.new
            expect(job.add_job).not_to eq job.job_id
        end
    end

    context "When calling recieved method" do
        it "Should return the job-job_id number in the string 'Recieved JID = @job_id', where @job_id gives that information" do
            job = described_class.new
            expect(job.recieved).to eq "Recieved JID = #{job.job_id}"
        end
    end
end


describe Job_Freak_Print do
    context "When calling exec_now method" do
        it "Should return a string 'Using the Force, jedi @job_id executing exec_now\n', where @job_id is the job.job_id value" do
            job = described_class.new
            expect(job.exec_now).to eq "Using the Force, jedi #{job.job_id} executing exec_now\n"
        end
    end

    context "When calling exec_later method" do
        it "Should return a string 'Using the Force, jedi @job_id executing exec_later\n', where @job_id is the job.job_id value" do
            job = described_class.new
            expect(job.exec_later).to eq "Using the Force, jedi #{job.job_id} executing exec_later\n"
        end
    end

    context "When calling exec_in method" do
        it "Should return a string 'Using the Force, jedi @job_id executing exec_in in at least @time\n', where @job_id is the job.job_id value and @time is job.time" do
            job = described_class.new(time = rand())
            expect(job.exec_in).to eq "Using the Force, jedi #{job.job_id} executing exec_in in at least #{job.time}\n"
        end
    end

    context "When calling recieved method" do
        it "Should return a string 'Recieved JID = @job_id', where @job_id is the job.job_id value" do
            job = described_class.new
            expect(job.recieved).to eq "Recieved JID = #{job.job_id}"
        end
    end

    context "When calling add_job method" do
        it "Should increment the no_of_jobs in 1, and return a new identifier for the job using this class variable" do
            job = described_class.new
            expect(job.add_job).not_to eq job.job_id
        end
    end
end