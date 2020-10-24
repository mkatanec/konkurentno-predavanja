%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Oct 2020 6:11 PM
%%%-------------------------------------------------------------------
-module(globalApi).
-author("mkatanec").

%% API
-export([start_global/0, call_global/1, server_loop/1]).


start_global() ->
  Pid = spawn(globalApi, server_loop, [maps:new()]),
  global:register_name(naziv, Pid).

call_global(Msg) ->
  Pid = global:whereis_name(naziv),
  Pid!{self(), Msg}.

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