//HTML ENCODE/DECODE + RUS TO CP1251 TODO: OVERRIDE html_encode after fix
/proc/rhtml_encode(var/msg)
	msg = replacetext(msg, "<", "&lt;")
	msg = replacetext(msg, ">", "&gt;")
	msg = replacetext(msg, "�", "&#255;")
	return msg

/proc/rhtml_decode(var/msg)
	msg = replacetext(msg, "&gt;", ">")
	msg = replacetext(msg, "&lt;", "<")
	msg = replacetext(msg, "&#255;", "�")
	return msg


//UPPER/LOWER TEXT + RUS TO CP1251 TODO: OVERRIDE uppertext
/proc/ruppertext(text as text)
	text = uppertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if(a > 223)
			t += ascii2text(a - 32)
		else if(a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"&#255;","�")
	return t

/proc/rlowertext(text as text)
	text = lowertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if(a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if(a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t


//RUS CONVERTERS
// prepare_to_browser for writing .html files direct to browser (html files line-endings must be in unix-style (LF instead of CRLF))
/proc/russian_to_cp1251(var/msg, var/prepare_to_browser = FALSE)//CHATBOX
	if(prepare_to_browser)
		msg = replace_characters(msg, list("\n\n" = "<br>", "\n" = "", "\t" = ""))
	return replacetext(msg, "�", "&#255;")

/proc/russian_to_utf8(var/msg, var/prepare_to_browser = FALSE)//PDA PAPER POPUPS
	if(prepare_to_browser)
		msg = replace_characters(msg, list("\n\n" = "<br>", "\n" = "", "\t" = ""))
	return replacetext(msg, "�", "&#1103;")

/proc/utf8_to_cp1251(msg)
	return replacetext(msg, "&#1103;", "&#255;")

/proc/cp1251_to_utf8(msg)
	return replacetext(msg, "&#255;", "&#1103;")

//Prepare text for edit. Replace "�" with "\�" for edition. Don't forget to call post_edit().
/proc/edit_cp1251(msg)
	return replacetext(msg, "&#255;", "\\�")

/proc/edit_utf8(msg)
	return replacetext(msg, "&#1103;", "\\�")

/proc/post_edit_cp1251(msg)
	return replacetext(msg, "\\�", "&#255;")

/proc/post_edit_utf8(msg)
	return replacetext(msg, "\\�", "&#1103;")

//input

/proc/input_cp1251(var/mob/user = usr, var/message, var/title, var/default, var/type = "message", var/prepare_to_browser = FALSE)
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_cp1251(default)) as null|message
		if("text")
			msg = input(user, message, title, default) as null|text
	msg = russian_to_cp1251(msg, prepare_to_browser)
	return post_edit_cp1251(msg)

/proc/input_utf8(var/mob/user = usr, var/message, var/title, var/default, var/type = "message", var/prepare_to_browser = FALSE)
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_utf8(default)) as null|message
		if("text")
			msg = input(user, message, title, default) as null|text
	msg = russian_to_utf8(msg, prepare_to_browser)
	return post_edit_utf8(msg)


var/global/list/rkeys = list(
	"�" = "f", "�" = "d", "�" = "u", "�" = "l",
	"�" = "t", "�" = "p", "�" = "b", "�" = "q",
	"�" = "r", "�" = "k", "�" = "v", "�" = "y",
	"�" = "j", "�" = "g", "�" = "h", "�" = "c",
	"�" = "n", "�" = "e", "�" = "a", "�" = "w",
	"�" = "x", "�" = "i", "�" = "o", "�" = "s",
	"�" = "m", "�" = "z"
)

//Transform keys from russian keyboard layout to eng analogues and lowertext it.
/proc/sanitize_key(t)
	t = rlowertext(t)
	if(t in rkeys) return rkeys[t]
	return (t)

//TEXT MODS RUS
/proc/capitalize_cp1251(var/t as text)
	var/s = 2
	if(copytext(t,1,2) == ";")
		s += 1
	else if(copytext(t,1,2) == ":")
		s += 2
	return ruppertext(copytext(t, 1, s)) + copytext(t, s)

/proc/intonation(text)
	if(copytext(text,-1) == "!")
		text = "<b>[text]</b>"
	return text

var/global/list/cyrillic_unicode_keys = list(
	list("�", "&#x430;"),
	list("�", "&#x431;"),
	list("�", "&#x432;"),
	list("�", "&#x433;"),
	list("�", "&#x434;"),
	list("�", "&#x435;"),
	list("�", "&#x451;"),
	list("�", "&#x436;"),
	list("�", "&#x437;"),
	list("�", "&#x438;"),
	list("�", "&#x439;"),
	list("�", "&#x43A;"),
	list("�", "&#x43B;"),
	list("�", "&#x43C;"),
	list("�", "&#x43D;"),
	list("�", "&#x43E;"),
	list("�", "&#x43F;"),
	list("�", "&#x440;"),
	list("�", "&#x441;"),
	list("�", "&#x442;"),
	list("�", "&#x443;"),
	list("�", "&#x444;"),
	list("�", "&#x445;"),
	list("�", "&#x446;"),
	list("�", "&#x447;"),
	list("�", "&#x448;"),
	list("�", "&#x449;"),
	list("�", "&#x44A;"),
	list("�", "&#x44B;"),
	list("�", "&#x44C;"),
	list("�", "&#x44D;"),
	list("�", "&#x44E;"),
	list("�", "&#x44F;"),
	list("�", "&#x410;"),
	list("�", "&#x411;"),
	list("�", "&#x412;"),
	list("�", "&#x413;"),
	list("�", "&#x414;"),
	list("�", "&#x415;"),
	list("�", "&#x401;"),
	list("�", "&#x416;"),
	list("�", "&#x417;"),
	list("�", "&#x418;"),
	list("�", "&#x419;"),
	list("�", "&#x41A;"),
	list("�", "&#x41B;"),
	list("�", "&#x41C;"),
	list("�", "&#x41D;"),
	list("�", "&#x41E;"),
	list("�", "&#x41F;"),
	list("�", "&#x420;"),
	list("�", "&#x421;"),
	list("�", "&#x422;"),
	list("�", "&#x423;"),
	list("�", "&#x424;"),
	list("�", "&#x425;"),
	list("�", "&#x426;"),
	list("�", "&#x427;"),
	list("�", "&#x428;"),
	list("�", "&#x429;"),
	list("�", "&#x42A;"),
	list("�", "&#x42B;"),
	list("�", "&#x42C;"),
	list("�", "&#x42D;"),
	list("�", "&#x42E;"),
	list("�", "&#x42F;")
	)

/proc/cyrillic_to_unicode(text)
	for(var/key in cyrillic_unicode_keys)
		text = replacetext(text, key[1], key[2])
	return text

/proc/unicode_to_cyrillic(text)
	for(var/key in cyrillic_unicode_keys)
		text = replacetext(text, key[2], key[1])
	return text
