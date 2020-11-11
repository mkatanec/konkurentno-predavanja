%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(dns_serv).

-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, [], []).

init([]) ->
  {ok, maps:new()}.

handle_call(stop, _From, State) ->
  {stop, normal, stopped, State};

handle_call({find, Address}, _From, State) ->
  {reply, find(State, Address), State}.

handle_cast({add, Entry}, State) ->
  {noreply, add(State, Entry)};

handle_cast({replace, Entry}, State) ->
  {noreply, add(State, Entry)};

handle_cast({delete, Entry}, State) ->
  {noreply, delete(State, Entry)}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

add(Map, {Address, IpAddress}) ->
  maps:put(Address, IpAddress, Map).

delete(Map, {Address, _}) ->
  maps:remove(Address, Map).

find(Map, Address) ->
  maps:find(Address, Map).
