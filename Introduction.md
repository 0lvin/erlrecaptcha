### Introduction on English ###
Full web-api for recaptcha you can found in [API](http://recaptcha.net/apidocs/captcha/).
For using needed mochiweb\_util  from http://code.google.com/p/mochiweb/. Before using please start inets(inets:start()).

Example using:
  1. recaptcha:genCaptcha(Public key from recaptcha.net) - returned part html code. This part you must to  your html-form.
  1. recaptcha:getResult(Private key from recaptcha.net, client ip,Recaptchachallenge(key returned from form in recaptcha\_challenge\_field),Recaptcharesponse(key returned from form in recaptcha\_response\_field)) - returned:
  * {ok} - all right,
  * {error,"Error message"} - test failed.

### Some help ###
For receive client ip you can use this code:

**Yaws**

getIp(A) ->
> Peer = if
> > tuple(A#arg.clisock),
> > element(1, A#arg.clisock) == sslsocket ->
> > > ssl:peername(A#arg.clisock);

> > true ->
> > > inet:peername(A#arg.clisock)

> > end,

> {ok,{IP,_}} = Peer,
> {IP1,IP2,IP3,IP4} = IP,
> integer\_to\_list(IP1) ++ "." ++
> integer\_to\_list(IP2) ++ "." ++
> integer\_to\_list(IP3) ++ "." ++
> integer\_to\_list(IP4)._

IP received from client socket by A#arg.clisock, where A is #arg record received from yaws. Some exapmle for use yaws you can found [on this link](http://yaws.hyber.org/simple.yaws).

**Mochiweb (Thanks for the solution [Ken Pratt](http://kenpratt.net))**

getIp(Req) ->
> Req:get(peer).

Example for use [mochiweb](http://code.google.com/p/mochiweb/) you can found [on this page](http://www.rsaccon.com/2007/09/mochiweb-erlang-based-webserver-toolkit.html).

### Общее описание ###
Система [Recaptcha](http://recaptcha.net/apidocs/captcha/) предназначена для выполнения теста Turing относительно пользователей системы. Проверка проводиться через просьбу пользователя ввести 2 слова отображённых на картинке или при желании произнесённых в медиа файле. Из этих 2 слов одно является уже распознанным ранее словом и одно которое не удалось распознать системе OCR. Пользователи вводя эти слова позволяют хоть медленно преобразовывать не распознанные слова для ранее напечатанных книг. Как результат одно слово реально проверяется (100% известно что это за слово) относительно второго существует только статистическая информация как пользователи его распознают - затем эти данные используются для распознания книг.

### Использование ###
  1. Для использования нужно зайти на сайт admin.recaptcha.net и зарегистрироваться и указать для какого сайта вы хотите добавить проверку. Нужно указывать реальное имя или домен - ответы проверяются на соответствие с доменом пользователя. После регистрации получаем 2 ключа публичный и закрытый.
  1. В страницу сайта добавляем скрипт указанный в документации с добавлением в него публичного ключа.
  1. В параметры ответа в результате добавляются 2 параметра recaptcha\_response\_field(ответ пользователя) и recaptcha\_challenge\_field(код теста).
  1. Для проверки ответа отправляем на сайт http://api-verify.recaptcha.net/verify эти 2 параметра плюс закрытый ключ и ип клиента. В ответ нам присылаются 2 строки в первой true или false в зависимости от результатов проверки и описание результатов. Желательно в качестве ip всегда передавать ip клиента - если всегда передавать один ip сайт может заблокировать обработку посчитав что осуществляется попытка подбора значений.

Пример использования кода:
  1. recaptcha:genCaptcha(Открытый ключ выданный на сайте recaptcha) - возвращает кусок кода для добавления в html страницу.
  1. recaptcha:getResult(Закрытый ключ,Адрес c скоторого пришел запрос(IP),Recaptchachallenge(Код теста),Recaptcharesponse(ответ пользователя)) - возвращает:
  * {ok} - если удачно,
  * {error,"Описание ошибки"} - если тест не пройден.

### Примечание: ###

Для работы требуется mochiweb\_util из проекта [Mochiweb](http://code.google.com/p/mochiweb/) и перед использованием нужно запустить inets (inets:start()).