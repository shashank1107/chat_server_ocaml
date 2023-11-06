open Lwt.Infix
open Lwt.Syntax
open Lib

(* Default host is localhost *)
let listen_addr = Unix.inet_addr_loopback 
let max_pending_conn = 1

(* Accepts the connection from a client. If another client tries to connect to server,
   It waits until the old client is disconnected. *)
let accept_connection sock = 
  let rec wait_loop () =
    let* sock_descr, _ = Lwt_unix.accept sock in
    Lwt_io.printl "Client connected!" >>= fun _ ->
    Lwt.pick
      [
        Chat.sending_loop sock_descr; 
        Chat.receiving_loop sock_descr;
      ]
    >>= fun _ -> wait_loop ()
  in
  wait_loop

(* Socket is created with Internet domain and stream type (tcp)  *)
let create_socket port =
  let open Lwt_unix in
  let sock = socket PF_INET SOCK_STREAM 0 in
  let sockaddr = ADDR_INET (listen_addr, port) in
  bind sock sockaddr >>=
  fun _ -> Lwt.return sock 

let run port =
  let* socket = create_socket port in
  Lwt_unix.listen socket max_pending_conn;
  Lwt_io.printl "Waiting for socket connection..." >>= fun _ ->
  accept_connection socket ()
