%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2018 5:20 PM
%%%-------------------------------------------------------------------
-author("shawn").

-record(session, {id :: string(), user_id :: string(), expires :: calendar:datetime() }).
-type session() :: #session{}.
-record(user, {email :: string(), pword :: string(), id :: string()}).
-type user() :: #user{}.