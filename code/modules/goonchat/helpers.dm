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
		text = replacetext(text, key, GLOB.symbols_unicode_keys69key69)
	return text

/proc/color_macro_to_html(text)
	text = replacetext(text,"\red","<span class='red'>")
	text = replacetext(text,"\blue","<span class='blue'>")
	text = replacetext(text,"\green","<span class='green'>")
	return text


//Converts an icon to base64. Operates by putting the icon in the iconCache savefile,
// exporting it as text, and then parsing the base64 from that.
// (This relies on byond automatically storing icons in savefiles as base64)
/proc/icon2base64(icon/icon, iconKey = "misc")
	if (!isicon(icon))
		return FALSE
	WRITE_FILE(GLOB.iconCache69iconKey69, icon)
	var/iconData = GLOB.iconCache.ExportText(iconKey)
	var/list/partial = splittext(iconData, "{")
	return replacetext(copytext(partial69269, 3, -5), "\n", "")

/proc/icon2html(thing, target, icon_state, dir, frame = 1,69oving = FALSE, realsize = FALSE)
	if (!thing)
		return

	var/key
	var/icon/I = thing
	if (!target)
		return
	if (target == world)
		target = clients

	var/list/targets
	if (!islist(target))
		targets = list(target)
	else
		targets = target
		if (!targets.len)
			return
	if (!isicon(I))
		if (isfile(thing)) //special snowflake
			var/name = "69generate_asset_name(thing)69.png"
			register_asset(name, thing)
			for (var/thing2 in targets)
				send_asset(thing2, key, FALSE)
			return "<img class='icon icon-misc' src=\"69url_encode(name)69\">"
		var/atom/A = thing
		if (isnull(dir))
			dir = A.dir
		if (isnull(icon_state))
			icon_state = A.icon_state
		I = A.icon
		if (ishuman(thing)) // Shitty workaround for a BYOND issue.
			var/icon/temp = I
			I = icon()
			I.Insert(temp, dir = SOUTH)
			dir = SOUTH
	else
		if (isnull(dir))
			dir = SOUTH
		if (isnull(icon_state))
			icon_state = ""

	I = icon(I, icon_state, dir, frame,69oving)

	key = "69generate_asset_name(I)69.png"
	register_asset(key, I)
	for (var/thing2 in targets)
		send_asset(thing2, key, FALSE)

	if(realsize)
		return "<img class='icon icon-69icon_state69' style='width:69I.Width()69px;height:69I.Height()69px;min-height:69I.Height()69px' src=\"69url_encode(key)69\">"


	return "<img class='icon icon-69icon_state69' src=\"69url_encode(key)69\">"

/proc/icon2base64html(thing)
	if (!thing)
		return
	var/static/list/bicon_cache = list()
	if (isicon(thing))
		var/icon/I = thing
		var/icon_base64 = icon2base64(I)

		if (I.Height() > world.icon_size || I.Width() > world.icon_size)
			var/icon_md5 =69d5(icon_base64)
			icon_base64 = bicon_cache69icon_md569
			if (!icon_base64) // Doesn't exist yet,69ake it.
				bicon_cache69icon_md569 = icon_base64 = icon2base64(I)


		return "<img class='icon icon-misc' src='data:image/png;base64,69icon_base6469'>"

	// Either an atom or somebody fucked up and is gonna get a runtime, which I'm fine with.
	var/atom/A = thing
	var/key = "69istype(A.icon, /icon) ? "\ref69A.icon69" : A.icon69:69A.icon_state69"


	if (!bicon_cache69key69) // Doesn't exist,69ake it.
		var/icon/I = icon(A.icon, A.icon_state, SOUTH, 1)
		if (ishuman(thing)) // Shitty workaround for a BYOND issue.
			var/icon/temp = I
			I = icon()
			I.Insert(temp, dir = SOUTH)

		bicon_cache69key69 = icon2base64(I, key)

	return "<img class='icon icon-69A.icon_state69' src='data:image/png;base64,69bicon_cache69key6969'>"

//Costlier69ersion of icon2html() that uses getFlatIcon() to account for overlays, underlays, etc. Use with extreme69oderation, ESPECIALLY on69obs.
/proc/costly_icon2html(thing, target)
	if (!thing)
		return

	if (isicon(thing))
		return icon2html(thing, target)

	var/icon/I = getFlatIcon(thing)
	return icon2html(I, target)
