%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Oct 2020 5:17 PM
%%%-------------------------------------------------------------------
-module(addToListAndSortWithFunction).
-author("mkatanec").

%% API
-export([run/0]).

run() ->
  addToList(2, [1, 3, 4], fun sort/2).

sort(X, E) ->
  X > E.

addToList(Element, List, Sort) ->
  FirstPartOfTheList = [X || X <- List, not Sort(X, Element)],
  Rest = [X || X <- List, Sort(X, Element)],
  Combined = FirstPartOfTheList ++ [Element] ++ Rest,
  io:fwrite("~w~n", [Combined]).
