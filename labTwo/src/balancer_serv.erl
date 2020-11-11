%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(balancer_serv).

-behaviour(gen_server).

-export([start_link/1, stop/0, add/1, find/1, replace/1, delete/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, [], []).

init([]) ->
  {ok, nil}.

handle_call(stop, _From, State) ->
  {stop, normal, stopped, State};

handle_call({find, Address}, _From, State) ->
  [_, _, ParsedUrl] = string:split(Address, ".", all),
  [Tld | _] = string:split(ParsedUrl, "/", all),
  IsHr = string:equal(Tld, "hr"),
  IsCom = string:equal(Tld, "com"),
  IsIo = string:equal(Tld, "io"),
  if
    IsHr ->
      {reply, callHrDns(find, Address), State};
    IsCom ->
      {reply, callIoDns(find, Address), State};
    IsIo ->
      {reply, callComDns(find, Address), State};
    true ->
      "Not supported TLD"
  end.

handle_cast({Method, {Address, IpAddress}}, _State) ->
  [_, _, ParsedUrl] = string:split(Address, ".", all),
  [Tld | _] = string:split(ParsedUrl, "/", all),
  IsHr = string:equal(Tld, "hr"),
  IsCom = string:equal(Tld, "com"),
  IsIo = string:equal(Tld, "io"),
  if
    IsHr ->
      {noreply, callHrDns(Method, {Address, IpAddress})};
    IsCom ->
      {noreply, callIoDns(Method, {Address, IpAddress})};
    IsIo ->
      {noreply, callComDns(Method, {Address, IpAddress})};
    true ->
      "Not supported TLD"
  end.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

callHrDns(add, Entry) ->
  gen_server:cast(hrDnsServ, {add, Entry});

callHrDns(delete, Entry) ->
  gen_server:cast(hrDnsServ, {delete, Entry});

callHrDns(replace, Entry) ->
  gen_server:cast(hrDnsServ, {replace, Entry});

callHrDns(find, Address) ->
  gen_server:call(hrDnsServ, {find, Address}).

callIoDns(add, Entry) ->
  gen_server:cast(ioDnsServ, {add, Entry});

callIoDns(delete, Entry) ->
  gen_server:cast(ioDnsServ, {delete, Entry});

callIoDns(replace, Entry) ->
  gen_server:cast(ioDnsServ, {replace, Entry});

callIoDns(find, Address) ->
  gen_server:call(ioDnsServ, {find, Address}).

callComDns(add, Entry) ->
  gen_server:cast(comDnsServ, {add, Entry});

callComDns(delete, Entry) ->
  gen_server:cast(comDnsServ, {delete, Entry});

callComDns(replace, Entry) ->
  gen_server:cast(comDnsServ, {replace, Entry});

callComDns(find, Address) ->
  gen_server:call(comDnsServ, {find, Address}).

stop() ->
  gen_server:call(balancerServ, stop).

add(Entry) ->
  gen_server:cast(balancerServ, {add, Entry}).

find(Address) ->
  gen_server:call(balancerServ, {find, Address}).

delete(Entry) ->
  gen_server:cast(balancerServ, {delete, Entry}).

replace(Entry) ->
  gen_server:cast(balancerServ, {replace, Entry}).