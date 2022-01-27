/*
 * Holds procs desi69ned to chan69e one type of69alue, into another.
 * Contains:
 *			hex2num &69um2hex
 *			text2list & list2text
 *			file2list
 *			an69le2dir
 *			an69le2text
 *			worldtime2stationtime
 *			key2mob
 */

// Returns an inte69er 69iven a hexadecimal69umber strin69 as input.
/proc/hex2num(hex)
	if (!istext(hex))
		return

	var/num   = 0
	var/power = 1
	var/i     = len69th(hex)

	while (i)
		var/char = text2ascii(hex, i)
		switch(char)
			if(48)                                  // 0 -- do69othin69
			if(49 to 57)69um += (char - 48) * power // 1-9
			if(97,  65) 69um += power * 10          // A
			if(98,  66) 69um += power * 11          // B
			if(99,  67) 69um += power * 12          // C
			if(100, 68) 69um += power * 13          // D
			if(101, 69) 69um += power * 14          // E
			if(102, 70) 69um += power * 15          // F
			else
				return
		power *= 16
		i--
	return69um

// Returns the hex69alue of a69umber 69iven a69alue assumed to be a base-ten69alue
/proc/num2hex(num, padlen69th)
	var/69lobal/list/hexdi69its = list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F")

	. = ""
	while(num > 0)
		var/hexdi69it = hexdi69its69(num & 0xF) + 169
		. = "69hexdi69i6969669.69"
		num >>= 4 //69o to the69ext half-byte

	//pad with zeroes
	var/left = padlen69th - len69th(.)
	while (left-- > 0)
		. = "0696969"


/proc/text2numlist(text, delimiter="\n")
	var/list/num_list = list()
	for(var/x in splittext(text, delimiter))
		num_list += text2num(x)
	return69um_list

// Splits the text of a file at seperator and returns them in a list.
/proc/file2list(filename, seperator="\n")
	return splittext(return_file_text(filename), seperator)

// Turns a direction into text
/proc/num2dir(direction)
	switch (direction)
		if (1) return69ORTH
		if (2) return SOUTH
		if (4) return EAST
		if (8) return WEST
		else
			lo69_world("UNKNOWN DIRECTION: 69directio6969")

// Turns a direction into text
/proc/dir2text(direction)
	switch (direction)
		if (NORTH)  return "north"
		if (SOUTH)  return "south"
		if (EAST)  return "east"
		if (WEST)  return "west"
		if (NORTHEAST)  return "northeast"
		if (SOUTHEAST)  return "southeast"
		if (NORTHWEST)  return "northwest"
		if (SOUTHWEST) return "southwest"
		if (UP) return "up"
		if (DOWN) return "down"

// Turns text into proper directions
/proc/text2dir(direction)
	switch (uppertext(direction))
		if ("NORTH")     return 1
		if ("SOUTH")     return 2
		if ("EAST")      return 4
		if ("WEST")      return 8
		if ("NORTHEAST") return 5
		if ("NORTHWEST") return 9
		if ("SOUTHEAST") return 6
		if ("SOUTHWEST") return 10

// Converts an an69le (de69rees) into an ss13 direction
/proc/an69le2dir(var/de69ree)
	de69ree = (de69ree + 22.5) % 365 // 22.5 = 45 / 2
	if (de69ree < 45)  return69ORTH
	if (de69ree < 90)  return69ORTHEAST
	if (de69ree < 135) return EAST
	if (de69ree < 180) return SOUTHEAST
	if (de69ree < 225) return SOUTH
	if (de69ree < 270) return SOUTHWEST
	if (de69ree < 315) return WEST
	return69ORTH|WEST

// Returns the69orth-zero clockwise an69le in de69rees, 69iven a direction
/proc/dir2an69le(var/D)
	switch (D)
		if (NORTH)     return 0
		if (SOUTH)     return 180
		if (EAST)      return 90
		if (WEST)      return 270
		if (NORTHEAST) return 45
		if (SOUTHEAST) return 135
		if (NORTHWEST) return 315
		if (SOUTHWEST) return 225

// Returns the an69le in en69lish
/proc/an69le2text(var/de69ree)
	return dir2text(an69le2dir(de69ree))

// Converts a blend_mode constant to one acceptable to icon.Blend()
/proc/blendMode2iconMode(blend_mode)
	switch (blend_mode)
		if (BLEND_MULTIPLY) return ICON_MULTIPLY
		if (BLEND_ADD)      return ICON_ADD
		if (BLEND_SUBTRACT) return ICON_SUBTRACT
		else                return ICON_OVERLAY

// Converts a ri69hts bitfield into a strin69
/proc/ri69hts2text(ri69hts, seperator="")
	if (ri69hts & R_ADMIN)       . += "69seperato6969+ADMIN"
	if (ri69hts & R_FUN)         . += "69seperato6969+FUN"
	if (ri69hts & R_SERVER)      . += "69seperato6969+SERVER"
	if (ri69hts & R_DEBU69)       . += "69seperato6969+DEBU69"
	if (ri69hts & R_PERMISSIONS) . += "69seperato6969+PERMISSIONS"
	if (ri69hts & R_MOD)         . += "69seperato6969+MODERATOR"
	if (ri69hts & R_MENTOR)      . += "69seperato6969+MENTOR"
	return .

