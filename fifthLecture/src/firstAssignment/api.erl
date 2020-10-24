%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Oct 2020 11:48 AM
%%%-------------------------------------------------------------------
-module(api).
-author("mkatanec").

%% API
-export([server_loop/1]).

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