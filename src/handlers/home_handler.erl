-module(home_handler).
-author("shawn").

%% API
-export([init/2]).

init(Req, State) ->
  case session_service:is_authenticated(Req) of
    {ok, Req1} ->
      display_home(Req1, State);
    {_, Req1} ->
      {ok, Req1, State}
  end.

template() -> "<!DOCTYPE html>" ++
  "<html lang=\"en\">" ++
  "<head>" ++
  "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, shrink-to-fit=no\">" ++
  "<title>Home</title>" ++
  "<link href=\"/assets/stylesheets/main.css\" rel=\"stylesheet\">" ++
  "<link href=\"/assets/stylesheets/animate.min.css\" rel=\"stylesheet\">" ++
  "</head>" ++
  "<body>" ++
  "You made it!" ++
  "<script src=\"/assets/js/login.bundle.js\"></script>" ++
  "</body>" ++
  "</html>".

-spec display_home(cowboy_req:req(), any()) -> {ok, cowboy_req:req(), any()}.
display_home(Req, State) ->
  Req2 = cowboy_req:reply(200,
    #{<<"content-type">> => <<"text/html">>},
    template(),
    Req),
  {ok, Req2, State}.
