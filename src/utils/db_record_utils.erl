%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Sep 2018 11:49 PM
%%%-------------------------------------------------------------------
-module(db_record_utils).
-author("shawn").

%% API
-export([get_column/3]).

-spec get_column(binary(), list(epgsql:column()), epgsql:equery_row()) -> {ok, any()} | {not_found}.
get_column(ColName, Columns, Rows) ->
  get_column(ColName, Columns, Rows, 1).

get_column(ColName, [CHead | CTail], Rows, Index) ->
  case {element(1, CHead), element(2, CHead)} of
    {column, ColName} ->
      {ok, element(Index, Rows)};
    _ ->
      get_column(ColName, CTail, Rows, Index + 1)
  end;
get_column(_, _, _, _) -> {not_found}.