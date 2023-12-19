# How to use this app

Please use the following commands for running the project. 

1. Download and navigate to the root of this project directory
    ```
    cd /path/to/chat_server_ocaml
    ```

2. To build the project
    ```
    make build
    ```

3. To start a server, pass value of port as command line arg
   ```
   make start_server p={PORT}
   ```
   Default host is `localhost (127.0.0.1)`

4. To connect the client to a server, pass host and port of server to connect
    ```
    make connect_client h={HOST} p={PORT}
    ```

Now you can send and receive messages from client and server. Once the client disconnects,
server is again available to accept new client connections.



## Sockets Ocaml

Simple example to demostrate client server connection using ocaml Lwt, library for concurrent programming with promises. After establishing connection, server reads the message from client and returns the vowels count in the message sent by client.
Purpose of this exercise is to understand implementation of server-client communication and how to structure project in Ocaml. 

### Conceptual guide
Socket is responsible for establishing communication with other socket over the network. 
It can be over local network or over Internet.

Socket domain has two values:
   - PF_UNIX: For establishing connection over local network
   - PF_INET: For establishing connection over the Internet using TCP / UDP protocols

Socket types decide the underlying Protocol used for communication. 
For PF_INET these can be: 
   - SOCK_STREAM: It sends messages over the connection as stream over reliable network TCP/IP ensuring successful delivery, ordered packets of messages, and de-duplication. More to discuss on this in TCP article.
   - SOCK_DGRAM: It sends messages using UDP protocol
  
Check out the [accompanying blog post](https://shashankp.dev/blog/setting-up-project-in-ocaml).
