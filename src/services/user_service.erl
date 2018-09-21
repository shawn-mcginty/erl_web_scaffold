%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Sep 2018 11:21 PM
%%%-------------------------------------------------------------------
-module(user_service).
-author("shawn").

-include("../records.hrl").

%% API
-export([row_to_record/2]).

-spec row_to_record(list(epgsql:column()), epgsql:equery_row()) -> user().
row_to_record(Columns, Row) ->
  {ok, Id} = db_record_utils:get_column(<<"id">>, Columns, Row),
  {ok, Email} = db_record_utils:get_column(<<"email">>, Columns, Row),
  {ok, Pword} = db_record_utils:get_column(<<"pword">>, Columns, Row),
  #user{id=Id, email=Email, pword=Pword}.

