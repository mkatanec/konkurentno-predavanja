%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Oct 2020 9:57 AM
%%%-------------------------------------------------------------------
-module(add).
-author("mkatanec").

%% API
-export([run/0, server_loop/0]).

run() ->
  Pid = spawn(add, server_loop, []),
  global:register_name(add, Pid),
  Pid.

server_loop() ->
  receive
    {Pid, Tree, Value} ->
      NewTree = turnBlack(add(Tree, Value)),
      Pid ! NewTree,
      server_loop();
    stop ->
      true
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