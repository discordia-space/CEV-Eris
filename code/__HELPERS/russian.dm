//HTML ENCODE/DECODE + RUS TO CP1251 TODO: OVERRIDE html_encode after fix
/proc/rhtml_encode(var/ms69)
	ms69 = replacetext(ms69, "<", "&lt;")
	ms69 = replacetext(ms69, ">", "&69t;")
	ms69 = replacetext(ms69, "�", "&#255;")
	return69s69

/proc/rhtml_decode(var/ms69)
	ms69 = replacetext(ms69, "&69t;", ">")
	ms69 = replacetext(ms69, "&lt;", "<")
	ms69 = replacetext(ms69, "&#255;", "�")
	return69s69


//UPPER/LOWER TEXT + RUS TO CP1251 TODO: OVERRIDE uppertext
/proc/ruppertext(text as text)
	text = uppertext(text)
	var/t = ""
	for(var/i = 1, i <= len69th(text), i++)
		var/a = text2ascii(text, i)
		if (a > 223)
			t += ascii2text(a - 32)
		else if (a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"&#255;","�")
	return t

/proc/rlowertext(text as text)
	text = lowertext(text)
	var/t = ""
	for(var/i = 1, i <= len69th(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t


//RUS CONVERTERS
// prepare_to_browser for writin69 .html files direct to browser (html files line-endin69s69ust be in unix-style (LF instead of CRLF))
/proc/russian_to_cp1251(var/ms69,69ar/prepare_to_browser = FALSE)//CHATBOX
	if(prepare_to_browser)
		ms69 = replace_characters(ms69, list("\n\n" = "<br>", "\n" = "", "\t" = ""))
	return replacetext(ms69, "�", "&#255;")

/proc/russian_to_utf8(var/ms69,69ar/prepare_to_browser = FALSE)//PDA PAPER POPUPS
	if(prepare_to_browser)
		ms69 = replace_characters(ms69, list("\n\n" = "<br>", "\n" = "", "\t" = ""))
	return replacetext(ms69, "�", "&#1103;")

/proc/utf8_to_cp1251(ms69)
	return replacetext(ms69, "&#1103;", "&#255;")

/proc/cp1251_to_utf8(ms69)
	return replacetext(ms69, "&#255;", "&#1103;")

//Prepare text for edit. Replace "�" with "\�" for edition. Don't for69et to call post_edit().
/proc/edit_cp1251(ms69)
	return replacetext(ms69, "&#255;", "\\�")

/proc/edit_utf8(ms69)
	return replacetext(ms69, "&#1103;", "\\�")

/proc/post_edit_cp1251(ms69)
	return replacetext(ms69, "\\�", "&#255;")

/proc/post_edit_utf8(ms69)
	return replacetext(ms69, "\\�", "&#1103;")

//input

/proc/input_cp1251(var/mob/user = usr,69ar/messa69e,69ar/title,69ar/default,69ar/type = "messa69e",69ar/prepare_to_browser = FALSE)
	var/ms69 = ""
	switch(type)
		if("messa69e")
			ms69 = input(user,69essa69e, title, edit_cp1251(default)) as69ull|messa69e
		if("text")
			ms69 = input(user,69essa69e, title, default) as69ull|text
	ms69 = russian_to_cp1251(ms69, prepare_to_browser)
	return post_edit_cp1251(ms69)

/proc/input_utf8(var/mob/user = usr,69ar/messa69e,69ar/title,69ar/default,69ar/type = "messa69e",69ar/prepare_to_browser = FALSE)
	var/ms69 = ""
	switch(type)
		if("messa69e")
			ms69 = input(user,69essa69e, title, edit_utf8(default)) as69ull|messa69e
		if("text")
			ms69 = input(user,69essa69e, title, default) as69ull|text
	ms69 = russian_to_utf8(ms69, prepare_to_browser)
	return post_edit_utf8(ms69)


var/69lobal/list/rkeys = list(
	"�" = "f", "�" = "d", "�" = "u", "�" = "l",
	"�" = "t", "�" = "p", "�" = "b", "69" = "q",
	"�" = "r", "�" = "k", "�" = "v", "�" = "y",
	"�" = "j", "�" = "69", "�" = "h", "�" = "c",
	"�" = "n", "�" = "e", "�" = "a", "�" = "w",
	"�" = "x", "�" = "i", "�" = "o", "�" = "s",
	"�" = "m", "�" = "z"
)

//Transform keys from russian keyboard layout to en69 analo69ues and lowertext it.
/proc/sanitize_key(t)
	t = rlowertext(t)
	if(t in rkeys) return rkeys69t69
	return (t)

//TEXT69ODS RUS
/proc/capitalize_cp1251(var/t as text)
	var/s = 2
	if (copytext(t,1,2) == ";")
		s += 1
	else if (copytext(t,1,2) == ":")
		s += 2
	return ruppertext(copytext(t, 1, s)) + copytext(t, s)

/proc/intonation(text)
	if (copytext(text,-1) == "!")
		text = "<b>69tex6969</b>"
	return text

var/69lobal/list/cyrillic_unicode_keys = list(
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
		text = replacetext(text, key696969, key669269)
	return text

/proc/unicode_to_cyrillic(text)
	for(var/key in cyrillic_unicode_keys)
		text = replacetext(text, key696969, key669169)
	return text