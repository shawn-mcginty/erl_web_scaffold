%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Sep 2018 10:29 AM
%%%
%%% A very simple lager wrapper, b/c with mix lager doesn't work quite right
%%%-------------------------------------------------------------------
-module(logging).
-author("shawn").

-ifdef(debug).
-define(LOG_DEBUG, lager:log).
-define(LOG_LEVEL(), lager:set_loglevel(lager_console_backend, debug)).
-else.
-define(LOG_DEBUG(X, Y, Z), true).
-define(LOG_DEBUG(W, X, Y, Z), true).
-define(LOG_LEVEL(), true).
-endif.


%% API
-export([debug/1, debug/2, info/1, info/2, error/1, error/2, start/0]).

start() ->
  R = lager:start(),
  ?LOG_LEVEL(),
  R.

debug(Str) -> ?LOG_DEBUG(debug, ?MODULE, Str).

debug(Format, Args) -> ?LOG_DEBUG(debug, ?MODULE, Format, Args).

info(Str) -> lager:log(info, ?MODULE, Str).

info(Format, Args) -> lager:log(info, ?MODULE, Format, Args).

error(Str) -> lager:log(error, ?MODULE, Str).

error(Format, Args) -> lager:log(error, ?MODULE, Format, Args).
