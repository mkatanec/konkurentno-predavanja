%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Oct 2020 9:51 AM
%%%-------------------------------------------------------------------
-module(find).
-author("mkatanec").

%% API
-export([run/0, server_loop/0]).

run() ->
  Pid = spawn(find, server_loop, []),
  global:register_name(find, Pid),
  Pid.

server_loop() ->
  receive
    {Pid, Tree, Value} ->
      Node = find(Tree, Value),
      Pid ! Node,
      server_loop();
    stop ->
      true
  end.

find(nil, _) ->
  nil;

find({Value, Color, Left, Right}, KeyValue) ->
  if
    KeyValue < Value ->
      find(Left, KeyValue);
    KeyValue > Value ->
      find(Right, KeyValue);
    true ->
      {Value, Color, Left, Right}
  end.