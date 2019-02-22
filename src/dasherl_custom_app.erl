-module(dasherl_custom_app).

-export([setup/0,
    stop/1]).

% start the dasherl module and compile
setup() ->
    {ok, Server} = dasherl_gunicorn_worker:start_link([]),
    ok = dasherl:compile(Server, "/cancer-data", dasherl_custom_app_mod_handler),
    ok = dasherl_gunicorn_worker:run_server(Server),
    {ok, Server}.

% stop the server
stop(Server) ->
    dasherl_gunicorn_worker:stop(Server).
