%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2018 11:04 AM
%%%-------------------------------------------------------------------
-module(repository).
-author("shawn").
-callback prep_statements(Connection :: epgsql:connection()) -> Status :: atom().
