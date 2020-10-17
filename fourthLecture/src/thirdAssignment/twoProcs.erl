%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Oct 2020 6:25 PM
%%%-------------------------------------------------------------------
-module(twoProcs).
-author("mkatanec").

%% API
-export([run/0, server_loop/1, serveric/0]).

run() ->
  Pid1 = spawn(twoProcs, server_loop, [maps:new()]),
  register(server_one, Pid1),
  Pid2 = spawn(twoProcs, server_loop, [maps:new()]),
  register(server_two, Pid2),
  Pid3 = spawn(twoProcs, serveric, []),
  register(server, Pid3).

serveric() ->
  receive
    Request ->
      server_one ! Request,
      serveric()
  end.

server_loop(Map) ->
  receive
    {Pid, add, Person} ->
      M = add(Map, Person),
      Pid ! M,
      server_loop(M);
    {Pid, replace, Person} ->
      M = add(Map, Person),
      Pid ! M,
      server_loop(M);
    {Pid, delete, Person} ->
      M = delete(Map, Person),
      Pid ! M,
      server_loop(M);
    {Pid, find, Person} ->
      M = find(Map, Person),
      Pid ! M,
      server_loop(M);
    stop ->
      unregister(server),
      true;
    Ignore ->
      io:format("Ignore: ~w~n", [Ignore]),
      server_loop(Map)
  end.

add(Map, {Name, Surname, Friends}) ->
  maps:put(string:concat(Name, Surname), Friends, Map).

delete(Map, {Name, Surname}) ->
  maps:remove(string:concat(Name, Surname), Map).

find(Map, {Name, Surname}) ->
  maps:find(string:concat(Name, Surname), Map).
