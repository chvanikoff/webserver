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
    Static = fun(Filetype) ->
        {lists:append(["/", Filetype, "/[...]"]), cowboy_static, [
            {directory, {priv_dir, webserver, [list_to_binary(Filetype)]}},
            {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
        ]}
    end,
    cowboy_router:compile([
        {'_', [
            Static("css"),
            Static("js"),
            Static("img"),
            {"/", index_handler, []},
            {'_', notfound_handler, []}
        ]}
    ]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    Dispatch = dispatch_rules(),
    Port = 8008,
    {ok, _} = cowboy:start_http(http_listener, 100,
        [{port, Port}],
        [{env, [{dispatch, Dispatch}]}]
    ),
    webserver_sup:start_link().

stop(_State) ->
    ok.