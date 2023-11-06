open Cmdliner

let start_server_action port = Lwt_main.run (Server.run port) 
let connect_client_action host port = Lwt_main.run (Client.run host port) 
  
(* Arguments *)
let host =
  let doc = "ip address that the server should use" in
  Arg.(value & opt string "127.0.0.1" & info [ "h"; "addr" ] ~docv:"ADDR" ~doc)
  
let port =
  let doc = "port number of server" in
  Arg.(value & opt int 8080 & info [ "p"; "port" ] ~docv:"PORT" ~doc)
  
  (* Commands *)
let run_server = 
  let doc = "launch the server" in
  let info = Cmd.info "run_server" ~doc in
  let term = Term.(const start_server_action $ port) in
  Cmd.v info term
  
let connect_client = 
  let doc = "connect client" in
  let info = Cmd.info "connect_client" ~doc in
  let term = Term.(const connect_client_action $ host $ port) in
  Cmd.v info term
  
let () =
  let cmds = [run_server; connect_client;] in
  let group = Cmd.group (Cmd.info "Client server communication project") cmds in
  exit (Cmd.eval group)
  