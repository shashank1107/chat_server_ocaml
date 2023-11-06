open Lwt.Infix
open Lwt.Syntax
open Utils

let read_from socket =
  let maxlen = msg_buffer_size in
  let buffer = Bytes.create maxlen in
  let* len = Lwt_unix.recv socket buffer 0 maxlen [] in
  let buffer = (String.sub (Bytes.to_string buffer) 0 len) in
  Lwt.return (len, buffer)

let write_to socket msg =
  let bytes_msg = Bytes.of_string msg in
  let bytes_len = Bytes.length bytes_msg in
  Lwt_unix.write socket bytes_msg 0 bytes_len >>= 
  Lwt.return

(* Prefix is added to msg and then written to socket *)
let send_msg socket msg prefix_ch = 
  let prefix_str = String.make 1 prefix_ch in
  let msg_to_send = prefix_str ^ msg in
  write_to socket msg_to_send

(* Resolves promise when end of line is reached. Sends message to receiving end with prefix appended. *)
let rec sending_loop socket =
  Lwt_io.printl "Type your message: " >>= fun _ ->
  Lwt_io.(read_line_opt stdin) >>= fun input ->
  match input with
  | Some msg ->
      send_msg socket msg Utils.send_pfx >>= fun _ -> 
      (* Reset the time right after sending the message *)
      current_time := Unix.gettimeofday ();
      sending_loop socket
  | None -> Lwt.return_unit 

and receiving_loop socket =
  let* len, buffer = read_from socket in
  match len with
  | 0 ->
     (* Close the socket if no bytes is received. Client is no longer available. *)
      close_socket socket >>= fun _ -> Lwt.return_unit
  | _ ->
      Lwt.catch
        (fun () ->
          let msg_wo_prefix = msg_wo_prefix buffer len in
          match (get_msg_type_from_msg buffer) with
          | ACK ->
            print_ack_msg msg_wo_prefix >>= fun _ ->
            Lwt.pick [ receiving_loop socket; sending_loop socket ]

          | SEND -> 
            send_msg socket msg_wo_prefix Utils.ack_pfx >>= fun _ ->
            Lwt_io.printlf "Message Received: %s\n" msg_wo_prefix >>= fun _ ->
            Lwt.pick [ receiving_loop socket; sending_loop socket ]
          
          | EMPTY -> 
            Lwt_io.printlf "Message is empty. Please send valid message" >>= fun _ ->
            Lwt.pick [ receiving_loop socket; sending_loop socket ])
        (fun _exn -> close_socket socket >>= fun _ -> Lwt.return_unit)