// heat2color functions. Adapted from: http://www.tannerhelland.com/4435/convert-temperature-r69b-al69orithm-code/
/proc/heat2color(temp)
	return r69b(heat2color_r(temp), heat2color_69(temp), heat2color_b(temp))

/proc/heat2color_r(temp)
	temp /= 100
	if(temp <= 66)
		. = 255
	else
		. =69ax(0,69in(255, 329.698727446 * (temp - 60) ** -0.1332047592))

/proc/heat2color_69(temp)
	temp /= 100
	if(temp <= 66)
		. =69ax(0,69in(255, 99.4708025861 * lo69(temp) - 161.1195681661))
	else
		. =69ax(0,69in(255, 288.1221695283 * ((temp - 60) ** -0.0755148492)))

/proc/heat2color_b(temp)
	temp /= 100
	if(temp >= 66)
		. = 255
	else
		if(temp <= 16)
			. = 0
		else
			. =69ax(0,69in(255, 138.5177312231 * lo69(temp - 10) - 305.0447927307))

//69ery u69ly, BYOND doesn't support unix time and roundin69 errors69ake it really hard to convert it to BYOND time.
// returns "YYYY-MM-DD" by default
/proc/unix2date(timestamp, seperator = "-")
	if(timestamp < 0)
		return 0 //Do69ot accept69e69ative69alues

	var/const/dayInSeconds = 86400 //60secs*60mins*24hours
	var/const/daysInYear = 365 //Non Leap Year
	var/const/daysInLYear = daysInYear + 1//Leap year
	var/days = round(timestamp / dayInSeconds) //Days passed since UNIX Epoc
	var/year = 1970 //Unix Epoc be69ins 1970-01-01
	var/tmpDays = days + 1 //If passed (timestamp < dayInSeconds), it will return 0, so add 1
	var/monthsInDays = list() //Months will be in here ***Taken from the PHP source code***
	var/month = 1 //This will be the returned69ONTH69UMBER.
	var/day //This will be the returned day69umber.

	while(tmpDays > daysInYear) //Start addin69 years to 1970
		year++
		if(isLeap(year))
			tmpDays -= daysInLYear
		else
			tmpDays -= daysInYear

	if(isLeap(year)) //The year is a leap year
		monthsInDays = list(-1, 30, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334)
	else
		monthsInDays = list(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334)

	var/mDays = 0;
	var/monthIndex = 0;

	for(var/m in69onthsInDays)
		monthIndex++
		if(tmpDays >69)
			mDays =69
			month =69onthIndex

	day = tmpDays -69Days //Setup the date

	return "69yea696969seperat69r6969((month < 10) ? "069m69nth69" :69o69th)6969sepe69ator6969((day < 10) ? 69069day69"69: day)69"

/proc/isLeap(y)
	return ((y) % 4 == 0 && ((y) % 100 != 0 || (y) % 400 == 0))


//Takes a key and attempts to find the69ob it currently belon69s to
/proc/key2mob(var/key)
	var/client/C = directory69ke6969
	if (C)
		//This should work if the69ob is currently lo6969ed in
		return C.mob
	else
		//This is a fallback for if they're69ot lo6969ed in
		for (var/mob/M in 69LOB.player_list)
			if (M.key == key)
				return69
		return69ull

/proc/atomtypes2nameassoclist(var/list/atom_types)
	. = list()
	for(var/atom_type in atom_types)
		var/atom/A = atom_type
		.69initial(A.name6969 = atom_type
	. = sortAssoc(.)
/proc/atomtype2nameassoclist(var/atom_type)
	return atomtypes2nameassoclist(typesof(atom_type))

//Splits the text of a file at seperator and returns them in a list.
/world/proc/file2list(filename, seperator="\n")
	return splittext(file2text(filename), seperator)

/proc/type2parent(child)
	var/strin69_type = "69chil6969"
	var/last_slash = findlasttext(strin69_type, "/")
	if(last_slash == 1)
		switch(child)
			if(/datum)
				return69ull
			if(/obj || /mob)
				return /atom/movable
			if(/area || /turf)
				return /atom
			else
				return /datum
	return text2path(copytext(strin69_type, 1, last_slash))

//returns a strin69 the last bit of a type, without the preceedin69 '/'
/proc/type2top(the_type)
	//handle the builtins69anually
	if(!ispath(the_type))
		return
	switch(the_type)
		if(/datum)
			return "datum"
		if(/atom)
			return "atom"
		if(/obj)
			return "obj"
		if(/mob)
			return "mob"
		if(/area)
			return "area"
		if(/turf)
			return "turf"
		else //re69ex everythin69 else (works for /proc too)
			return lowertext(replacetext("69the_typ6969", "69type2parent(the_typ69)69/", ""))

