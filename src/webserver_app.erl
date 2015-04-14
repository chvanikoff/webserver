-module(webserver_app).
-behaviour(application).

%% Application callbacks
-export([
    start/2,
    stop/1
]).

%% API
-export([dispatch_rules/0]).

%% ===================================================================
%% API functions
%% ===================================================================

dispatch_rules() ->
    cowboy_router:compile([{'_',
                [
                    {"/css/[...]", cowboy_static, {dir, "./priv/css"}},
                    {"/js/[...]", cowboy_static, {dir, "./priv/js"}},
                    {"/", index_handler, []},
                    {'_', notfound_handler, []}
                ]
            }]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    Dispatch = dispatch_rules(),
    Port = 8080,
    {ok, _} = cowboy:start_http(http, 100,
        [{port, Port}],
        [{env, [{dispatch, Dispatch}]}]
    ).
    %webserver_sup:start_link().

stop(_State) ->
    ok.
