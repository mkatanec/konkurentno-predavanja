%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Oct 2020 6:27 PM
%%%-------------------------------------------------------------------
-module(helpers).
-author("mkatanec").

%% API
-export([add/0, add/1, replace/0, replace/1, find/0, find/1, delete/0, delete/1]).


add(Person) ->
  server ! {self(), add, Person},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

add() ->
  add({"Mac", "Miller", []}).

replace(Person) ->
  server ! {self(), replace, Person},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

replace() ->
  replace({"Mac", "Miller", [{"Netko", "Drug"}]}).

delete(Person) ->
  server ! {self(), delete, Person},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

delete() ->
  delete({"Mac", "Miller"}).

find(Person) ->
  server ! {self(), find, Person},
  receive
    Response ->
      io:format("Response: ~w~n", [Response])
  end.

find() ->
  find({"Mac", "Miller"}).
