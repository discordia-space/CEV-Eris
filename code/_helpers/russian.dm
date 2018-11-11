//HTML ENCODE/DECODE + RUS TO CP1251 TODO: OVERRIDE html_encode after fix
/proc/rhtml_encode(var/msg)
	msg = replacetext(msg, "<", "&lt;")
	msg = replacetext(msg, ">", "&gt;")
	msg = replacetext(msg, "ÿ", "&#255;")
	return msg

/proc/rhtml_decode(var/msg)
	msg = replacetext(msg, "&gt;", ">")
	msg = replacetext(msg, "&lt;", "<")
	msg = replacetext(msg, "&#255;", "ÿ")
	return msg


//UPPER/LOWER TEXT + RUS TO CP1251 TODO: OVERRIDE uppertext
/proc/ruppertext(text as text)
	text = uppertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 223)
			t += ascii2text(a - 32)
		else if (a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"&#255;","ß")
	return t

/proc/rlowertext(text as text)
	text = lowertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t


//RUS CONVERTERS
// prepare_to_browser for writing .html files direct to browser (html files line-endings must be in unix-style (LF instead of CRLF))
/proc/russian_to_cp1251(var/msg, var/prepare_to_browser = FALSE)//CHATBOX
	if(prepare_to_browser)
		msg = replace_characters(msg, list("\n\n" = "<br>", "\n" = "", "\t" = ""))
	return replacetext(msg, "ÿ", "&#255;")

/proc/russian_to_utf8(var/msg, var/prepare_to_browser = FALSE)//PDA PAPER POPUPS
	if(prepare_to_browser)
		msg = replace_characters(msg, list("\n\n" = "<br>", "\n" = "", "\t" = ""))
	return replacetext(msg, "ÿ", "&#1103;")

/proc/utf8_to_cp1251(msg)
	return replacetext(msg, "&#1103;", "&#255;")

/proc/cp1251_to_utf8(msg)
	return replacetext(msg, "&#255;", "&#1103;")

//Prepare text for edit. Replace "ÿ" with "\ß" for edition. Don't forget to call post_edit().
/proc/edit_cp1251(msg)
	return replacetext(msg, "&#255;", "\\ß")

/proc/edit_utf8(msg)
	return replacetext(msg, "&#1103;", "\\ß")

/proc/post_edit_cp1251(msg)
	return replacetext(msg, "\\ß", "&#255;")

/proc/post_edit_utf8(msg)
	return replacetext(msg, "\\ß", "&#1103;")

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
	"à" = "f", "â" = "d", "ã" = "u", "ä" = "l",
	"å" = "t", "ç" = "p", "è" = "b", "é" = "q",
	"ê" = "r", "ë" = "k", "ì" = "v", "í" = "y",
	"î" = "j", "ï" = "g", "ð" = "h", "ñ" = "c",
	"ò" = "n", "ó" = "e", "ô" = "a", "ö" = "w",
	"÷" = "x", "ø" = "i", "ù" = "o", "û" = "s",
	"ü" = "m", "ÿ" = "z"
)

//Transform keys from russian keyboard layout to eng analogues and lowertext it.
/proc/sanitize_key(t)
	t = rlowertext(t)
	if(t in rkeys) return rkeys[t]
	return (t)

//TEXT MODS RUS
/proc/capitalize_cp1251(var/t as text)
	var/s = 2
	if (copytext(t,1,2) == ";")
		s += 1
	else if (copytext(t,1,2) == ":")
		s += 2
	return ruppertext(copytext(t, 1, s)) + copytext(t, s)

/proc/intonation(text)
	if (copytext(text,-1) == "!")
		text = "<b>[text]</b>"
	return text

var/global/list/cyrillic_unicode_keys = list(
	list("à", "&#x430;"),
	list("á", "&#x431;"),
	list("â", "&#x432;"),
	list("ã", "&#x433;"),
	list("ä", "&#x434;"),
	list("å", "&#x435;"),
	list("¸", "&#x451;"),
	list("æ", "&#x436;"),
	list("ç", "&#x437;"),
	list("è", "&#x438;"),
	list("é", "&#x439;"),
	list("ê", "&#x43A;"),
	list("ë", "&#x43B;"),
	list("ì", "&#x43C;"),
	list("í", "&#x43D;"),
	list("î", "&#x43E;"),
	list("ï", "&#x43F;"),
	list("ð", "&#x440;"),
	list("ñ", "&#x441;"),
	list("ò", "&#x442;"),
	list("ó", "&#x443;"),
	list("ô", "&#x444;"),
	list("õ", "&#x445;"),
	list("ö", "&#x446;"),
	list("÷", "&#x447;"),
	list("ø", "&#x448;"),
	list("ù", "&#x449;"),
	list("ú", "&#x44A;"),
	list("û", "&#x44B;"),
	list("ü", "&#x44C;"),
	list("ý", "&#x44D;"),
	list("þ", "&#x44E;"),
	list("ÿ", "&#x44F;"),
	list("À", "&#x410;"),
	list("Á", "&#x411;"),
	list("Â", "&#x412;"),
	list("Ã", "&#x413;"),
	list("Ä", "&#x414;"),
	list("Å", "&#x415;"),
	list("¨", "&#x401;"),
	list("Æ", "&#x416;"),
	list("Ç", "&#x417;"),
	list("È", "&#x418;"),
	list("É", "&#x419;"),
	list("Ê", "&#x41A;"),
	list("Ë", "&#x41B;"),
	list("Ì", "&#x41C;"),
	list("Í", "&#x41D;"),
	list("Î", "&#x41E;"),
	list("Ï", "&#x41F;"),
	list("Ð", "&#x420;"),
	list("Ñ", "&#x421;"),
	list("Ò", "&#x422;"),
	list("Ó", "&#x423;"),
	list("Ô", "&#x424;"),
	list("Õ", "&#x425;"),
	list("Ö", "&#x426;"),
	list("×", "&#x427;"),
	list("Ø", "&#x428;"),
	list("Ù", "&#x429;"),
	list("Ú", "&#x42A;"),
	list("Û", "&#x42B;"),
	list("Ü", "&#x42C;"),
	list("Ý", "&#x42D;"),
	list("Þ", "&#x42E;"),
	list("ß", "&#x42F;")
	)

/proc/cyrillic_to_unicode(text)
	for(var/key in cyrillic_unicode_keys)
		text = replacetext(text, key[1], key[2])
	return text

/proc/unicode_to_cyrillic(text)
	for(var/key in cyrillic_unicode_keys)
		text = replacetext(text, key[2], key[1])
	return text