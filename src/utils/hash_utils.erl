%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2018 9:53 PM
%%%-------------------------------------------------------------------
-module(hash_utils).
-author("shawn").

%% API
-export([pword_hash/1]).

-spec pword_hash(string()) -> string().
pword_hash(Str) ->
  [ element(C+1, {$0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$A,$B,$C,$D,$E,$F}) || <<C:4>> <= crypto:hash(sha256,Str)].
