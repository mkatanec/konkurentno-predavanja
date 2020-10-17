%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Oct 2020 4:37 PM
%%%-------------------------------------------------------------------
-module(addToList).
-author("mkatanec").

%% API
-export([run/0]).

run() ->
  addToList(2, [1, 3, 4]).

addToList(Element, List) ->
  Nes = List ++ [Element],
  io:fwrite("~w~n", [Nes]).
