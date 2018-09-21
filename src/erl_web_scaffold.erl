-module(erl_web_scaffold).

-behaviour(application).

-export([start/2, start/0, stop/1]).

start(_StartType, _Args) ->
  ok = logging:start(),
  logging:debug("Starting app with debug."),
  logging:info("Starting supervisor..."),
  {ok, Pid} = erl_web_scaffold_sup:start_link(),
  logging:info("Starting database connection..."),
  ok = start_database_connection(),
  logging:info("Starting HTTP server..."),
  ok = start_http_server(),
  logging:info("Up and running: ~p~n", [Pid]),
  {ok, Pid}.

start() -> start(nil, nil).

stop(State) ->
  %% hook for any cleanup %%
  logger:info("Stopping application..."),
  logger:info(io_lib:format("~s", State)),
  {ok}.

start_http_server() ->
  Routes = [ {
    '_',
    [
      {"/assets/[...]", cowboy_static, {priv_dir, erl_web_scaffold, "public"}},
      {"/login", login_handler, []},
      {"/logout", logout_handler, []},
      {"/home", home_handler, []}
    ]
  } ],
  Dispatch = cowboy_router:compile(Routes),
  {ok, _} = cowboy:start_clear(api,
    [{port, 8080}],
    #{env => #{dispatch => Dispatch}}
  ),
  ok.

start_database_connection() ->
  {ok, C} = epgsql:connect("localhost", "sbox", "sbox1", #{
    database => "sbox_dev",
    timeout => 4000
  }),
  {ok, _} = db_connection:start(C),
  ok.