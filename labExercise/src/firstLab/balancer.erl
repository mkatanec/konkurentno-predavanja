%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Oct 2020 10:06 AM
%%%-------------------------------------------------------------------
-module(balancer).
-author("mkatanec").

%% API
-export([run/0, server_loop/1, add/1, remove/1, find/1]).

add(Value) ->
  server ! {self(), add, Value},
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
      io:format("Response: ~w~n", [Response])
  end.

run() ->
  Pid = spawn(balancer, server_loop, [nil]),
  register(server, Pid).

server_loop(Tree) ->
  receive
    {Pid, add, Value} ->
      NewTree = call_global(add, Tree, Value),
      Pid ! NewTree,
      server_loop(NewTree);
    {Pid, delete, Value} ->
      NewTree = call_global(delete, Tree, Value),
      Pid ! NewTree,
      server_loop(NewTree);
    {Pid, find, Value} ->
      Node = call_global(find, Tree, Value),
      Pid ! Node,
      server_loop(Tree);
    stop ->
      unregister(server),
      true;
    Ignore ->
      io:format("Ignore: ~w~n", [Ignore]),
      server_loop(Tree)
  end.

call_global(Name, Tree, Value) ->
  Pid = get_pid(global:whereis_name(Name), Name),
  Pid ! {self(), Tree, Value},
  receive
    Response ->
      Response
  end.

get_pid(undefined, add) ->
  net_kernel:connect_node('add@add'),
  global:sync(),
  Pid = global:whereis_name(add),
  if
    Pid == undefined ->
      WakePid = spawn('add@add', add, server_loop, []),
      global:register_name(add, WakePid),
      WakePid;
    true ->
      Pid
  end;

get_pid(undefined, find) ->
  net_kernel:connect_node('find@find'),
  global:sync(),
  Pid = global:whereis_name(find),
  if
    Pid == undefined ->
      WakePid = spawn('find@find', find, server_loop, []),
      global:register_name(find, WakePid),
      WakePid;
    true ->
      Pid
  end;

get_pid(undefined, delete) ->
  net_kernel:connect_node('delete@delete'),
  global:sync(),
  Pid = global:whereis_name(delete),
  if
    Pid == undefined ->
      WakePid = spawn('delete@delete', delete, server_loop, []),
      global:register_name(delete, WakePid),
      WakePid;
    true ->
      Pid
  end;

get_pid(Pid, _) ->
  Pid.