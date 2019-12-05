# ruby_multithreaded_server
LoopStudio - Challenge

This is an execution queue that takes different commands from multiple clients (concurrently) and executes them one by one according to the command type. 

## Installing / Getting started
sobre que versión de Ruby está hecho
En el installing, indicar que hay que instalar Ruby, como instalarlo, y si depende de algunas dependencies también aclararlo
poner como iniciarlo separado por plataforma, Win o Linux
https://rubyinstaller.org/downloads/
Let’s install the Rspec gem now
hay que clonar el repo (comando para clonarlo ahí) y luego recién como iniciar el server
First, starts the server from cmd with 'ruby web_server.rb'
Then, open as many clients as wanted and connect using 'telnet localhost 8080'
From here, the client can send requests to the server, that contains a job and a command type (a particular way of execution)

### Initial Configuration

Ruby installed and Telnet Client enable (in Windows)
The server must be executed running 'ruby web_server.rb', while starts the server and waits for inbound connections on localhost:8080
From client side, a connection could be established using Telnet, providing 'localhost' hostname and '8080' port. In Windows, from cmd in the directory type 'telnet localhost 8080' to begin a connection. In any time, the 'quit' command close the connection from the current client.

## Features

This project is an implementation of a multithreaded server that accepts multiple TCP connections. Clients can connect to the server and enqueue different kinds of jobs (this first version includes Job_Print and Job_Freak_Print job types) that will run, according to the command used. If the job is required to be executed in a synchronous way, it skips the queue and is directly executed, sending the result of the work after finishes. On the other hand, the jobs that are asynchronous goes to the queue, and they will be processed following a first come - first served order (FIFO)

## Configuration

Not specials configurations needed to run this server.

#### Argument 1
Type: `String`  
Default: `'default value'`

State what an argument does and how you can use it. If needed, you can provide
an example below.

Example:
```bash
awesome-project "Some other value"  # Prints "You're nailing this readme!"
```

#### Argument 2
Type: `Number|Boolean`  
Default: 100

Copy-paste as many of these as you need.

## Contributing

When you publish something open source, one of the greatest motivations is that
anyone can just jump in and start contributing to your project.

These paragraphs are meant to welcome those kind souls to feel that they are
needed. You should state something like:

"If you'd like to contribute, please fork the repository and use a feature
branch. Pull requests are warmly welcome."

If there's anything else the developer needs to know (e.g. the code style
guide), you should link it here. If there's a lot of things to take into
consideration, it is common to separate this section to its own file called
`CONTRIBUTING.md` (or similar). If so, you should say that it exists here.

## Links

Even though this information can be found inside the project on machine-readable
format like in a .json file, it's good to include a summary of most useful
links to humans using your project. You can include links like:

- Project homepage: https://your.github.com/awesome-project/
- Repository: https://github.com/your/awesome-project/
- Issue tracker: https://github.com/your/awesome-project/issues
  - In case of sensitive bugs like security vulnerabilities, please contact
    my@email.com directly instead of using issue tracker. We value your effort
    to improve the security and privacy of this project!
- Related projects:
  - Your other project: https://github.com/your/other-project/
  - Someone else's project: https://github.com/someones/awesome-project/


## Licensing

One really important part: Give your project a proper license. Here you should
state what the license is and how to find the text version of the license.
Something like:

"The code in this project is licensed under MIT license."
