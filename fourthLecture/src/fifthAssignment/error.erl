%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Oct 2020 8:05 PM
%%%-------------------------------------------------------------------
-module(error).
-author("mkatanec").

%% API
-export([run/0]).

%%Ako nema responsea bacimo error

run() ->
  server_startup().

server_startup() ->
  Pid = spawn(crud, server_loop, []),
  register(server, Pid).

server_loop() ->
  receive
    stop ->
      unregister(server),
      true;
    Request ->
      io:format("Ignore: ~w~n", [Request]),
      server_loop()
  end.
