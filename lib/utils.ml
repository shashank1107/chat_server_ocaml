open Lwt.Infix
(* 
  SEND: message sent by sending side from command line
  ACK: message reverted by receiving side back to sending side
  EMPTY: Empty message sent by sending side   
*)
type msg_type = ACK | SEND | EMPTY

(* Prefix is appending to messages while writing to socket *)
let prefix_ch_to_msg_type ch msg_len = 
  match ch with
  | 'A' when msg_len > 1 -> ACK
  | 'S' when msg_len > 1 -> SEND
  | _ -> EMPTY

let msg_buffer_size = 4096
let current_time = ref 0.
let send_pfx = 'S'
let ack_pfx = 'A'

(* Returns original message without the prefix headers *)
let msg_wo_prefix msg len =
  String.sub msg 1 (len-1)

let get_msg_type_from_msg msg = 
  let prefix_ch = String.get msg 0 in
  prefix_ch_to_msg_type prefix_ch (String.length msg)

let close_socket socket = 
  Lwt_unix.close socket >>= fun _ -> Lwt_io.printl "Client disconnected"

let print_ack_msg msg = 
  let time = Unix.gettimeofday () in 
  Lwt_io.printlf "Acknowledgement Received: %s\nRound trip time: %f\n" msg (time -. !current_time)