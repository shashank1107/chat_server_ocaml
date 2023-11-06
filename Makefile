build:
	dune build ./src/main.exe

start_server:
	_build/default/src/main.exe run_server -p $(p)

connect_client:
	_build/default/src/main.exe connect_client -h $(h) -p $(p)