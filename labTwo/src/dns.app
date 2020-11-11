%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. Oct 2020 6:28 PM
%%%-------------------------------------------------------------------
{application, dns, [
  {description, "DNS app"},
  {vsn, "1"},
  {registered, [dns_serv, balancer_serv, dns_app, dns_sup]},
  {applications, [
    kernel,
    stdlib
  ]},
  {mod, {dns_app, []}},
  {env, []}
]}.