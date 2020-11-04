%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. Oct 2020 6:17 PM
%%%-------------------------------------------------------------------
-module(redBlack_sup).
-author("mkatanec").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  RestartStrategy = one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = 2000,
  Type = worker,

  AChild = {redBlack_servA, {redBlack_serv, start_link, [redBlack_servA]},
    Restart, Shutdown, Type, [redBlack_serv]},
  BChild = {redBlack_servB, {redBlack_serv, start_link, [redBlack_servB]},
    Restart, Shutdown, Type, [redBlack_serv]},

  {ok, {SupFlags, [AChild, BChild]}}.