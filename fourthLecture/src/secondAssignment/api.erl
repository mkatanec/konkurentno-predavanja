%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Oct 2020 5:48 PM
%%%-------------------------------------------------------------------
-module(api).
-author("mkatanec").

%% API
-export([server_loop/1, run/0, add/0, replace/0, delete/0, find/0, add/1, replace/1, delete/1, find/1]).

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

run() ->
  Pid = spawn(api, server_loop, [maps:new()]),
  register(server, Pid).

server_loop(Map) ->
  receive
    {Pid, add, Person} ->
      M = add(Map, Person),
      Pid ! M,
      server_loop(M);
    {Pid, replace, Person} ->
      M = add(Map, Person),
      Pid ! M,
      server_loop(M);
    {Pid, delete, Person} ->
      M = delete(Map, Person),
      Pid ! M,
      server_loop(M);
    {Pid, find, Person} ->
      M = find(Map, Person),
      Pid ! M,
      server_loop(M);
    stop ->
      unregister(server),
      true;
    Ignore ->
      io:format("Ignore: ~w~n", [Ignore]),
      server_loop(Map)
  end.

add(Map, {Name, Surname, Friends}) ->
  maps:put(string:concat(Name, Surname), Friends, Map).

delete(Map, {Name, Surname}) ->
  maps:remove(string:concat(Name, Surname), Map).

find(Map, {Name, Surname}) ->
  maps:find(string:concat(Name, Surname), Map).