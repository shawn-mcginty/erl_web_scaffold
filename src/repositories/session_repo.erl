%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Sep 2018 10:25 PM
%%%-------------------------------------------------------------------
-module(session_repo).
-author("shawn").
-behavior(repository).

-include("../records.hrl").

-define(GET_SESSION_BY_ID_QUERY, "GET_SESSION_BY_ID").
-define(CREATE_SESSION_QUERY, "CREATE_SESSION_QUERY").
-define(DELETE_SESSION_BY_USER_ID, "DELETE_SESSION_BY_USER_ID").

%% API
-export([prep_statements/1, get_session/1, create_session/2, delete_user_session/1]).

prep_statements(Connection) ->
  {ok, _} = epgsql:parse(Connection, ?GET_SESSION_BY_ID_QUERY, "SELECT * FROM Sessions WHERE id=$1", [uuid]),
  {ok, _} = epgsql:parse(Connection, ?DELETE_SESSION_BY_USER_ID, "DELETE FROM Sessions WHERE user_id=$1", [uuid]),
  {ok, _} = epgsql:parse(Connection, ?CREATE_SESSION_QUERY,
    "INSERT INTO Sessions (user_id, expires) VALUES ($1, $2) RETURNING *",
    [uuid, timestamp]),
  ok.

-spec get_session(binary()) -> {false, undefined} | {true, session()}.
get_session(SessionId) ->
  {ok, Columns, Rows} = db_connection:prepared_query(?GET_SESSION_BY_ID_QUERY, [SessionId]),
  case length(Rows) of
    0 ->
      {false, undefined};
    _ ->
      [SessionRow | _] = Rows,
      {true, session_service:row_to_record(Columns, SessionRow)}
  end.

-spec create_session(string(), calendar:datetime()) -> session().
create_session(UserId, Expires) ->
  {ok, _} = db_connection:prepared_query(?DELETE_SESSION_BY_USER_ID, [UserId]),
  {ok, 1, Columns, Rows} = db_connection:prepared_query(?CREATE_SESSION_QUERY, [UserId, Expires]),
  [SessionRow | _] = Rows,
  session_service:row_to_record(Columns, SessionRow).

-spec delete_user_session(string()) -> ok.
delete_user_session(UserId) ->
  {ok, _} = db_connection:prepared_query(?DELETE_SESSION_BY_USER_ID, [UserId]),
  ok.