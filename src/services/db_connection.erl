%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Sep 2018 11:06 PM
%%%-------------------------------------------------------------------
-module(db_connection).
-author("shawn").
-behavior(gen_server).

-type select_return() :: {ok, list(epgsql:column()), list(epgsql:equery_row())}.
-type update_return() :: {ok, number()}.
-type insert_return() :: {ok, number(), list(epgsql:column()), list(epgsql:equery_row())}.
-type query_error() :: {error, any()}.
-type query_return() :: select_return() | update_return() | insert_return() | query_error().

%% API
-export([start/1, prepared_query/1, prepared_query/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, handle_continue/2]).
-export_type([query_return/0]).

name() -> db_connection.

-spec start(epgsql:connection()) -> {ok, pid()} | ignore | {error, any()}.
start(Connection) ->
  gen_server:start_link({local,name()}, ?MODULE, Connection, []).

-spec prepared_query(string()) -> query_return().
prepared_query(QueryName) -> gen_server:call(name(), {prepared_query, QueryName, []}).

-spec prepared_query(string(), list()) -> query_return().
prepared_query(QueryName, Parameters) ->
  gen_server:call(name(), {prepared_query, QueryName, Parameters}).

%% Mandatory callback functions
init(Connection) ->
  ok = init_all_repos(Connection),
  {ok, Connection}.

init_all_repos(Connection) ->
  ok = user_repo:prep_statements(Connection),
  ok = session_repo:prep_statements(Connection),
  ok.

handle_cast(_, C) -> {noreply, C}.
handle_info(_, C) -> {noreply, C}.
handle_continue(_, C) -> {noreply, C}.
terminate(_, _C) -> ok.
code_change(_, C, _Extra) -> {ok, C}.

%% End mandatory callback functions

-spec handle_call({prepared_query, string(), list()}, any(), epgsql:connection()) -> {reply, query_return(), epgsql:connection()}.
handle_call({prepared_query, QueryName, Parameters}, _From, Connection) ->
  Return = epgsql:prepared_query(Connection, QueryName, Parameters),
  {reply, Return, Connection};

handle_call(_, _From, Connection) ->
  {error, "Bad call to db_connection", Connection}.

