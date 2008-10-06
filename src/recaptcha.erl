%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Copyright (C) 2008 by Denis Pauk ( pauk.denis@gmail.com )            %%
%%                                                                        %%
%%   This program is free software; you can redistribute it and/or modify %%
%%   it under the terms of the GNU General Public License as published by %%
%%   the Free Software Foundation; either version 2 of the License, or    %%
%%   (at your option) any later version.                                  %%
%%                                                                        %%
%%   This program is distributed in the hope that it will be useful,      %%
%%   but WITHOUT ANY WARRANTY; without even the implied warranty of       %%
%%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        %%
%%   GNU General Public License for more details.                         %%
%%                                                                        %%
%%   You should have received a copy of the GNU General Public License    %%
%%   along with this program; if not, write to the                        %%
%%   Free Software Foundation, Inc.,                                      %%
%%   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(recaptcha).
-export([genCaptcha/1]).
-export([getResult/4]).

%%генерация капчи
%%Generate frame for recaptcha
genCaptcha(PublicKey) ->
  "<script type='text/javascript'" ++
  "src='http://api.recaptcha.net/challenge?k=" ++ PublicKey ++ "'>" ++
  "</script> " ++
  "<noscript>" ++
  "<iframe src='http://api.recaptcha.net/noscript?k=" ++ PublicKey ++ "' height='300' width='500' frameborder='0'></iframe><br>" ++
  "<textarea name='recaptcha_challenge_field' rows='3' cols='40'>" ++
  "</textarea>" ++
  "<input type='hidden' name='recaptcha_response_field'" ++
  "value='manual_challenge'></noscript>".

%%Заготовка для проверки капчи
%%Check result recaptcha work
getResult(Privatekey,Remoteip,Challenge,Response) ->
  	 Server = "http://api-verify.recaptcha.net/verify",
	 PostParams = mochiweb_util:urlencode([
					{"privatekey",Privatekey},
					{"remoteip",Remoteip},
					{"challenge",Challenge},
					{"response",Response}]),
	io:format("Req ~p ~n",[PostParams]),
	case http:request(post,
          {Server, [],
           "application/x-www-form-urlencoded", PostParams},
          [ {timeout, 3000} ],[])  of
		{ok,{_,_,Body}} ->	
			SplitStr = string:tokens(Body,"\n"),
			case SplitStr of
				["true" | _] -> 
					{ok};
				["false" | Result] ->
				       {error,Result};
				_ ->
				       {error,"Result not found"}					
			end;
		{error,Reason} -> 
			{error,Reason}
	end.
