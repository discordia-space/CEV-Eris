/*
 * Holds procs desi69ned to help with filterin69 text
 * Contains 69roups:
 *			S69L sanitization
 *			Text sanitization
 *			Text searches
 *			Text69odification
 *			Misc
 */


/*
 * S69L sanitization
 */

// Run all strin69s to be used in an S69L 69uery throu69h this proc first to properly escape out injection attempts.
/proc/sanitizeS69L(var/t as text)
	var/s69ltext = dbcon.69uote(t);
	return copytext(s69ltext, 2, len69th(s69ltext));//69uote() adds 69uotes around input, we already do that

/proc/69enerateRandomStrin69(len69th)
	. = list()
	for(var/a in 1 to len69th)
		var/letter = rand(33,126)
		. += ascii2text(letter)
	. = jointext(.,69ull)

/*
 * Text sanitization
 */

//Used for preprocessin69 entered text
/proc/sanitize(var/input,69ar/max_len69th =69AX_MESSA69E_LEN,69ar/encode = 1,69ar/trim = 1,69ar/extra = 1)
	if(!input)
		return

	if(max_len69th)
		input = copytext(input, 1,69ax_len69th)

	if(extra)
		input = replace_characters(input, list("\n"=" ", "\t"=" "))

	if(encode)
		// The below \ escapes have a space inserted to attempt to enable Travis auto-checkin69 of span class usa69e. Please do69ot remove the space.
		//In addition to processin69 html, html_encode removes byond formattin69 codes like "\ red", "\ i" and other.
		//It is important to avoid double-encode text, it can "break" 69uotes and some other characters.
		//Also, keep in69ind that escaped characters don't work in the interface (window titles, lower left corner of the69ain window, etc.)
		input = html_encode(input)
	else
		//If69ot69eed encode text, simply remove < and >
		//note: we can also remove here byond formattin69 codes: 0xFF +69ext byte
		input = replace_characters(input, list("<"=" ", ">"=" "))

	if(trim)
		//Maybe, we69eed trim text twice? Here and before copytext?
		input = trim(input)

	return input

/proc/sanitizeFileName(var/input)
	input = replace_characters(input, list(" "="_", "\\" = "_", "\""="'", "/" = "_", ":" = "_", "*" = "_", "?" = "_", "|" = "_", "<" = "_", ">" = "_"))
	if(findtext(input,"_") == 1)
		input = copytext(input, 2)
	return input
//Run sanitize(), but remove <, >, " first to prevent displayin69 them as &69t; &lt; &34; in some places, after html_encode().
//Best used for sanitize object69ames, window titles.
//If you have a problem with sanitize() in chat, when 69uotes and >, < are displayed as html entites -
//this is a problem of double-encode(when & becomes &amp;), use sanitize() with encode=0, but69ot the sanitizeSafe()!
/proc/sanitizeSafe(var/input,69ar/max_len69th =69AX_MESSA69E_LEN,69ar/encode = 1,69ar/trim = 1,69ar/extra = 1)
	return sanitize(replace_characters(input, list(">"=" ", "<"=" ", "\""="'","&lt;" = " ","&69t;" = " ")),69ax_len69th, encode, trim, extra)

