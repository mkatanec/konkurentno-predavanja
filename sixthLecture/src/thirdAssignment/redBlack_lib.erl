%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. Oct 2020 5:28 PM
%%%-------------------------------------------------------------------
-module(redBlack_lib).
-author("mkatanec").

%% API
-export([add/2, find/2, delete/2, turnBlack/1]).

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
