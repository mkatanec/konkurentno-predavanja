%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. Oct 2020 5:31 PM
%%%-------------------------------------------------------------------
-module(redBlack_serv).
-author("mkatanec").

-behaviour(gen_server).

%% API
-export([start_link/1, add/1, find/1, delete/1, stop/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, [], []).

init([]) ->
  {ok, nil}.

handle_call(stop, _From, State) ->
  {stop, normal, stopped, State};

handle_call({find, KeyValue}, _From, State) ->
  {reply, redBlack_lib:find(State, KeyValue), State}.

handle_cast({add, Value}, State) ->
  {noreply, redBlack_lib:add(State, Value)};

handle_cast({delete, Value}, State) ->
  {noreply, redBlack_lib:delete(State, Value)}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


stop() ->
  gen_server:call(?SERVER, stop).

add(Value) ->
  gen_server:cast(?SERVER, {add, Value}).

find(Value) ->
  gen_server:call(?SERVER, {find, Value}).

delete(Value) ->
  gen_server:cast(?SERVER, {delete, Value}).