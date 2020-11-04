%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Nov 2020 6:30 PM
%%%-------------------------------------------------------------------
-module(balancer).
-author("mkatanec").

%% API
-export([server_loop/0, add/1, remove/1, replace/1, find/1, run/0]).

add(Value) ->
  server ! {self(), add, Value},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

replace(Value) ->
  server ! {self(), replace, Value},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

remove(Value) ->
  server ! {self(), delete, Value},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

find(Value) ->
  server ! {self(), find, Value},
  receive
    Response ->
      {_, IpAddress} = Response,
      io:format("Response: ~s~n", [IpAddress])
  end.

run() ->
  Pid = spawn(balancer, server_loop, []),
  register(server, Pid).

server_loop() ->
  receive
    {Pid, find, Address} ->
      [_, _, ParsedUrl] = string:split(Address, ".", all),
      [Tld | _] = string:split(ParsedUrl, "/", all),
      IsHr = string:equal(Tld, "hr"),
      IsCom = string:equal(Tld, "com"),
      IsIo = string:equal(Tld, "io"),
      if
        IsHr ->
          M = call_global(hr, find, Address),
          Pid ! M;
        IsCom ->
          M = call_global(com, find, Address),
          Pid ! M;
        IsIo ->
          M = call_global(io, find, Address),
          Pid ! M;
        true ->
          Pid ! "Not supported TLD"
      end,
      server_loop();
    {Pid, Method, {Address, IpAddress}} ->
      [_, _, ParsedUrl] = string:split(Address, ".", all),
      [Tld | _] = string:split(ParsedUrl, "/", all),
      IsHr = string:equal(Tld, "hr"),
      IsCom = string:equal(Tld, "com"),
      IsIo = string:equal(Tld, "io"),
      if
        IsHr ->
          M = call_global(hr, Method, {Address, IpAddress}),
          Pid ! M;
        IsCom ->
          M = call_global(com, Method, {Address, IpAddress}),
          Pid ! M;
        IsIo ->
          M = call_global(io, Method, {Address, IpAddress}),
          Pid ! M;
        true ->
          Pid ! "Not supported TLD"
      end,
      server_loop();
    stop ->
      unregister(server),
      true;
    Ignore ->
      io:format("Ignore: ~w~n", [Ignore]),
      server_loop()
  end.

call_global(Name, Method, Entry) ->
  Pid = get_pid(global:whereis_name(Name), Name),
  Pid ! {self(), Method, Entry},
  receive
    Response ->
      Response
  end.

get_pid(undefined, hr) ->
  net_kernel:connect_node('hr@hr'),
  global:sync(),
  Pid = global:whereis_name(hr),
  if
    Pid == undefined ->
      WakePid = spawn('hr@hr', dns, server_loop, [maps:new()]),
      global:register_name(hr, WakePid),
      WakePid;
    true ->
      Pid
  end;

get_pid(undefined, com) ->
  net_kernel:connect_node('com@com'),
  global:sync(),
  Pid = global:whereis_name(com),
  if
    Pid == undefined ->
      WakePid = spawn('com@com', dns, server_loop, [maps:new()]),
      global:register_name(com, WakePid),
      WakePid;
    true ->
      Pid
  end;

get_pid(undefined, io) ->
  net_kernel:connect_node('io@io'),
  global:sync(),
  Pid = global:whereis_name(io),
  if
    Pid == undefined ->
      WakePid = spawn('io@io', dns, server_loop, [maps:new()]),
      global:register_name(io, WakePid),
      WakePid;
    true ->
      Pid
  end;

get_pid(Pid, _) ->
  Pid.