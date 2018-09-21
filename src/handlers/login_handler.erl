%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Sep 2018 12:30 PM
%%%-------------------------------------------------------------------
-module(login_handler).
-author("shawn").

%% API
-export([init/2]).

template() -> "<!DOCTYPE html>" ++
  "<html lang=\"en\">" ++
  "<head>" ++
  "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, shrink-to-fit=no\">" ++
  "<title>Test</title>" ++
  "<link href=\"/assets/stylesheets/main.css\" rel=\"stylesheet\">" ++
  "<link href=\"/assets/stylesheets/animate.min.css\" rel=\"stylesheet\">" ++
  "</head>" ++
  "<body>" ++
  "<div id=\"login\"><login-form></login-form></div>" ++
  "<script src=\"/assets/js/login.bundle.js\"></script>" ++
  "</body>" ++
  "</html>".

init(Req, State) ->
  case cowboy_req:method(Req) of
    <<"GET">> -> get(Req, State);
    <<"POST">> -> post(Req, State);
    _ -> cowboy_req:reply(404, Req)
  end.

-spec get(cowboy_req:req(), any()) -> {ok, cowboy_req:req(), any()}.
get(Req, State) ->
  Req2 = cowboy_req:reply(200,
    #{<<"content-type">> => <<"text/html">>},
    template(),
    Req),
  {ok, Req2, State}.

-spec post(cowboy_req:req(), any()) -> {ok, cowboy_req:req(), any()}.
post(Req, State) ->
  {ok, Body, Req1} = read_post_body(Req),
  {value, {<<"email">>, Email}} = lists:search(fun(X) ->
    case X of
      {<<"email">>, _Value} -> true;
      _ -> false
    end end, Body),
  {value, {<<"pword">>, Pword}} = lists:search(fun(X) ->
    case X of
      {<<"pword">>, _Value} -> true;
      _ -> false
    end end, Body),

  case user_repo:is_authentic(Email, Pword) of
    {true, User} ->
      Req2 = session_service:start_session(User, Req1),
      Req3 = cowboy_req:reply(302,
        #{<<"location">> => <<"/home">>},
        <<>>,
        Req2),
      {ok, Req3, State};
    {false, undefined} ->
      Req2 = cowboy_req:reply(302,
        #{<<"location">> => <<"/login?failed=true">>},
        <<>>,
        Req1),
      {ok, Req2, State}
  end.

-spec read_post_body(cowboy_req:req()) -> {ok, [{binary(), binary() | true}], cowboy_req:req()}.
read_post_body(Req) ->
  case cowboy_req:body_length(Req) of
    undefined ->
      cowboy_req:read_urlencoded_body(Req);
    Length ->
      cowboy_req:read_urlencoded_body(Req, #{length => Length})
  end.