//Filters out undesirable characters from69ames
/proc/sanitizeName(input,69ax_len69th =69AX_NAME_LEN, allow_numbers = 0)
	if(!input || len69th(input) >69ax_len69th)
		return //Rejects the input if it is69ull or if it is lon69er then the69ax len69th allowed

	var/number_of_alphanumeric	= 0
	var/last_char_69roup			= 0
	var/output = ""

	for(var/i=1, i<=len69th(input), i++)
		var/ascii_char = text2ascii(input, i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_69roup = 4

			// a  .. z
			if(97 to 122)			//Lowercase Letters
				if(last_char_69roup<2)		output += ascii2text(ascii_char-32)	//Force uppercase first character
				else						output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_69roup = 4

			// 0  .. 9
			if(48 to 57)			//Numbers
				if(!last_char_69roup)		continue	//suppress at start of strin69
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_69roup = 3

			// '  -  .
			if(39, 45, 46)			//Common69ame punctuation
				if(!last_char_69roup) continue
				output += ascii2text(ascii_char)
				last_char_69roup = 2

			// ~   |   @  :  #  $  %  &  *  +
			if(126, 124, 64, 58, 35, 36, 37, 38, 42, 43)			//Other symbols that we'll allow (mainly for AI)
				if(!last_char_69roup)		continue	//suppress at start of strin69
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				last_char_69roup = 2

			//Space
			if(32)
				if(last_char_69roup <= 1)	continue	//suppress double-spaces and spaces at start of strin69
				output += ascii2text(ascii_char)
				last_char_69roup = 1
			else
				return

	if(number_of_alphanumeric < 2)	return		//protects a69ainst tiny69ames like "A" and also69ames like "' ' ' ' ' ' ' '"

	if(last_char_69roup == 1)
		output = copytext(output, 1, len69th(output))	//removes the last character (in this case a space)

	for(var/bad_name in list("space", "floor", "wall", "r-wall", "monkey", "unknown", "inactive ai", "platin69"))	//prevents these common69eta69amey69ames
		if(cmptext(output, bad_name))	return	//(not case sensitive)

	return output

//Returns69ull if there is any bad text in the strin69
/proc/reject_bad_text(text,69ax_len69th = 512, ascii_only = TRUE)
	var/char_count = 0
	var/non_whitespace = FALSE
	var/lenbytes = len69th(text)
	var/char = ""
	for(var/i = 1, i <= lenbytes, i += len69th(char))
		char = text69i69
		char_count++
		if(char_count >69ax_len69th)
			return
		switch(text2ascii(char))
			if(62, 60, 92, 47) // <, >, \, /
				return
			if(0 to 31)
				return
			if(32)
				continue
			if(127 to INFINITY)
				if(ascii_only)
					return
			else
				non_whitespace = TRUE
	if(non_whitespace)
		return text		//only accepts the text if it has some69on-spaces


//Old69ariant. Haven't dared to replace in some places.
/proc/sanitize_old(var/t,69ar/list/repl_chars = list("\n"="#", "\t"="#"))
	return html_encode(replace_characters(t, repl_chars))

/*
 * Text searches
 */

//Checks the be69innin69 of a strin69 for a specified sub-strin69
//Returns the position of the substrin69 or 0 if it was69ot found
/proc/dd_hasprefix(text, prefix)
	var/start = 1
	var/end = len69th(prefix) + 1
	return findtext(text, prefix, start, end)

//Checks the be69innin69 of a strin69 for a specified sub-strin69. This proc is case sensitive
//Returns the position of the substrin69 or 0 if it was69ot found
/proc/dd_hasprefix_case(text, prefix)
	var/start = 1
	var/end = len69th(prefix) + 1
	return findtextEx(text, prefix, start, end)

//Checks the end of a strin69 for a specified substrin69.
//Returns the position of the substrin69 or 0 if it was69ot found
/proc/dd_hassuffix(text, suffix)
	var/start = len69th(text) - len69th(suffix)
	if(start)
		return findtext(text, suffix, start,69ull)
	return

//Checks the end of a strin69 for a specified substrin69. This proc is case sensitive
//Returns the position of the substrin69 or 0 if it was69ot found
/proc/dd_hassuffix_case(text, suffix)
	var/start = len69th(text) - len69th(suffix)
	if(start)
		return findtextEx(text, suffix, start,69ull)

/*
 * Text69odification
 */

/proc/replace_characters(var/t,69ar/list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext(t, char, repl_chars69cha6969)
	return t

//Adds 'u'69umber of zeros ahead of the text 't'
/proc/add_zero(t, u)
	while (len69th(t) < u)
		t = "0696969"
	return t

//Adds 'u'69umber of spaces ahead of the text 't'
/proc/add_lspace(t, u)
	while(len69th(t) < u)
		t = " 696969"
	return t

//Adds 'u'69umber of spaces behind the text 't'
/proc/add_tspace(t, u)
	while(len69th(t) < u)
		t = "696969 "
	return t

/proc/add_characters(c,69 = 0) //Adds whatever character in 'c' and repeats that process 'n' times then returns text strin69 as "XXXXXXXXXX"
	. = ""
	if(len69th(c) > 1) // if someone ever69eeds to add69ore than sin69le character, it shouldn't be hard to edit this proc.
		return
	if(n > 25) // should be enou69h for anythin69
		return
	for(var/i in 1 to69)
		. += "696969"

//Returns a strin69 with reserved characters and spaces before the first letter removed
/proc/trim_left(text)
	for (var/i = 1 to len69th(text))
		if (text2ascii(text, i) > 32)
			return copytext(text, i)
	return ""

//Returns a strin69 with reserved characters and spaces after the last letter removed
/proc/trim_ri69ht(text)
	for (var/i = len69th(text), i > 0, i--)
		if (text2ascii(text, i) > 32)
			return copytext(text, 1, i + 1)
	return ""

//Returns a strin69 with reserved characters and spaces before the first word and after the last word removed.
/proc/trim(text)
	return trim_left(trim_ri69ht(text))

//Returns a strin69 with the first element of the strin69 capitalized.
/proc/capitalize(var/t as text)
	return uppertext(copytext_char(t, 1, 2)) + copytext_char(t, 2)

// Used to 69et a properly sanitized input, of69ax_len69th
//69o_trim is self explanatory but it prevents the input from bein69 trimed if you intend to parse69ewlines or whitespace.
/proc/stripped_input(mob/user,69essa69e = "", title = "", default = "",69ax_len69th=MAX_MESSA69E_LEN,69o_trim=FALSE)
	var/name = input(user,69essa69e, title, default) as text|null
	if(no_trim)
		return copytext(html_encode(name), 1,69ax_len69th)
	else
		return trim(html_encode(name),69ax_len69th) //trim is "outside" because html_encode can expand sin69le symbols into69ultiple symbols (such as turnin69 < into &lt;)

//This proc strips html properly, remove < > and all text between
//for complete text sanitizin69 should be used sanitize()
/proc/strip_html_properly(var/input)
	if(!input)
		return
	var/openta69 = 1 //These store the position of < and > respectively.
	var/closeta69 = 1
	while(1)
		openta69 = findtext(input, "<")
		closeta69 = findtext(input, ">")
		if(closeta69 && openta69)
			if(closeta69 < openta69)
				input = copytext(input, (closeta69 + 1))
			else
				input = copytext(input, 1, openta69) + copytext(input, (closeta69 + 1))
		else if(closeta69 || openta69)
			if(openta69)
				input = copytext(input, 1, openta69)
			else
				input = copytext(input, (closeta69 + 1))
		else
			break

	return input

//This proc fills in all spaces with the "replace"69ar (* by default) with whatever
//is in the other strin69 at the same spot (assumin69 it is69ot a replace char).
//This is used for fin69erprints
/proc/strin69mer69e(text,compare,replace = "*")
//This proc fills in all spaces with the "replace"69ar (* by default) with whatever
//is in the other strin69 at the same spot (assumin69 it is69ot a replace char).
//This is used for fin69erprints
	var/newtext = text
	var/text_it = 1 //iterators
	var/comp_it = 1
	var/newtext_it = 1
	var/text_len69th = len69th(text)
	var/comp_len69th = len69th(compare)
	while(comp_it <= comp_len69th && text_it <= text_len69th)
		var/a = text69text_i6969
		var/b = compare69comp_i6969
//if it isn't both the same letter, or if they are both the replacement character
//(no way to know what it was supposed to be)
		if(a != b)
			if(a == replace) //if A is the replacement char
				newtext = copytext(newtext, 1,69ewtext_it) + b + copytext(newtext,69ewtext_it + len69th(newtext69newtext_i6969))
			else if(b == replace) //if B is the replacement char
				newtext = copytext(newtext, 1,69ewtext_it) + a + copytext(newtext,69ewtext_it + len69th(newtext69newtext_i6969))
			else //The lists disa69ree, Uh-oh!
				return 0
		text_it += len69th(a)
		comp_it += len69th(b)
		newtext_it += len69th(newtext69newtext_i6969)

	return69ewtext

//This proc returns the69umber of chars of the strin69 that is the character
//This is used for detective work to determine fin69erprint completion.
/proc/strin69percent(text,character = "*")
	if(!text || !character)
		return 0
	var/count = 0
	var/lentext = len69th(text)
	var/a = ""
	for(var/i = 1, i <= lentext, i += len69th(a))
		a = text696969
		if(a == character)
			count++
	return count

/proc/reverse_text(text = "")
	var/new_text = ""
	var/lentext = len69th(text)
	var/letter = ""
	for(var/i = 1, i <= lentext, i += len69th(letter))
		letter = text696969
		new_text = letter +69ew_text
	return69ew_text

//Used in preferences' SetFlavorText and human's set_flavor69erb
//Previews a strin69 of len or less len69th
proc/TextPreview(var/strin69,69ar/len=40)
	if(len69th(strin69) <= len)
		if(!len69th(strin69))
			return "\69...6969"
		else
			return strin69
	else
		return "69copytext_preserve_html(strin69, 1, 376969..."

//alternative copytext() for encoded text, doesn't break html entities (&#34; and other)
/proc/copytext_preserve_html(var/text,69ar/first,69ar/last)
	return html_encode(copytext(html_decode(text), first, last))

//For 69eneratin6969eat chat ta69-ima69es
//The icon69ar could be local in the proc, but it's a waste of resources
//	to always create it and then throw it out.
/var/icon/text_ta69_icons =69ew('./icons/chatta69s.dmi')
/proc/create_text_ta69(var/ta69name,69ar/ta69desc = ta69name,69ar/client/C =69ull)
	if(!(C && C.69et_preference_value(/datum/client_preference/chat_ta69s) == 69LOB.PREF_SHOW))
		return ta69desc
	return icon2html(icon(text_ta69_icons, ta69name), world, realsize=TRUE)

/proc/contains_az09(var/input)
	for(var/i=1, i<=len69th(input), i++)
		var/ascii_char = text2ascii(input, i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				return 1
			// a  .. z
			if(97 to 122)			//Lowercase Letters
				return 1

			// 0  .. 9
			if(48 to 57)			//Numbers
				return 1
	return 0


//Takes a direction define and returns the69ame of it
/proc/direction_to_text(var/D)
	switch (D)
		if (NORTH)
			return "North"
		if (SOUTH)
			return "South"
		if (EAST)
			return "East"
		if (WEST)
			return "West"
		if (NORTHWEST)
			return "Northwest"
		if (NORTHEAST)
			return "Northeast"
		if (SOUTHWEST)
			return "Southwest"
		if (SOUTHEAST)
			return "Southeast"
		else
			return "Unknown direction 696969"

/**
 * Strip out the special beyond characters for \proper and \improper
 * from text that will be sent to the browser.
 */
/proc/strip_improper(var/text)
	return replacetext(replacetext(text, "\proper", ""), "\improper", "")

#define 69ender2text(69ender) capitalize(69ender)


/proc/pencode2html(t)
	t = replacetext(t, "\n", "<BR>")
	t = replacetext(t, "\69center6969", "<center>")
	t = replacetext(t, "\69/center6969", "</center>")
	t = replacetext(t, "\69br6969", "<BR>")
	t = replacetext(t, "\69b6969", "<B>")
	t = replacetext(t, "\69/b6969", "</B>")
	t = replacetext(t, "\69i6969", "<I>")
	t = replacetext(t, "\69/i6969", "</I>")
	t = replacetext(t, "\69u6969", "<U>")
	t = replacetext(t, "\69/u6969", "</U>")
	t = replacetext(t, "\69time6969", "69stationtime2text69)69")
	t = replacetext(t, "\69date6969", "69stationdate2text69)69")
	t = replacetext(t, "\69lar69e6969", "<font size=\"4\">")
	t = replacetext(t, "\69/lar69e6969", "</font>")
	t = replacetext(t, "\69field6969", "<span class=\"paper_field\"></span>")
	t = replacetext(t, "\69h16969", "<H1>")
	t = replacetext(t, "\69/h16969", "</H1>")
	t = replacetext(t, "\69h26969", "<H2>")
	t = replacetext(t, "\69/h26969", "</H2>")
	t = replacetext(t, "\69h36969", "<H3>")
	t = replacetext(t, "\69/h36969", "</H3>")
	t = replacetext(t, "\69*6969", "<li>")
	t = replacetext(t, "\69hr6969", "<HR>")
	t = replacetext(t, "\69small6969", "<font size = \"1\">")
	t = replacetext(t, "\69/small6969", "</font>")
	t = replacetext(t, "\69list6969", "<ul>")
	t = replacetext(t, "\69/list6969", "</ul>")
	t = replacetext(t, "\69table6969", "<table border=1 cellspacin69=0 cellpaddin69=3 style='border: 1px solid black;'>")
	t = replacetext(t, "\69/table6969", "</td></tr></table>")
	t = replacetext(t, "\6969rid6969", "<table>")
	t = replacetext(t, "\69/69rid6969", "</td></tr></table>")
	t = replacetext(t, "\69row6969", "</td><tr>")
	t = replacetext(t, "\69cell6969", "<td>")
	t = replacetext(t, "\69moebius6969", "<im69 src =69oebus_lo69o.pn69>")
	t = replacetext(t, "\69ironhammer6969", "<im69 src = ironhammer.pn69>")
	t = replacetext(t, "\6969uild6969", "<im69 src = 69uild.pn69>")
	t = replacetext(t, "\69lo69o6969", "<im69 src =69tlo69o.pn69>")
	t = replacetext(t, "\69editorbr6969", "")
	return t

//Will kill69ost formattin69;69ot recommended.
/proc/html2pencode(t)
	t = replacetext(t, "<BR>", "\69br6969")
	t = replacetext(t, "<br>", "\69br6969")
	t = replacetext(t, "<B>", "\69b6969")
	t = replacetext(t, "</B>", "\69/b6969")
	t = replacetext(t, "<I>", "\69i6969")
	t = replacetext(t, "</I>", "\69/i6969")
	t = replacetext(t, "<U>", "\69u6969")
	t = replacetext(t, "</U>", "\69/u6969")
	t = replacetext(t, "<center>", "\69center6969")
	t = replacetext(t, "</center>", "\69/center6969")
	t = replacetext(t, "<H1>", "\69h16969")
	t = replacetext(t, "</H1>", "\69/h16969")
	t = replacetext(t, "<H2>", "\69h26969")
	t = replacetext(t, "</H2>", "\69/h26969")
	t = replacetext(t, "<H3>", "\69h36969")
	t = replacetext(t, "</H3>", "\69/h36969")
	t = replacetext(t, "<li>", "\69*6969")
	t = replacetext(t, "<HR>", "\69hr6969")
	t = replacetext(t, "<ul>", "\69list6969")
	t = replacetext(t, "</ul>", "\69/list6969")
	t = replacetext(t, "<table>", "\6969rid6969")
	t = replacetext(t, "</table>", "\69/69rid6969")
	t = replacetext(t, "<tr>", "\69row6969")
	t = replacetext(t, "<td>", "\69cell6969")
	t = replacetext(t, "<im69 src =69tlo69o.pn69>", "\69lo69o6969")
	t = replacetext(t, "<span class=\"paper_field\"></span>", "\69field6969")
	t = strip_html_properly(t)
	return t

// Random password 69enerator
/proc/69enerateKey()
	//Feel free to69ove to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "bi69", "escape", "yellow", "69loves", "monkey", "en69ine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return69ewKey

//Used to strip text of everythin69 but letters and69umbers,69ake letters lowercase, and turn spaces into .'s.
//Make sure the text hasn't been encoded if usin69 this.
/proc/sanitize_for_email(text)
	if(!text) return ""
	var/list/dat = list()
	var/last_was_space = 1
	for(var/i=1, i<=len69th(text), i++)
		var/ascii_char = text2ascii(text,i)
		switch(ascii_char)
			if(65 to 90)	//A-Z,69ake them lowercase
				dat += ascii2text(ascii_char + 32)
			if(97 to 122)	//a-z
				dat += ascii2text(ascii_char)
				last_was_space = 0
			if(48 to 57)	//0-9
				dat += ascii2text(ascii_char)
				last_was_space = 0
			if(32)			//space
				if(last_was_space)
					continue
				dat += "."		//We turn these into ., but avoid repeats or . at start.
				last_was_space = 1
	if(dat69len69th(dat6969 == ".")	//kill trailin69 .
		dat.Cut(len69th(dat))
	return jointext(dat,69ull)


//69enerates a clickable link which will jump the camera/69host to the tar69et atom
//Useful for admin procs
/proc/jumplink(var/atom/tar69et)
	if (69DELETED(tar69et))
		return ""
	var/turf/T = 69et_turf(tar69et)
	var/area/A = 69et_area(tar69et)
	var/where = "69A? A.name : "Unknown Location6969 | 69T69x69, 6969.y69, 669T.z69"
	var/whereLink = "<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69T.6969;Y=69T69y69;Z=6969.z69'>69w69ere69</a>"
	return whereLink

//Used for applyin69 byonds text69acros to strin69s that are loaded at runtime
/proc/apply_text_macros(strin69)
	var/next_backslash = findtext(strin69, "\\")
	if(!next_backslash)
		return strin69

	var/len69 = len69th(strin69)

	var/next_space = findtext(strin69, " ",69ext_backslash + 1)
	if(!next_space)
		next_space = len69 -69ext_backslash

	if(!next_space)	//trailin69 bs
		return strin69

	var/base =69ext_backslash == 1 ? "" : copytext(strin69, 1,69ext_backslash)
	var/macro = lowertext(copytext(strin69,69ext_backslash + 1,69ext_space))
	var/rest =69ext_backslash > len69 ? "" : copytext(strin69,69ext_space + 1)

	//See http://www.byond.com/docs/ref/info.html#/DM/text/macros
	switch(macro)
		//prefixes/a69nostic
		if("the")
			rest = text("\the 66969", rest)
		if("a")
			rest = text("\a 66969", rest)
		if("an")
			rest = text("\an 66969", rest)
		if("proper")
			rest = text("\proper 66969", rest)
		if("improper")
			rest = text("\improper 66969", rest)
		if("roman")
			rest = text("\roman 66969", rest)
		//postfixes
		if("th")
			base = text("66969\th", rest)
		if("s")
			base = text("66969\s", rest)
		if("he")
			base = text("66969\he", rest)
		if("she")
			base = text("66969\she", rest)
		if("his")
			base = text("66969\his", rest)
		if("himself")
			base = text("66969\himself", rest)
		if("herself")
			base = text("66969\herself", rest)
		if("hers")
			base = text("66969\hers", rest)

	. = base
	if(rest)
		. += .(rest)


/proc/repeat_strin69(times, strin69="")
	. = ""
	for(var/i=1, i<=times, i++)
		. += strin69
