# ruby_multithreaded_server
LoopStudio - Challenge

This is an execution queue that takes different commands from multiple clients (concurrently) and executes them one by one according to the command type. 

## Installing / Getting started
This code is made with ruby 2.6.5p114 (2019-10-01 revision 67812) [x64-mingw32] (for Windows)
Ruby for Windows could be installed from https://rubyinstaller.org/downloads/, the last version without devkit it's ok for this program. 

The only external gem needed is the RSpec gem for Unit Tests. This could be installed from cmd running the command:

'gem install rspec'

In order to run this server locally, you should clone the repository with 'git clone' command followed by the URL of the repo. For this case, run: 

'git clone https://github.com/rcastro33/ruby_multithreaded_server.git'

To get git in Windows, an option is download a git tools package like the offered in https://gitforwindows.org/ This package includes useful tools like Git Bash and a Git GUI that makes things easier for Windows users.

You will need to establish TCP connections with the server in order to send requests and listen responses. Telnet is an option to connect to the server. In Windows systems, Telnet client is a feature that is disabled by default in some versions. Go to Windows Features and then search and till the 'Telnet Client' option.

### Initial Configuration

The server must be executed running 'ruby server.rb' in cmd, while starts the server and waits for inbound connections on localhost:8080
From client side, a connection could be established using Telnet, providing 'localhost' hostname and '8080' port. In Windows, from cmd in the directory type 'telnet localhost 8080' to begin a connection. From here, the client can send requests to the server, that contains a job and a command type (a particular way of execution). At any time, the 'quit' command close the connection from the current client. 

## Features

This project is an implementation of a multithreaded server that accepts multiple TCP connections. Clients can connect to the server and enqueue different kinds of jobs (this first version includes Job_Print and Job_Freak_Print job types) that will run, according to the command used. If the job is required to be executed in a synchronous way, it skips the queue and is directly executed, sending the result of the work after finishes. On the other hand, the jobs that are asynchronous goes to the queue, and they will be processed following a first come - first served order (FIFO)

## Configuration

The server always expects: `Job_command  Job_type`. For example: `exec_now Job_Print`

#### Job command
Type: `String`  
Default: N/A

Sets the parameters to execute a job in a particular way. This action is what the server will realize with a particular job. Currently, there are three available methods: 
- `exec_now`: Execute a job in a synchronous way, and return the result (this job skips the queue)
- `exec_later`: Enqueue a job and return its unique identifier
- `exec_in @time`: Enqueue a job in at least @time seconds from now and return its unique identifier

The server always log the result of each job

#### Job type
Type: `String`  
Default: N/A

Give the information of which Job Class must be instatiated, to perform the Job command (method) given before. This version counts with two job types:

Job_Print : The main Job Class, it has the the methods mentioned earlier available to execute. This job prints a string like: "Executing job #@job_id with function exec_now\n", where @job_id represents its ID and exec_now the called function.

Job_Freak_Print : Inherites the Job_Print Class, modifying the beahvior of the available functions to print a slightly different messages, inspired in the universe of Star Wars

## Contributing

Not available yet - 

## Links

Some of the most useful links reached in the research for the project:

    - https://medium.com/@kopilov.vlad/working-with-thread-in-ruby-948cd7e5f1a8
    - https://thoughtbot.com/blog/back-to-basics-writing-unit-tests-first
    - https://www.tutorialspoint.com/ruby/ruby_socket_programming.htm
    - https://www.rubyguides.com/2015/04/ruby-network-programming/
    - https://stackoverflow.com/questions/48780973/ruby-unit-test-for-a-simple-socket-server
    - https://medium.com/workday-engineering/ruby-concurrency-in-praise-of-condition-variables-ddd6c68df41f
    - https://www.tutorialspoint.com/rspec/index.htm

## Contact

If you want to contact me, you can reach me at rcastro_uy@outlook.com

## Licensing

The code in this project is not licensed yet.
