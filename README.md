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