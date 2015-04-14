-module(index_handler).

-behaviour(cowboy_http_handler).

-export([ init/3, handle/2, terminate/3 ]).

init(_Transport, Req, _Options) ->
  {ok, Req, no_state}.

handle(Req, State) ->
    {Username, Req2} = cowboy_req:qs_val(<<"username">>, Req, ""),
    {ok, HTML} = index_tpl:render([{username, Username}]),
    {ok, Req3} = cowboy_req:reply(200, [], HTML, Req2),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.
