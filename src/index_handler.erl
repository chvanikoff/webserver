-module(index_handler).
-behaviour(cowboy_http_handler).
%% Cowboy_http_handler callbacks
-export([
    init/3,
    handle/2,
    terminate/3
]).

init({tcp, http}, Req, _Opts) ->
    {ok, Req, undefined_state}.

handle(Req, State) ->
    {Username, Req2} = cowboy_req:qs_val(<<"username">>, Req, "stranger"),
    {ok, HTML} = index_tpl:render([{username, Username}]),
    {ok, Req3} = cowboy_req:reply(200, [], HTML, Req2),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.