%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Sep 2018 4:01 PM
%%%-------------------------------------------------------------------
-module(logout_handler).
-author("shawn").

%% API
-export([init/2]).

init(Req, State) ->
  {ok, Req1} = session_service:clear_session(Req),
  redirect_to_login(Req1, State).

-spec redirect_to_login(cowboy_req:req(), any()) -> {ok, cowboy_req:req(), any()}.
redirect_to_login(Req, State) ->
  Req1 = cowboy_req:reply(302,
    #{<<"location">> => <<"/login">>},
    <<>>,
    Req),
  {ok, Req1, State}.
