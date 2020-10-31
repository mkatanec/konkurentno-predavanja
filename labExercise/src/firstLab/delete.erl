%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Oct 2020 10:02 AM
%%%-------------------------------------------------------------------
-module(delete).
-author("mkatanec").

%% API
-export([run/0, server_loop/0]).

run() ->
  Pid = spawn(delete, server_loop, []),
  global:register_name(delete, Pid),
  Pid.

server_loop() ->
  receive
    {Pid, Tree, Value} ->
      NewTree = delete(Tree, Value),
      Pid ! NewTree,
      server_loop();
    stop ->
      true
  end.

delete({Value, Color, {KeyValue, red, nil, nil}, Right}, KeyValue) ->
  {Value, Color, nil, Right};

delete({Value, Color, Left, {KeyValue, red, nil, nil}}, KeyValue) ->
  {Value, Color, Left, nil};

delete({Value, Color, {KeyValue, LeftColor, LeftLeft, LeftRight}, Right}, KeyValue) ->
  {Value, Color, {findLowest(LeftRight), LeftColor, LeftLeft, delete(LeftRight, findLowest(LeftRight))}, Right};

delete({Value, Color, Left, {KeyValue, RightColor, RightLeft, RightRight}}, KeyValue) ->
  {Value, Color, Left, {findLowest(RightRight), RightColor, RightLeft, delete(RightRight, findLowest(RightRight))}};

delete({Value, Color, Left, Right}, KeyValue) ->
  if
    KeyValue > Value ->
      {Value, Color, Left, delete(Right, KeyValue)};
    KeyValue < Value ->
      {Value, Color, delete(Left, KeyValue), Right};
    true ->
      {Value, Color, Left, Right}
  end.

findLowest({Value, _, Left, _}) ->
  if
    Left == nil ->
      Value;
    true ->
      findLowest(Left)
  end.