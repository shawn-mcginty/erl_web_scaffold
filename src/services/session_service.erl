%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2018 10:53 AM
%%%-------------------------------------------------------------------
-module(session_service).
-author("shawn").

-include("../records.hrl").

%% API
-export([row_to_record/2, start_session/2, is_authenticated/1, clear_session/1]).

-spec row_to_record(list(epgsql:column()), epgsql:equery_row()) -> session().
row_to_record(Columns, Row) ->
  {ok, Id} = db_record_utils:get_column(<<"id">>, Columns, Row),
  {ok, User_id} = db_record_utils:get_column(<<"user_id">>, Columns, Row),
  {ok, Expires} = db_record_utils:get_column(<<"expires">>, Columns, Row),
  #session{id=Id, user_id=User_id, expires=Expires}.

-spec start_session(user(), cowboy_req:req()) -> cowboy_req:req().
start_session(User, Req) ->
  TwentyFourHours = 86400,
  Now = erlang:universaltime(),
  TwentyFourHoursFromNow = calendar:gregorian_seconds_to_datetime(calendar:datetime_to_gregorian_seconds(Now) + TwentyFourHours),
  Session = session_repo:create_session(User#user.id, TwentyFourHoursFromNow),
  cowboy_req:set_resp_cookie(<<"sessionid">>, Session#session.id, Req).

-spec is_authenticated(cowboy_req:req()) -> {ok, cowboy_req:req()} | {false, cowboy_req:req()}.
is_authenticated(Req) ->
  Cookies = cowboy_req:parse_cookies(Req),
  case lists:keyfind(<<"sessionid">>, 1, Cookies) of
    {<<"sessionid">>, _SessionId} ->
      {ok, Req};
    _ ->
      {false, Req}
  end.

-spec clear_session(cowboy_req:req()) -> {ok, cowboy_req:req()}.
clear_session(Req) ->
  Cookies = cowboy_req:parse_cookies(Req),
  case lists:keyfind(<<"sessionid">>, 1, Cookies) of
    {<<"sessionid">>, SessionId} ->
      case session_repo:get_session(SessionId) of
        {true, Session} ->
          ok = session_repo:delete_user_session(Session#session.user_id),
          clear_cookie(Req);
        _ ->
          clear_cookie(Req)
      end;
    _ ->
      clear_cookie(Req)
  end.

-spec clear_cookie(cowboy_req:req()) -> {ok, cowboy_req:req()}.
clear_cookie(Req) ->
  Req1 = cowboy_req:set_resp_cookie(<<"sessionid">>, <<>>, Req, #{max_age => 0}),
  {ok, Req1}.