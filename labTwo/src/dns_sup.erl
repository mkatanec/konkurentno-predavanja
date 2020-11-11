%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Nov 2020 9:49 AM
%%%-------------------------------------------------------------------
-module(dns_sup).
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

  HrDns = {hrDns, {dns_serv, start_link, [hrDnsServ]},
    Restart, Shutdown, Type, [dns_serv]},
  ComDns = {comDns, {dns_serv, start_link, [comDnsServ]},
    Restart, Shutdown, Type, [dns_serv]},
  IoDns = {ioDns, {dns_serv, start_link, [ioDnsServ]},
    Restart, Shutdown, Type, [dns_serv]},
  Balancer = {balancer, {balancer_serv, start_link, [balancerServ]},
    Restart, Shutdown, Type, [balancer_serv]},

  {ok, {SupFlags, [HrDns, ComDns, IoDns, Balancer]}}.
