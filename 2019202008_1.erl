-module('2019202008_1').

-export([catch_token/1,loop/4,main/1, do_loop/3]).

catch_token(Filename) ->
    receive
    {A,B,Token,Process} ->
        if
            A < Process ->
                {ok, Output} = file:open(Filename,[append]),
                io:format(Output,"Process ~p received token ~p from process ~p\n",[A,Token,B]),
                file:close(Output),
                Tp = A+1,
                Tq = Tp-1,
                Pid = spawn('2019202008_1',catch_token, [Filename]),
                Pid ! {Tp,Tq,Token,Process};
            true ->
                {ok, Output} = file:open(Filename,[append]),
                io:format(Output,"Process 0 received token ~p from process ~p\n",[Token,Process-1]),
                file:close(Output)
        end,
        ok
    end.

do_loop(Process, Token, Filename) ->
    Totalsize = Process,
    loop(Process,Totalsize,Token, Filename).

loop(Process, Totalsize, Token, Filename) ->
    A = 1,
    B = 0,
    Pid = spawn('2019202008_1',catch_token, [Filename]),
    Pid ! {A,B,Token, Process}.
    
main([Arg1,Arg2]) ->
    {ok, Input} = file:read_file(Arg1),
    %{ok, Output} = file:open(Arg2,[write]),
    Lines = string:tokens(erlang:binary_to_list(Input), "\n"),
    First = lists:nth(1,Lines),
    [P, M] = string:tokens(First," "),
    {Process, L1} = string:to_integer(P),
    {Token, L2} = string:to_integer(M),
    do_loop(Process,Token, Arg2).
    %file:close(Output).