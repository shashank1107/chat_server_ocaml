open Lwt.Infix
open Lwt.Syntax
open Lib

let create_socket host port =
  let open Lwt_unix in
  let socket = socket PF_INET SOCK_STREAM 0 in
  let sockaddr = ADDR_INET (Unix.inet_addr_of_string host, port) in
  connect socket sockaddr >>=
  fun _ -> Lwt.return socket

let handle_connection sock_descr = 
  let rec wait_loop () =
    Lwt.pick
      [
        Chat.sending_loop sock_descr; 
        Chat.receiving_loop sock_descr;
      ]
    >>= fun _ -> wait_loop ()
  in
  wait_loop

let run host port =
  let* sock_descr = create_socket host port in
  handle_connection sock_descr ()
  
