%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Sep 2018 10:25 PM
%%%-------------------------------------------------------------------
-module(user_repo).
-author("shawn").
-behavior(repository).

-include("../records.hrl").
-define(AUTH_QUERY, "AUTH_QUERY").

%% API
-export([prep_statements/1, is_authentic/2]).

prep_statements(Connection) ->
  {ok, _} = epgsql:parse(Connection, ?AUTH_QUERY, "SELECT * FROM Users WHERE email=$1 AND pword=$2", [varchar, varchar]),
  ok.

-spec is_authentic(string(), string()) -> {false, undefined} | {true, user()}.
is_authentic(Email, Pword) ->
  PwordHash = hash_utils:pword_hash(Pword),
  {ok, Columns, Rows} = db_connection:prepared_query(?AUTH_QUERY, [Email, PwordHash]),
  case length(Rows) of
    0 ->
      {false, undefined};
    _ ->
      [UserRow | _] = Rows,
      {true, user_service:row_to_record(Columns, UserRow)}
  end.
