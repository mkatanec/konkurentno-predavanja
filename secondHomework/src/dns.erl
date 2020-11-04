%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Nov 2020 6:16 PM
%%%-------------------------------------------------------------------
-module(dns).
-author("mkatanec").

%% API
-export([server_loop/1, run/1]).

run(Name) ->
  Pid = spawn(dns, server_loop, [maps:new()]),
  global:register_name(Name, Pid),
  Pid.

server_loop(Map) ->
  receive
    {Pid, add, Entry} ->
      M = add(Map, Entry),
      Pid ! ok,
      server_loop(M);
    {Pid, replace, Entry} ->
      M = add(Map, Entry),
      Pid ! ok,
      server_loop(M);
    {Pid, delete, Entry} ->
      M = delete(Map, Entry),
      Pid ! ok,
      server_loop(M);
    {Pid, find, Address} ->
      Element = find(Map, Address),
      Pid ! Element,
      server_loop(Map);
    stop ->
      unregister(server),
      true;
    Ignore ->
      io:format("Ignore: ~w~n", [Ignore]),
      server_loop(Map)
  end.

add(Map, {Address, IpAddress}) ->
  maps:put(Address, IpAddress, Map).

delete(Map, {Address, _}) ->
  maps:remove(Address, Map).

find(Map, Address) ->
  maps:find(Address, Map).