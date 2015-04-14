-module(notfound_handler).

-behaviour(cowboy_http_handler).

-export([ init/3, handle/2, terminate/3 ]).

init(_Transport, Req, _Options) ->
    {ok, Req, no_state}.

handle(Req, State) ->
    {URL, Req2} = cowboy_req:url(Req),
    {ok, HTML} = '404_tpl':render([{url, URL}]),
    {ok, Req3} = cowboy_req:reply(404, [], HTML, Req2),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.
