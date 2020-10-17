%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Oct 2020 3:38 PM
%%%-------------------------------------------------------------------
-module(crud).
-author("mkatanec").

%% API
-export([add/0, replace/0, delete/0, find/0, server_startup/0, server_loop/0]).

add() ->
  M = maps:new(),
  server_startup(),
  serverica ! {self(), add, {M, {"Mac", "Miller", []}}},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

replace() ->
  M = #{"MacMiller" => []},
  server_startup(),
  serverica ! {self(), replace, {M, {"Mac", "Miller", [{"Netko", "Drug"}]}}},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

delete() ->
  M = #{"MacMiller" => []},
  server_startup(),
  serverica ! {self(), delete, {M, {"Mac", "Miller"}}},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

find() ->
  M = #{"MacMiller" => [{"Netko", "Drugi"}]},
  server_startup(),
  serverica ! {self(), find, {M, {"Mac", "Miller"}}},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

server_startup() ->
  Pid = spawn(crud, server_loop, []),
  register(serverica, Pid).

server_loop() ->
  receive
    {nes} ->
      server_loop();
    {Pid, add, {Map, Person}} ->
      M = add(Map, Person),
      Pid ! M,
      server_loop();
    {Pid, replace, {Map, Person}} ->
      M = add(Map, Person),
      Pid ! M,
      server_loop();
    {Pid, delete, {Map, Person}} ->
      M = delete(Map, Person),
      Pid ! M,
      server_loop();
    {Pid, find, {Map, Person}} ->
      M = find(Map, Person),
      Pid ! M,
      server_loop();
    stop ->
      unregister(serverica),
      true;
    Ignore ->
      io:format("Ignore: ~w~n", [Ignore]),
      server_loop()
  end.

add(Map, {Name, Surname, Friends}) ->
  maps:put(string:concat(Name, Surname), Friends, Map).

delete(Map, {Name, Surname}) ->
  maps:remove(string:concat(Name, Surname), Map).

find(Map, {Name, Surname}) ->
  maps:find(string:concat(Name, Surname), Map).

