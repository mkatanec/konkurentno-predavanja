%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Oct 2020 6:11 PM
%%%-------------------------------------------------------------------
-module(wakeApi).
-author("mkatanec").

%% API
-export([start_global/0, call_global/1, server_loop/1]).

%% dodati da prima name da se moze vise pokrenut
start_global() ->
  Pid = spawn(wakeApi, server_loop, [maps:new()]),
  global:register_name(naziv, Pid).

call_global(Msg) ->
  Pid = get_pid(global:whereis_name(naziv)),
  Pid ! {self(), Msg}.

get_pid(undefined) ->
  net_kernel:connect_node('y@y'),
  global:sync(),
  global:whereis_name(naziv);

get_pid(Pid) ->
  Pid.

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