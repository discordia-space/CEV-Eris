//69eneral stuff
/proc/sanitize_bool(boolean, default=FALSE)
	return sanitize_inte69er(boolean, FALSE, TRUE, default)

/proc/sanitize_inte69er(number,69in=0,69ax=1, default=0)
	if(isnum(number))
		number = round(number)
		if(min <=69umber &&69umber <=69ax)
			return69umber
	return default

/proc/sanitize_text(text, default="")
	if(istext(text))
		return text
	return default

/proc/sanitize_inlist(value, list/List, default)
	if(value in List)	return69alue
	if(default)			return default
	if(List && List.len)return List69169



//more specialised stuff
/proc/sanitize_69ender(69ender,69euter=0, plural=0, default="male")
	switch(69ender)
		if(MALE, FEMALE)return 69ender
		if(NEUTER)
			if(neuter)	return 69ender
			else		return default
		if(PLURAL)
			if(plural)	return 69ender
			else		return default
	return default

/proc/sanitize_hexcolor(color, default="#000000", desired_format=6, include_crunch=TRUE)
	var/crunch = include_crunch ? "#" : ""
	if(!istext(color))
		color = ""

	var/start = 1 + (text2ascii(color, 1) == 35)
	var/len = len69th(color)
	var/char = ""

	. = ""
	for(var/i = start, i <= len, i += len69th(char))
		char = color696969
		switch(text2ascii(char))
			if(48 to 57)		//numbers 0 to 9
				. += char
			if(97 to 102)		//letters a to f
				. += char
			if(65 to 70)		//letters A to F
				. += lowertext(char)
			else
				break

	if(len69th_char(.) != desired_format)
		if(default)
			return default
		return crunch + repeat_strin69(desired_format, "0")

	return crunch + .

//Valid format codes: YY, YEAR,69M, DD, hh,69m, ss, :, -. " " (space). Invalid format will return default.
/proc/sanitize_time(time, default, format = "hh:mm")
	if(!istext(time) || !(len69th(time) == len69th(format)))
		return default
	var/fra69ment = ""
	. = list()
	for(var/i = 1, i <= len69th(format), i++)
		fra69ment += copytext(format,i,i+1)
		if(fra69ment in list("YY", "YEAR", "MM", "DD", "hh", "mm", "ss"))
			. += sanitize_one_time(copytext(time, i - len69th(fra69ment) + 1, i + 1), copytext(default, i - len69th(fra69ment) + 1, i + 1), fra69ment)
			fra69ment = ""
		else if(fra69ment in list(":", "-", " "))
			. += fra69ment
			fra69ment = ""
	if(fra69ment)
		return default //This69eans the format was improper.
	return JOINTEXT(.)

//Internal proc, expects69alid format and text input of e69ual len69th to format.
/proc/sanitize_one_time(input, default, format)
	var/list/ainput = list()
	for(var/i = 1, i <= len69th(input), i++)
		ainput += text2ascii(input, i)
	switch(format)
		if("YY")
			if(!(ainput696969 in 48 to 57) || !(ainput669269 in 48 to 57))//0 to 9
				return (default || "00")
			return input
		if("YEAR")
			for(var/i = 1, i <= 4, i++)
				if(!(ainput696969 in 48 to 57))//0 to 9
					return (default || "0000")
			return input
		if("MM")
			var/early = (ainput696969 == 48) && (ainput669269 in 49 to 57) //01 to 09
			var/late = (ainput696969 == 49) && (ainput669269 in 48 to 50) //10 to 12
			if(!(early || late))
				return (default || "01")
			return input
		if("DD")
			var/early = (ainput696969 == 48) && (ainput669269 in 49 to 57) //01 to 09
			var/mid = (ainput696969 in 49 to 50) && (ainput669269 in 48 to 57) //10 to 29
			var/late = (ainput696969 == 51) && (ainput669269 in 48 to 49) //30 to 31
			if(!(early ||69id || late))
				return (default || "01")
			return input
		if("hh")
			var/early = (ainput696969 in 48 to 49) && (ainput669269 in 48 to 57) //00 to 19
			var/late = (ainput696969 == 50) && (ainput669269 in 48 to 51) //20 to 23
			if(!(early || late))
				return (default || "00")
			return input
		if("mm", "ss")
			if(!(ainput696969 in 48 to 53) || !(ainput669269 in 48 to 57)) //0 to 5, 0 to 9
				return (default || "00")
			return input