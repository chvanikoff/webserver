-module(notfound_handler).
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
    {URL, Req2} = cowboy_req:url(Req),
    {ok, HTML} = '404_tpl':render([{url, URL}]),
    {ok, Req3} = cowboy_req:reply(404, [], HTML, Req2),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.