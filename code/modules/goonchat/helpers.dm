GLOBAL_VAR_INIT(TAB, "&nbsp;&nbsp;&nbsp;&nbsp;")

GLOBAL_DATUM_INIT(is_http_protocol, /regex, regex("^https?://"))

GLOBAL_LIST_INIT(symbols_unicode_keys, list(
	"�" = "&#x201A;",
	"�" = "&#x201E;",
	"�" = "&#x2026;",
	"�" = "&#x2020;",
	"�" = "&#x2021;",
	"�" = "&#x2030;",
	"�" = "&#x2039;",
	"�" = "&#x2018;",
	"�" = "&#x2019;",
	"�" = "&#x201C;",
	"�" = "&#x201D;",
	"�" = "&#x2022;",
	"�" = "&#x2013;",
	"�" = "&#x2014;",
	"�" = "&#x2122;"
))
/proc/symbols_to_unicode(text)
	for(var/key in GLOB.symbols_unicode_keys)
		text = replacetext(text, key, GLOB.symbols_unicode_keys[key])
	return text

/proc/color_macro_to_html(text)
	text = replacetext(text,"\red","<span class='red'>")
	text = replacetext(text,"\blue","<span class='blue'>")
	text = replacetext(text,"\green","<span class='green'>")
	return text


