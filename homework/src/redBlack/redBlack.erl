%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Oct 2020 8:53 AM
%%%-------------------------------------------------------------------
-module(redBlack).
-author("mkatanec").

%% API
-export([run/0, add/1, remove/1, find/1, server_loop/1, create_tree/0]).

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

create_tree() ->
  run(),
  add(10),
  add(5),
  add(-5),
  add(7),
  add(20),
  add(38),
  add(30),
  add(35).

run() ->
  Pid = spawn(redBlack, server_loop, [nil]),
  register(server, Pid).

server_loop(Tree) ->
  receive
    {Pid, add, Value} ->
      NewTree = turnBlack(add(Tree, Value)),
      Pid ! NewTree,
      server_loop(NewTree);
    {Pid, delete, Value} ->
      NewTree = delete(Tree, Value),
      Pid ! NewTree,
      server_loop(NewTree);
    {Pid, find, Value} ->
      Node = find(Tree, Value),
      Pid ! Node,
      server_loop(Tree);
    stop ->
      unregister(server),
      true;
    Ignore ->
      io:format("Ignore: ~w~n", [Ignore]),
      server_loop(Tree)
  end.

add(nil, Value) ->
  balance({Value, red, nil, nil});

add({Value, Color, Left, Right}, NewValue) ->
  if
    NewValue > Value ->
      balance({Value, Color, Left, add(Right, NewValue)});
    NewValue < Value ->
      balance({Value, Color, add(Left, NewValue), Right});
    true ->
      {Value, Color, Left, Right}
  end.

delete({Value, Color, {KeyValue, red, nil, nil}, Right}, KeyValue) ->
%%  io:format("a~n"),
%%  io:format("Prije: ~w~n", [{Value, black, {KeyValue, red, nil, nil}, Right}]),
%%  io:format("Poslje: ~w~n", [{Value, black, nil, Right}]),
  {Value, Color, nil, Right};

delete({Value, Color, Left, {KeyValue, red, nil, nil}}, KeyValue) ->
%%  io:format("b~n"),
%%  io:format("Prije: ~w~n", [{Value, black, Left, {KeyValue, red, nil, nil}}]),
%%  io:format("Poslje: ~w~n", [{Value, black, Left, nil}]),
  {Value, Color, Left, nil};

delete({Value, Color, {KeyValue, LeftColor, LeftLeft, LeftRight}, Right}, KeyValue) ->
%%  io:format("c~n"),
%%  io:format("Prije: ~w~n", [{Value, Color, {KeyValue, LeftColor, LeftLeft, LeftRight}, Right}]),
%%  io:format("Poslje: ~w~n", [{Value, Color, {findLowest(LeftRight), LeftColor, LeftLeft, delete(LeftRight, findLowest(LeftRight))}, Right}]),
  {Value, Color, {findLowest(LeftRight), LeftColor, LeftLeft, delete(LeftRight, findLowest(LeftRight))}, Right};

delete({Value, Color, Left, {KeyValue, RightColor, RightLeft, RightRight}}, KeyValue) ->
%%  io:format("d~n"),
%%  io:format("Prije: ~w~n", [{Value, Color, Left, {KeyValue, RightColor, RightLeft, RightRight}}]),
%%  io:format("Poslje: ~w~n", [{Value, Color, Left, {findLowest(RightRight), RightColor, RightLeft, delete(RightRight, findLowest(RightRight))}}]),
  {Value, Color, Left, {findLowest(RightRight), RightColor, RightLeft, delete(RightRight, findLowest(RightRight))}};

delete({Value, Color, Left, Right}, KeyValue) ->
  if
    KeyValue > Value ->
      io:format("find-a~n"),
      io:format("Prije: ~w~n", [Right]),
      io:format("Poslje: ~w~n", [delete(Right, KeyValue)]),
      {Value, Color, Left, delete(Right, KeyValue)};
    KeyValue < Value ->
      io:format("find-b~n"),
      io:format("Prije: ~w~n", [Left]),
      io:format("Poslje: ~w~n", [delete(Left, KeyValue)]),
      {Value, Color, delete(Left, KeyValue), Right};
    true ->
      io:format("find-c~n"),
      io:format("Prije: ~w~n", [{Value, Color, Left, Right}]),
      io:format("Poslje: ~w~n", [{Value, Color, Left, Right}]),
      {Value, Color, Left, Right}
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

%% triangle
%% crveni ujak
balance({Value, black, {LeftValue, red, LeftLeft, {RightLeftValue, red, RightLeftLeft, RightLeftRight}}, {RightValue, red, RightLeft, RightRight}}) ->
  balance({Value, red, {LeftValue, black, LeftLeft, {RightLeftValue, red, RightLeftLeft, RightLeftRight}}, {RightValue, black, RightLeft, RightRight}});

balance({Value, black, {LeftValue, red, {LeftLeftValue, red, LeftLeftLeft, LeftLeftRight}, LeftRight}, {RightValue, red, RightLeft, RightRight}}) ->
  balance({Value, red, {LeftValue, black, {LeftLeftValue, red, LeftLeftLeft, LeftLeftRight}, LeftRight}, {RightValue, black, RightLeft, RightRight}});

balance({Value, black, {LeftValue, red, LeftLeft, LeftRight}, {RightValue, red, RightLeft, {RightRightValue, red, RightRightLeft, RightRightRight}}}) ->
  balance({Value, red, {LeftValue, black, LeftLeft, LeftRight}, {RightValue, black, RightLeft, {RightRightValue, red, RightRightLeft, RightRightRight}}});

balance({Value, black, {LeftValue, red, LeftLeft, RightLeft}, {RightValue, red, {RightLeftValue, red, RightLeftLeft, RightLeftRight}, RightRight}}) ->
  balance({Value, red, {LeftValue, black, LeftLeft, RightLeft}, {RightValue, black, {RightLeftValue, red, RightLeftLeft, RightLeftRight}, RightRight}});

%%crni ujak
balance({Value, black, Left, {RightValue, red, {LeftRightValue, red, LeftRightLeft, LeftRightRight}, RightRight}}) ->
  balance({Value, black, Left, {LeftRightValue, red, LeftRightLeft, {RightValue, red, LeftRightRight, RightRight}}});

balance({Value, black, {LeftValue, red, LeftLeft, {RightLeftValue, red, RightLeftLeft, RightLeftRight}}, Right}) ->
  balance({Value, black, {RightLeftValue, red, {LeftValue, red, LeftLeft, RightLeftLeft}, RightLeftRight}, Right});

%% line
balance({Value, black, {LeftValue, red, {LeftLeftValue, red, LeftLeftLeft, LeftLeftRight}, LeftRight}, Right}) ->
  balance({LeftValue, black, {LeftLeftValue, red, LeftLeftLeft, LeftLeftRight}, {Value, red, LeftRight, Right}});

balance({Value, black, Left, {RightValue, red, RightLeft, {RightRightValue, red, RightRightLeft, RightRightRight}}}) ->
  balance({RightValue, black, {Value, red, Left, RightLeft}, {RightRightValue, red, RightRightLeft, RightRightRight}});

balance({Value, Color, Left, Right}) ->
  {Value, Color, Left, Right}.

turnBlack({Value, _, Left, Right}) ->
  {Value, black, Left, Right}.

findLowest({Value, _, Left, _}) ->
  if
    Left == nil ->
      Value;
    true ->
      findLowest(Left)
  end.
