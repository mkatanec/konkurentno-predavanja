%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Oct 2020 6:59 PM
%%%-------------------------------------------------------------------
-module(find).
-author("mkatanec").

%% API
-export([run/0, server_loop/1, find/1, find/3, map/0]).

map() ->
  #{"Person1" => [{"Person", "2"}, {"Person", "3"}, {"Person", "4"}],
    "Person2" => [{"Person", "3"}, {"Person", "4"}],
    "Person3" => [{"Person", "4"}],
    "Person4" => [{"Person", "1"}]}.

run() ->
  Map = map(),
  Pid = spawn(api, server_loop, [Map]),
  register(server, Pid).

server_loop(Map) ->
  receive
    {Pid, Person} ->
      Response = find(Person, Map, 1),
      Pid ! Response,
      server_loop(Map)
  end.

find(Number) ->
  find({"Person", Number}, map(), 0).

getList(Response) ->
  {_, Parent} = Response,
  Parent.

%% dvije liste
find(Person, Map, Depth) ->
  if
    Depth > 1 ->
      Parent = find(Person, Map, 1),
      NewDepth = Depth - 1,
      [{Name, Surname, find({Name, Surname}, Map, NewDepth)} || {Name, Surname} <- Parent];
    true ->
      {Name, Surname} = Person,
      getList(maps:find(string:concat(Name, Surname), Map))
  end.