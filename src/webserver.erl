-module(webserver).

%% API
-export([
    start/0,
    stop/0,
    update_routes/0,
    c_tpl/0, c_tpl/1, c_tpl/2
]).

-define(APPS, [crypto, ranch, cowboy, webserver]).

%% ===================================================================
%% API functions
%% ===================================================================

start() ->
    ok = ensure_started(?APPS),
    ok = sync:go().

stop() ->
    sync:stop(),
    ok = stop_apps(lists:reverse(?APPS)).

update_routes() ->
    Routes = webserver_app:dispatch_rules(),
    cowboy:set_env(http_listener, dispatch, Routes).

c_tpl() ->
    c_tpl([]).

c_tpl(Opts) ->
    c_tpl(filelib:wildcard("tpl/*.dtl"), Opts).

c_tpl([], _Opts) -> ok;
c_tpl([File | Files], Opts) ->
    ok = erlydtl:compile(File, re:replace(filename:basename(File), ".dtl", "_tpl", [global, {return, list}]), Opts),
    c_tpl(Files, Opts).

%% ===================================================================
%% Internal functions
%% ===================================================================

ensure_started([]) -> ok;
ensure_started([App | Apps]) ->
    case application:start(App) of
        ok -> ensure_started(Apps);
        {error, {already_started, App}} -> ensure_started(Apps)
    end.

stop_apps([]) -> ok;
stop_apps([App | Apps]) ->
    application:stop(App),
    stop_apps(Apps).