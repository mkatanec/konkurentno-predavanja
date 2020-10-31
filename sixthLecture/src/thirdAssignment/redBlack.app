%%%-------------------------------------------------------------------
%%% @author mkatanec
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. Oct 2020 6:28 PM
%%%-------------------------------------------------------------------
{application, redBlack, [
  {description, "Red black tree app"},
  {vsn, "1"},
  {registered, [redBlack, redBlack_serv, redBlack_sup]},
  {applications, [
    kernel,
    stdlib
  ]},
  {mod, {redBlack, []}},
  {env, []}
]}.