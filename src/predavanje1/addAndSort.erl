%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Oct 2020 4:49 PM
%%%-------------------------------------------------------------------
-module(addAndSort).
-author("mkatanec").

%% API
-export([addToList/2]).

addToList (Element, List) ->
  FirstPartOfTheList = [X || X <- List, X < Element],
  Rest = [X || X <- List, X > Element],
  Combined = FirstPartOfTheList ++ [Element] ++ Rest,
  io:fwrite("~w~n", [Combined]).

