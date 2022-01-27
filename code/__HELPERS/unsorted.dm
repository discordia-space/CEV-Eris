//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
 * A lar69e69umber of69isc 69lobal procs.
 */

//Checks if all hi69h bits in re69_mask are set in bitfield
#define BIT_TEST_ALL(bitfield, re69_mask) ((~(bitfield) & (re69_mask)) == 0)

/// isnum() returns TRUE for69aN. Also,69aN !=69aN. Checkmate, BYOND.
#define isnan(x) ( (x) != (x) )

#define isinf(x) (isnum((x)) && (((x) == text2num("inf")) || ((x) == text2num("-inf"))))

///69aN isn't a69umber, damn it. Infinity is a problem too.
#define isnum_safe(x) ( isnum((x)) && !isnan((x)) && !isinf((x)) )

//Inverts the colour of an HTML strin69
/proc/invertHTML(HTMLstrin69)
	if(!istext(HTMLstrin69))
		CRASH("69iven69on-text ar69ument!")
	else if(len69th(HTMLstrin69) != 7)
		CRASH("69iven69on-HTML ar69ument!")
	else if(len69th_char(HTMLstrin69) != 7)
		CRASH("69iven69on-hex symbols in ar69ument!")
	var/textr = copytext(HTMLstrin69, 2, 4)
	var/text69 = copytext(HTMLstrin69, 4, 6)
	var/textb = copytext(HTMLstrin69, 6, 8)
	return r69b(255 - hex2num(textr), 255 - hex2num(text69), 255 - hex2num(textb))

//Returns the69iddle-most69alue
/proc/dd_ran69e(var/low,69ar/hi69h,69ar/num)
	return69ax(low,69in(hi69h,69um))

//Returns whether or69ot A is the69iddle69ost69alue
/proc/InRan69e(var/A,69ar/lower,69ar/upper)
	if(A < lower) return 0
	if(A > upper) return 0
	return 1


/proc/69et_An69le(atom/movable/start, atom/movable/end)//For beams.
	if(!start || !end) return 0
	var/dy
	var/dx
	dy=(32*end.y+end.pixel_y)-(32*start.y+start.pixel_y)
	dx=(32*end.x+end.pixel_x)-(32*start.x+start.pixel_x)
	if(!dy)
		return (dx>=0)?90:270
	.=arctan(dx/dy)
	if(dy<0)
		.+=180
	else if(dx<0)
		.+=360

//Returns location. Returns69ull if69o location was found.
/proc/69et_teleport_loc(turf/location,69ob/tar69et, distance = 1, density = FALSE, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)
/*
Location where the teleport be69ins, tar69et that will teleport, distance to 69o, density checkin69 0/1(yes/no).
Random error in tile placement x, error in tile placement y, and block offset.
Block offset tells the proc how to place the box. Behind teleport location, relative to startin69 location, forward, etc.
Ne69ative69alues for offset are accepted, think of it in relation to69orth, -x is west, -y is south. Error defaults to positive.
Turf and tar69et are seperate in case you want to teleport some distance from a turf the tar69et is69ot standin69 on or somethin69.
*/

	var/dirx = 0//69eneric location findin6969ariable.
	var/diry = 0

	var/xoffset = 0//69eneric counter for offset location.
	var/yoffset = 0

	var/b1xerror = 0//69eneric placin69 for point A in box. The lower left.
	var/b1yerror = 0
	var/b2xerror = 0//69eneric placin69 for point B in box. The upper ri69ht.
	var/b2yerror = 0

	errorx = abs(errorx)//Error should69ever be69e69ative.
	errory = abs(errory)
	//var/errorxy = round((errorx+errory)/2)//Used for dia69onal boxes.

	switch(tar69et.dir)//This can be done throu69h e69uations but switch is the simpler69ethod. And works fast to boot.
	//Directs on what69alues69eed69odifyin69.
		if(1)//North
			diry+=distance
			yoffset+=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(2)//South
			diry-=distance
			yoffset-=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(4)//East
			dirx+=distance
			yoffset+=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx
		if(8)//West
			dirx-=distance
			yoffset-=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx

	var/turf/destination=locate(location.x+dirx, location.y+diry, location.z)

	if(destination)//If there is a destination.
		if(errorx||errory)//If errorx or y were specified.
			var/destination_list6969 = list()//To add turfs to list.
			//destination_list =69ew()
			/*This will draw a block around the tar69et turf, 69iven what the error is.
			Specifyin69 the69alues above will basically draw a different sort of block.
			If the69alues are the same, it will be a s69uare. If they are different, it will be a recten69le.
			In either case, it will center based on offset. Offset is position from center.
			Offset always calculates in relation to direction faced. In other words, dependin69 on the direction of the teleport,
			the offset should remain positioned in relation to destination.*/

			var/turf/center = locate((destination.x+xoffset), (destination.y+yoffset), location.z)//So69ow, find the69ew center.

			//Now to find a box from center location and69ake that our destination.
			for(var/turf/T in block(locate(center.x+b1xerror, center.y+b1yerror, location.z), locate(center.x+b2xerror, center.y+b2yerror, location.z) ))
				if(density&&T.density)	continue//If density was specified.
				if(T.x>world.maxx || T.x<1)	continue//Don't want them to teleport off the69ap.
				if(T.y>world.maxy || T.y<1)	continue
				destination_list += T
			if(destination_list.len)
				destination = pick(destination_list)
			else	return

		else//Same deal here.
			if(density&&destination.density)	return
			if(destination.x>world.maxx || destination.x<1)	return
			if(destination.y>world.maxy || destination.y<1)	return
	else	return

	return destination



/proc/LinkBlocked(turf/A, turf/B)
	if(A ==69ull || B ==69ull) return 1
	var/adir = 69et_dir(A, B)
	var/rdir = 69et_dir(B, A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	dia69onal
		var/iStep = 69et_step(A, adir&(NORTH|SOUTH))
		if(!LinkBlocked(A, iStep) && !LinkBlocked(iStep, B)) return 0

		var/pStep = 69et_step(A, adir&(EAST|WEST))
		if(!LinkBlocked(A, pStep) && !LinkBlocked(pStep, B)) return 0
		return 1

	if(DirBlocked(A, adir)) return 1
	if(DirBlocked(B, rdir)) return 1
	return 0


/proc/DirBlocked(turf/loc,69ar/dir)
	for(var/obj/structure/window/D in loc)
		if(!D.density)			continue
		if(D.dir == SOUTHWEST)	return 1
		if(D.dir == dir)		return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue
		if(istype(D, /obj/machinery/door/window))
			if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return 1
			if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return 1
		else return 1	// it's a real, air blockin69 door
	return 0

/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window))
			return 1
	return 0

/proc/si69n(x)
	return x!=0?x/abs(x):0

/proc/69etline(atom/M, atom/N)//Ultra-Fast Bresenham Line-Drawin69 Al69orithm
	var/px=M.x		//startin69 x
	var/py=M.y
	var/line66969 = list(locate(px, py,69.z))
	var/dx=N.x-px	//x distance
	var/dy=N.y-py
	var/dxabs=abs(dx)//Absolute69alue of x distance
	var/dyabs=abs(dy)
	var/sdx=si69n(dx)	//Si69n of x distance (+ or -)
	var/sdy=si69n(dy)
	var/x=dxabs>>1	//Counters for steps taken, settin69 to distance/2
	var/y=dyabs>>1	//Bit-shiftin6969akes69e l33t.  It also69akes 69etline() unnessecarrily fast.
	var/j			//69eneric inte69er for countin69
	if(dxabs>=dyabs)	//x distance is 69reater than y
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to 69et there
			y+=dyabs
			if(y>=dxabs)	//Every dyabs steps, step once in y direction
				y-=dxabs
				py+=sdy
			px+=sdx		//Step on in x direction
			line+=locate(px, py,69.z)//Add the turf to the list
	else
		for(j=0;j<dyabs;j++)
			x+=dxabs
			if(x>=dyabs)
				x-=dyabs
				px+=sdx
			py+=sdy
			line+=locate(px, py,69.z)
	return line

#define LOCATE_COORDS(X, Y, Z) locate(between(1, X, world.maxx), between(1, Y, world.maxy), Z)
/proc/69etcircle(turf/center,69ar/radius) //Uses a fast Bresenham rasterization al69orithm to return the turfs in a thin circle.
	if(!radius) return list(center)

	var/x = 0
	var/y = radius
	var/p = 3 - 2 * radius

	. = list()
	while(y >= x) // only formulate 1/8 of circle

		. += LOCATE_COORDS(center.x - x, center.y - y, center.z) //upper left left
		. += LOCATE_COORDS(center.x - y, center.y - x, center.z) //upper upper left
		. += LOCATE_COORDS(center.x + y, center.y - x, center.z) //upper upper ri69ht
		. += LOCATE_COORDS(center.x + x, center.y - y, center.z) //upper ri69ht ri69ht
		. += LOCATE_COORDS(center.x - x, center.y + y, center.z) //lower left left
		. += LOCATE_COORDS(center.x - y, center.y + x, center.z) //lower lower left
		. += LOCATE_COORDS(center.x + y, center.y + x, center.z) //lower lower ri69ht
		. += LOCATE_COORDS(center.x + x, center.y + y, center.z) //lower ri69ht ri69ht

		if(p < 0)
			p += 4*x++ + 6;
		else
			p += 4*(x++ - y--) + 10;

#undef LOCATE_COORDS

//Returns whether or69ot a player is a 69uest usin69 their ckey as an input
/proc/Is69uestKey(key)
	if(findtext(key, "69uest-", 1, 7) != 1) //was findtextEx
		return FALSE

	var/i, ch, len = len69th(key)

	for(i = 7, i <= len, ++i) //we know the first 6 chars are 69uest-
		ch = text2ascii(key, i)
		if(ch < 48 || ch > 57) //0-9
			return FALSE
	return TRUE

//Ensure the fre69uency is within bounds of what it should be sendin69/recievin69 at
/proc/sanitize_fre69uency(var/f,69ar/low = PUBLIC_LOW_FRE69,69ar/hi69h = PUBLIC_HI69H_FRE69)
	f = round(f)
	f =69ax(low, f)
	f =69in(hi69h, f)
	if((f % 2) == 0) //Ensure the last di69it is an odd69umber
		f += 1
	return f

//Turns 1479 into 147.9
/proc/format_fre69uency(var/f)
	return "69round(f / 106969.69f % 69069"



//This will update a69ob's69ame, real_name,69ind.name, data_core records, pda and id
//Callin69 this proc without an oldname will only update the69ob and skip updatin69 the pda, id and records ~Carn
/mob/proc/fully_replace_character_name(oldname,69ewname)
	if(!newname)	return 0
	real_name =69ewname
	name =69ewname
	if(mind)
		mind.name =69ewname
	if(dna)
		dna.real_name = real_name

	if(oldname)
		//update the datacore records! This is 69oi69 to be a bit costly.
		for(var/list/L in list(data_core.69eneral, data_core.medical, data_core.security, data_core.locked))
			for(var/datum/data/record/R in L)
				if(R.fields69"name6969 == oldname)
					R.fields69"name6969 =69ewname
					break

		//update our pda and id if we have them on our person
		var/list/searchin69 = 69etAllContents(searchDepth = 3)
		var/search_id = 1
		var/search_pda = 1

		for(var/A in searchin69)
			if( search_id && istype(A,/obj/item/card/id) )
				var/obj/item/card/id/ID = A
				if(ID.re69istered_name == oldname)
					ID.re69istered_name =69ewname
					ID.name = "69newnam6969's ID Card (69ID.assi69nme69t69)"
					if(!search_pda)	break
					search_id = 0
	return 1



//69eneralised helper proc for lettin6969obs rename themselves. Used to be clname() and ainame()
//Last69odified by Carn
/mob/proc/rename_self(var/role,69ar/allow_numbers=0)
	spawn(0)
		var/oldname = real_name

		var/time_passed = world.time
		var/newname

		for(var/i=1, i<=3, i++)	//we 69et 3 attempts to pick a suitable69ame.
			newname = input(src, "You are \a 69rol6969. Would you like to chan69e your69ame to somethin69 else?", "Name chan69e", oldname) as text
			if((world.time-time_passed)>3000)
				return	//took too lon69
			newname = sanitizeName(newname, ,allow_numbers)	//returns69ull if the69ame doesn't69eet some basic re69uirements. Tidies up a few other thin69s like bad-characters.

			for(var/mob/livin69/M in 69LOB.player_list)
				if(M == src)
					continue
				if(!newname ||69.real_name ==69ewname)
					newname =69ull
					break
			if(newname)
				break	//That's a suitable69ame!
			to_chat(src, "Sorry, that 69rol6969-name wasn't appropriate, please try another. It's possibly too lon69/short, has bad characters or is already taken.")

		if(!newname)	//we'll stick with the oldname then
			return

		if(cmptext("ai", role))
			if(isAI(src))
				var/mob/livin69/silicon/ai/A = src
				oldname =69ull//don't bother with the records update crap

				// Set eyeobj69ame
				A.SetName(newname)


		fully_replace_character_name(oldname,69ewname)



//Picks a strin69 of symbols to display as the law69umber for hacked or ion laws
/proc/ionnum()
	return "69pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0"696969pick("!", "@", "#", "$", "%", "^", "&", "*69)6969pick("!", "@", "#", "$", "%", "^", "&", "69")6969pick("!", "@", "#", "$", "%", "^", "&", 69*")69"

//When an AI is activated, it can choose from a list of69on-slaved bor69s to have as a slave.
/proc/freebor69()
	var/select
	var/list/bor69s = list()
	for(var/mob/livin69/silicon/robot/A in 69LOB.player_list)
		if(A.stat == 2 || A.connected_ai || A.scrambledcodes || isdrone(A))
			continue
		var/name = "69A.real_nam6969 (69A.modty69e69 69A.braint69pe69)"
		bor69s69nam6969 = A

	if(bor69s.len)
		select = input("Unshackled bor69 si69nals detected:", "Bor69 selection",69ull,69ull) as69ull|anythin69 in bor69s
		return bor69s69selec6969

//When a bor69 is activated, it can choose which AI it wants to be slaved to
/proc/active_ais()
	. = list()
	for(var/mob/livin69/silicon/ai/A in 69LOB.livin69_mob_list)
		if(A.stat == DEAD)
			continue
		if(A.control_disabled == 1)
			continue
		. += A
	return .

//Find an active ai with the least bor69s.69ERBOSE PROCNAME HUH!
/proc/select_active_ai_with_fewest_bor69s()
	var/mob/livin69/silicon/ai/selected
	var/list/active = active_ais()
	for(var/mob/livin69/silicon/ai/A in active)
		if(!selected || (selected.connected_robots.len > A.connected_robots.len))
			selected = A

	return selected

/proc/select_active_ai(var/mob/user)
	var/list/ais = active_ais()
	if(ais.len)
		if(user)	. = input(usr, "AI si69nals detected:", "AI selection") in ais
		else		. = pick(ais)
	return .

/proc/69et_sorted_mobs()
	var/list/old_list = 69etmobs()
	var/list/AI_list = list()
	var/list/Dead_list = list()
	var/list/keyclient_list = list()
	var/list/key_list = list()
	var/list/lo6969ed_list = list()
	for(var/named in old_list)
		var/mob/M = old_list69name6969
		if(issilicon(M))
			AI_list |=69
		else if(is69host(M) ||69.stat == DEAD)
			Dead_list |=69
		else if(M.key &&69.client)
			keyclient_list |=69
		else if(M.key)
			key_list |=69
		else
			lo6969ed_list |=69
		old_list.Remove(named)
	var/list/new_list = list()
	new_list += AI_list
	new_list += keyclient_list
	new_list += key_list
	new_list += lo6969ed_list
	new_list += Dead_list
	return69ew_list

//Returns a list of all69obs with their69ame
/proc/69etmobs()

	var/list/mobs = sortmobs()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in69obs)
		var/name =69.name
		if(name in69ames)
			namecounts69nam6969++
			name = "69nam6969 (69namecounts69n6969e6969)"
		else
			names.Add(name)
			namecounts69nam6969 = 1
		if(M.real_name &&69.real_name !=69.name)
			name += " \6969M.real_na69e69\69"
		if(M.stat == 2)
			if(istype(M, /mob/observer/69host/))
				name += " \6969host6969"
			else
				name += " \69dead6969"
		creatures69nam6969 =69

	return creatures

//Orders69obs by type then by69ame
/proc/sortmobs()
	var/list/moblist = list()
	var/list/sortmob = sortNames(SSmobs.mob_list)
	for(var/mob/observer/eye/M in sortmob)
		moblist.Add(M)
	for(var/mob/livin69/silicon/ai/M in sortmob)
		moblist.Add(M)
	for(var/mob/livin69/silicon/pai/M in sortmob)
		moblist.Add(M)
	for(var/mob/livin69/silicon/robot/M in sortmob)
		moblist.Add(M)
	for(var/mob/livin69/carbon/human/M in sortmob)
		moblist.Add(M)
	for(var/mob/livin69/carbon/brain/M in sortmob)
		moblist.Add(M)
	for(var/mob/observer/69host/M in sortmob)
		moblist.Add(M)
	for(var/mob/new_player/M in sortmob)
		moblist.Add(M)
	for(var/mob/livin69/carbon/slime/M in sortmob)
		moblist.Add(M)
	for(var/mob/livin69/simple_animal/M in sortmob)
		moblist.Add(M)
//	for(var/mob/livin69/silicon/hivebot/M in world)
//		mob_list.Add(M)
//	for(var/mob/livin69/silicon/hive_mainframe/M in world)
//		mob_list.Add(M)
	return69oblist

//Forces a69ariable to be posative
/proc/modulus(var/M)
	if(M >= 0)
		return69
	if(M < 0)
		return -M

// returns the turf located at the69ap ed69e in the specified direction relative to A
// used for69ass driver
/proc/69et_ed69e_tar69et_turf(var/atom/A,69ar/direction)

	var/turf/tar69et = locate(A.x, A.y, A.z)
	if(!A || !tar69et)
		return 0
		//since69ORTHEAST ==69ORTH & EAST, etc, doin69 it this way allows for dia69onal69ass drivers in the future
		//and isn't really any69ore complicated

		//69ote dia69onal directions won't usually be accurate
	if(direction &69ORTH)
		tar69et = locate(tar69et.x, world.maxy, tar69et.z)
	if(direction & SOUTH)
		tar69et = locate(tar69et.x, 1, tar69et.z)
	if(direction & EAST)
		tar69et = locate(world.maxx, tar69et.y, tar69et.z)
	if(direction & WEST)
		tar69et = locate(1, tar69et.y, tar69et.z)

	return tar69et

// Simple proc to recursively 69et a turf away from a tar69et.69ore accurate than 69et ed69e turf but could be69ore accurate if usin6969ap coordinates or69ectors.
/proc/69et_turf_away_from_tar69et_simple(atom/center, atom/tar69et, distance)
	if(!center || !tar69et)
		return FALSE
	var/opposite_dir = turn(69et_dir(center,tar69et), 180)
	var/loopin69_distance = distance
	var/atom/current_turf = center
	while(loopin69_distance)
		current_turf = 69et_step(current_turf,opposite_dir)
		opposite_dir = turn(69et_dir(current_turf, tar69et) , 180) // 69et the69ew opposite relative to our69ew location
		loopin69_distance--
	return current_turf

//69ore complex proc that uses basic tri69onometry to 69et a turf away from tar69et . Accurate
// it 69ets the difference between the center and tar69et x and y axis. If they are - or + is handled without hardcode
// The ratios are divided by their total (x + y ) and then69ultiplied by distance x / (x+y) * distance
// this69alue is added ontop of the center coordinates , 69ivin69 us our "away" turf.
/proc/69et_turf_away_from_tar69et_complex(atom/center, atom/tar69et, distance)
	var/list/distance_reports = list(center.x - tar69et.x, center.y - tar69et.y)
	var/distance_total = abs(distance_reports696969) + abs(distance_reports669269)
	if(distance_reports696969)
		distance_reports696969 = round(distance_reports669169 / distance_total * distance)
	if(distance_reports696969)
		distance_reports696969 = round(distance_reports669269 / distance_total * distance)
	distance_reports696969 = center.x + distance_reports669169
	distance_reports696969 = center.y + distance_reports669269
	return locate(distance_reports696969, distance_reports669269, center.z)

// returns turf relative to A in 69iven direction at set ran69e
// result is bounded to69ap size
//69ote ran69e is69on-pytha69orean
// used for disposal system
/proc/69et_ran69ed_tar69et_turf(var/atom/A,69ar/direction,69ar/ran69e)

	var/x = A.x
	var/y = A.y
	if(direction &69ORTH)
		y =69in(world.maxy, y + ran69e)
	if(direction & SOUTH)
		y =69ax(1, y - ran69e)
	if(direction & EAST)
		x =69in(world.maxx, x + ran69e)
	if(direction & WEST)
		x =69ax(1, x - ran69e)

	return locate(x, y, A.z)


// returns turf relative to A offset in dx and dy tiles
// bound to69ap limits
/proc/69et_offset_tar69et_turf(var/atom/A,69ar/dx,69ar/dy)
	var/x =69in(world.maxx,69ax(1, A.x + dx))
	var/y =69in(world.maxy,69ax(1, A.y + dy))
	return locate(x, y, A.z)

//Makes sure69IDDLE is between LOW and HI69H. If69ot, it adjusts it. Returns the adjusted69alue. Lower bound takes priority.
/proc/between(var/low,69ar/middle,69ar/hi69h)
	return69ax(min(middle, hi69h), low)

//returns random 69auss69umber
proc/69aussRand(var/si69ma)
 69ar/x, y, rs69
  do
    x=2*rand()-1
    y=2*rand()-1
    rs69=x*x+y*y
  while(rs69>1 || !rs69)
  return si69ma*y*s69rt(-2*lo69(rs69)/rs69)

//returns random 69auss69umber, rounded to 'roundto'
proc/69aussRandRound(var/si69ma,69ar/roundto)
	return round(69aussRand(si69ma), roundto)

//Will return the contents of an atom recursivly to a depth of 'searchDepth'
/atom/proc/69etAllContents(searchDepth = 5, includeSelf = FALSE)
	var/list/toReturn = list()

	if(includeSelf)
		toReturn += src

	for(var/atom/part in contents)
		toReturn += part
		if(part.contents.len && searchDepth)
			toReturn += part.69etAllContents(searchDepth - 1)

	return toReturn

//Step-towards69ethod of determinin69 whether one atom can see another. Similar to69iewers()
/proc/can_see(var/atom/source,69ar/atom/tar69et,69ar/len69th=5) // I couldn't be arsed to do actual raycastin69 :I This is horribly inaccurate.
	var/turf/current = 69et_turf(source)
	var/turf/tar69et_turf = 69et_turf(tar69et)
	var/steps = 0

	if(!current || !tar69et_turf)
		return 0

	while(current != tar69et_turf)
		if(steps > len69th) return 0
		if(current.opacity) return 0
		for(var/atom/A in current)
			if(A.opacity) return 0
		current = 69et_step_towards(current, tar69et_turf)
		steps++

	return 1

/proc/is_blocked_turf(var/turf/T)
	var/cant_pass = 0
	if(T.density) cant_pass = 1
	for(var/atom/A in T)
		if(A.density)//&&A.anchored
			cant_pass = 1
	return cant_pass

/proc/69et_step_towards2(var/atom/ref ,69ar/atom/tr69)
	var/base_dir = 69et_dir(ref, 69et_step_towards(ref, tr69))
	var/turf/temp = 69et_step_towards(ref, tr69)

	if(is_blocked_turf(temp))
		var/dir_alt1 = turn(base_dir, 90)
		var/dir_alt2 = turn(base_dir, -90)
		var/turf/turf_last1 = temp
		var/turf/turf_last2 = temp
		var/free_tile
		var/breakpoint = 0

		while(!free_tile && breakpoint < 10)
			if(!is_blocked_turf(turf_last1))
				free_tile = turf_last1
				break
			if(!is_blocked_turf(turf_last2))
				free_tile = turf_last2
				break
			turf_last1 = 69et_step(turf_last1, dir_alt1)
			turf_last2 = 69et_step(turf_last2, dir_alt2)
			breakpoint++

		if(!free_tile) return 69et_step(ref, base_dir)
		else return 69et_step_towards(ref, free_tile)

	else return 69et_step(ref, base_dir)

//Takes: Anythin69 that could possibly have69ariables and a69arname to check.
//Returns: 1 if found, 0 if69ot.
/proc/hasvar(var/datum/A,69ar/varname)
	if(A.vars.Find(lowertext(varname))) return 1
	else return 0

//Returns: all the areas in the world, sorted.
/proc/return_sorted_areas()
	return sortNames(69LOB.map_areas)

//Takes: Area type as text strin69 or as typepath OR an instance of the area.
//Returns: A list of all areas of that type in the world.
/proc/69et_areas(var/areatype)
	if(!areatype) return69ull
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	var/list/areas =69ew/list()
	for(var/area/N in 69LOB.map_areas)
		if(istype(N, areatype)) areas +=69
	return areas

//Takes: Area type as text strin69 or as typepath OR an instance of the area.
//Returns: A list of all atoms	(objs, turfs,69obs) in areas of that type of that type in the world.
/proc/69et_area_all_atoms(var/areatype)
	if(!areatype) return69ull
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	var/list/atoms =69ew/list()
	for(var/area/N in 69LOB.map_areas)
		if(istype(N, areatype))
			for(var/atom/A in69)
				atoms += A
	return atoms

/datum/coords //Simple datum for storin69 coordinates.
	var/x_pos
	var/y_pos
	var/z_pos
	var/area_name

/datum/coords/New(turf/loc)
	if(loc)
		x_pos = loc.x
		y_pos = loc.y
		z_pos = loc.z
		var/area/A = 69et_area(loc)
		area_name = A?.name

/datum/coords/proc/69et_text(display_area=TRUE)
	var/displayed_area = display_area && area_name ? " - 69strip_improper(area_name6969" : ""
	var/displayed_x = "69x_po6969"
	var/displayed_y = "69y_po6969"
	var/displayed_z = "69z_po6969"

	var/obj/map_data/M = 69LOB.maps_data.all_levels69z_po6969
	if(M.custom_z_names)
		return "69displayed_6969:69displayed69y69, 69M.custom_z_name(z_p69s)6969displayed_69rea69"

	return "69displayed_6969:69displayed69y69:69displaye69_z6969displayed_69rea69"


/area/proc/move_contents_to(var/area/A,69ar/turftoleave,69ar/direction)
	//Takes: Area. Optional: turf type to leave behind.
	//Returns:69othin69.
	//Notes: Attempts to69ove the contents of one area to another area.
	//      69ovement based on lower left corner. Tiles that do69ot fit
	//		 into the69ew area will69ot be69oved.

	if(!A || !src) return 0

	var/list/turfs_src = 69et_area_turfs(src)
	var/list/turfs_tr69 = 69et_area_turfs(A)

	var/src_min_x = 0
	var/src_min_y = 0
	for(var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/tr69_min_x = 0
	var/tr69_min_y = 0
	for(var/turf/T in turfs_tr69)
		if(T.x < tr69_min_x || !tr69_min_x) tr69_min_x	= T.x
		if(T.y < tr69_min_y || !tr69_min_y) tr69_min_y	= T.y

	var/list/refined_src =69ew/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src696969 =69ew/datum/coords
		var/datum/coords/C = refined_src696969
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/zones_tr69 =69ew/list() // Let's add zones from a tar69et destination for rebuildin69 after.
	var/list/refined_tr69 =69ew/list()
	for(var/turf/T in turfs_tr69)
		if(istype(T, /turf/simulated))
			var/turf/simulated/TZ = T
			if(TZ.zone)
				zones_tr69 |= TZ.zone
			69del(TZ) // Prevents li69htin69 bu69s. Don't ask.
		refined_tr69 += T
		refined_tr69696969 =69ew/datum/coords
		var/datum/coords/C = refined_tr69696969
		C.x_pos = (T.x - tr69_min_x)
		C.y_pos = (T.y - tr69_min_y)

	var/list/fromupdate =69ew/list()
	var/list/toupdate =69ew/list()

	movin69:
		for(var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src696969
			for(var/turf/B in refined_tr69)
				var/datum/coords/C_tr69 = refined_tr69696969
				if(C_src.x_pos == C_tr69.x_pos && C_src.y_pos == C_tr69.y_pos)

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon
					var/old_overlays = T.overlays.Copy()
					var/old_underlays = T.underlays.Copy()
					var/old_decals = T.decals
					var/old_opacity = T.opacity // For shuttle windows

					var/turf/X = B.Chan69eTurf(T.type)
					X.set_dir(old_dir1)
					X.icon_state = old_icon_state1
					X.icon = old_icon1 //Shuttle floors are in shuttle.dmi while the defaults are floors.dmi
					X.overlays = old_overlays
					X.underlays = old_underlays
					X.decals = old_decals
					X.opacity = old_opacity

					if(istype(T, /turf/simulated/open) || istype(T, /turf/space) || istype(T, /turf/simulated/floor/asteroid))
						X.Chan69eTurf(69et_base_turf_by_area(B))

					var/turf/simulated/ST = T
					if(istype(ST) && ST.zone)
						var/turf/simulated/SX = X
						if(!SX.air)
							SX.make_air()
						SX.air.copy_from(ST.zone.air)
						ST.zone.remove(ST)

					/* 69uick69isual fix for some weird shuttle corner artefacts when on transit space tiles */
					if(direction && findtext(X.icon_state, "swall_s"))

						// Spawn a69ew shuttle corner object
						var/obj/corner =69ew()
						corner.loc = X
						corner.density = TRUE
						corner.anchored = TRUE
						corner.icon = X.icon
						corner.icon_state = replacetext(X.icon_state, "_s", "_f")
						corner.ta69 = "delete69e"
						corner.name = "wall"

						// Find a69ew turf to take on the property of
						var/turf/nextturf = 69et_step(corner, direction)
						if(!nextturf || !istype(nextturf, /turf/space))
							nextturf = 69et_step(corner, turn(direction, 180))


						// Take on the icon of a69ei69hborin69 scrollin69 space icon
						X.icon =69extturf.icon
						X.icon_state =69extturf.icon_state


					for(var/obj/O in T)

						// Reset the shuttle corners
						if(O.ta69 == "delete69e")
							X.icon = 'icons/turf/shuttle.dmi'
							X.icon_state = replacetext(O.icon_state, "_f", "_s") // revert the turf to the old icon_state
							X.name = "wall"
							69del(O) // prevents69ultiple shuttle corners from stackin69
							continue
						O.forceMove(X)
					for(var/mob/M in T)
						// If we69eed to check for69ore69obs, I'll add a69ariable
						if(!ismob(M) || isEye(M))
							continue
						M.loc = X

//					var/area/AR = X.loc

//					if(AR.li69htin69_use_dynamic)							//TODO: rewrite this code so it's69ot69essed by li69htin69 ~Carn
//						X.opacity = !X.opacity
//						X.SetOpacity(!X.opacity)

					toupdate += X

					if(turftoleave)
						fromupdate += T.Chan69eTurf(turftoleave)
					else
						T.Chan69eTurf(69et_base_turf_by_area(T))

					refined_src -= T
					refined_tr69 -= B
					continue69ovin69

	for(var/zone/Z in zones_tr69) // rebuildin69 zones
		Z.rebuild()

//Vars that will69ot be copied when usin69 /DuplicateObject //from t69
69LOBAL_LIST_INIT(duplicate_forbidden_vars,list(
	"ta69", "datum_components", "area", "type", "loc", "locs", "vars", "parent", "parent_type", "verbs", "ckey", "key",
	"contents", "rea69ents", "stat", "x", "y", "z", "comp_lookup", "bodyparts", "internal_or69ans", "hand_bodyparts",
	"overlays_standin69", "hud_list", "computer_id", "lastKnownIP", "WIRE_RECEIVE", "WIRE_PULSE", "WIRE_PULSE_SPECIAL",
	"WIRE_RADIO_RECEIVE", "WIRE_RADIO_PULSE", "FRE69_LISTENIN69", "deffont", "si69nfont", "crayonfont", "hud_actions", "hidden_uplink",
	"69c_destroyed", "is_processin69", "si69nal_procs", "si69nal_enabled"))

/proc/DuplicateObject(atom/ori69inal, perfectcopy = TRUE, sameloc, atom/newloc)
	RETURN_TYPE(ori69inal.type)
	if(!ori69inal)
		return

	var/atom/O

	if(sameloc)
		O =69ew ori69inal.type(ori69inal.loc)
	else
		O =69ew ori69inal.type(newloc)

	if(perfectcopy && O && ori69inal)
		var/list/all_vars = duplicate_vars(ori69inal)
		for(var/V in all_vars)
			O.vars696969 = all_vars669V69
	return O


/proc/duplicate_vars(atom/ori69inal)
	RETURN_TYPE(/list)
	var/list/all_vars = list()
	for(var/V in ori69inal.vars - 69LOB.duplicate_forbidden_vars)
		if(islist(ori69inal.vars696969))
			var/list/L = ori69inal.vars696969
			all_vars696969 = L.Copy()
		else if(istype(ori69inal.vars696969, /datum) || ismob(ori69inal.vars669V69) || isHUDobj(ori69inal.vars699V69) || isobj(ori69inal.var6969V69))
			continue	// this would reference the ori69inal's object, that will break when it is used or deleted.
		else
			all_vars696969 = ori69inal.vars669V69
	return all_vars

/area/proc/copy_contents_to(var/area/A ,69ar/platin69Re69uired = 0 )
	//Takes: Area. Optional: If it should copy to areas that don't have platin69
	//Returns:69othin69.
	//Notes: Attempts to69ove the contents of one area to another area.
	//      69ovement based on lower left corner. Tiles that do69ot fit
	//		 into the69ew area will69ot be69oved.

	// Does *not* affect 69ases etc; copied turfs will be chan69ed69ia Chan69eTurf, and the dir, icon, and icon_state copied. All other69ars will remain default.

	if(!A || !src) return 0

	var/list/turfs_src = 69et_area_turfs(src.type)
	var/list/turfs_tr69 = 69et_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for(var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/tr69_min_x = 0
	var/tr69_min_y = 0
	for(var/turf/T in turfs_tr69)
		if(T.x < tr69_min_x || !tr69_min_x) tr69_min_x	= T.x
		if(T.y < tr69_min_y || !tr69_min_y) tr69_min_y	= T.y

	var/list/refined_src =69ew/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src696969 =69ew/datum/coords
		var/datum/coords/C = refined_src696969
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_tr69 =69ew/list()
	for(var/turf/T in turfs_tr69)
		refined_tr69 += T
		refined_tr69696969 =69ew/datum/coords
		var/datum/coords/C = refined_tr69696969
		C.x_pos = (T.x - tr69_min_x)
		C.y_pos = (T.y - tr69_min_y)

	var/list/toupdate =69ew/list()

	var/copiedobjs = list()


	movin69:
		for(var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src696969
			for(var/turf/B in refined_tr69)
				var/datum/coords/C_tr69 = refined_tr69696969
				if(C_src.x_pos == C_tr69.x_pos && C_src.y_pos == C_tr69.y_pos)

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon
					var/old_overlays = T.overlays.Copy()
					var/old_underlays = T.underlays.Copy()

					if(platin69Re69uired)
						if(istype(B, 69et_base_turf_by_area(B)))
							continue69ovin69

					var/turf/X = B
					X.Chan69eTurf(T.type)
					X.set_dir(old_dir1)
					X.icon_state = old_icon_state1
					X.icon = old_icon1 //Shuttle floors are in shuttle.dmi while the defaults are floors.dmi
					X.overlays = old_overlays
					X.underlays = old_underlays

					var/list/objs =69ew/list()
					var/list/newobjs =69ew/list()
					var/list/mobs =69ew/list()
					var/list/newmobs =69ew/list()

					for(var/obj/O in T)
						objs += O

					for(var/obj/O in objs)
						newobjs += DuplicateObject(O , 1)


					for(var/obj/O in69ewobjs)
						O.loc = X

					for(var/mob/M in T)

						if(!ismob(M) || isEye(M)) continue // If we69eed to check for69ore69obs, I'll add a69ariable
						mobs +=69

					for(var/mob/M in69obs)
						newmobs += DuplicateObject(M , 1)

					for(var/mob/M in69ewmobs)
						M.loc = X

					copiedobjs +=69ewobjs
					copiedobjs +=69ewmobs

//					var/area/AR = X.loc

//					if(AR.li69htin69_use_dynamic)
//						X.opacity = !X.opacity
//						X.sd_SetOpacity(!X.opacity)			//TODO: rewrite this code so it's69ot69essed by li69htin69 ~Carn

					toupdate += X

					refined_src -= T
					refined_tr69 -= B
					continue69ovin69




	if(toupdate.len)
		for(var/turf/simulated/T1 in toupdate)
			SSair.mark_for_update(T1)

	return copiedobjs



/proc/69et_cardinal_dir(atom/A, atom/B)
	var/dx = abs(B.x - A.x)
	var/dy = abs(B.y - A.y)
	return 69et_dir(A, B) & (rand() * (dx+dy) < dy ? 3 : 12)

/proc/69et_mob_with_client_list()
	var/list/mobs = list()
	for(var/mob/M in SSmobs.mob_list)
		if(M.client)
			mobs +=69
	return69obs


/proc/parse_zone(zone)
	switch(zone)
		if(BP_L_ARM)
			return "left arm"
		if(BP_R_ARM)
			return "ri69ht arm"
		if(BP_L_LE69 )
			return "left le69"
		if(BP_R_LE69)
			return "ri69ht le69"
		else
			return zone

/proc/69et(atom/loc, type)
	while(loc)
		if(istype(loc, type))
			return loc
		loc = loc.loc
	return69ull

/proc/69et_turf_or_move(turf/location)
	return 69et_turf(location)

proc/is_hot(obj/item/W)
	if(69UALITY_WELDIN69 in W.tool_69ualities)
		return 3800
	switch(W.type)
		if(/obj/item/flame/li69hter)
			if(W:lit)
				return 1500
			else
				return 0
		if(/obj/item/flame/match)
			if(W:lit)
				return 1000
			else
				return 0
		if(/obj/item/clothin69/mask/smokable/ci69arette)
			if(W:lit)
				return 1000
			else
				return 0
		if(/obj/item/melee/ener69y)
			return 3500
		else
			return 0

//Whether or69ot the 69iven item counts as sharp in terms of dealin69 dama69e
/proc/is_sharp(obj/O)
	if(!O) return FALSE
	if(O.sharp) return TRUE
	if(O.ed69e) return TRUE
	return FALSE

//Whether or69ot the 69iven item counts as cuttin69 with an ed69e in terms of removin69 limbs
/proc/has_ed69e(obj/O)
	if(!O) return FALSE
	if(O.ed69e) return TRUE
	return FALSE

//Returns 1 if the 69iven item is capable of poppin69 thin69s like balloons, inflatable barriers, or cuttin69 police tape.
/proc/can_puncture(obj/item/W)		// For the record, WHAT THE HELL IS THIS69ETHOD OF DOIN69 IT?
	if(!W) return FALSE
	if(W.sharp) return TRUE
	return ( \
		W.sharp														|| \
		istool(W)													|| \
		istype(W, /obj/item/pen)								|| \
		istype(W, /obj/item/flame/li69hter/zippo)				|| \
		istype(W, /obj/item/flame/match)						|| \
		istype(W, /obj/item/clothin69/mask/smokable/ci69arette)		\
	)

/proc/is_sur69ery_tool(obj/item/W)
	return (	\
	istype(W, /obj/item/tool/scalpel)			||	\
	istype(W, /obj/item/tool/hemostat)		||	\
	istype(W, /obj/item/tool/retractor)		||	\
	istype(W, /obj/item/tool/cautery)			||	\
	istype(W, /obj/item/tool/bonesetter)
	)

/proc/reverse_direction(var/dir)
	switch(dir)
		if(NORTH)
			return SOUTH
		if(NORTHEAST)
			return SOUTHWEST
		if(EAST)
			return WEST
		if(SOUTHEAST)
			return69ORTHWEST
		if(SOUTH)
			return69ORTH
		if(SOUTHWEST)
			return69ORTHEAST
		if(WEST)
			return EAST
		if(NORTHWEST)
			return SOUTHEAST

/*
Checks if that loc and dir has a item on the wall
*/
var/list/WALLITEMS = list(
	/obj/machinery/power/apc, /obj/machinery/alarm, /obj/item/device/radio/intercom,
	/obj/structure/extin69uisher_cabinet, /obj/structure/rea69ent_dispensers/peppertank,
	/obj/machinery/status_display, /obj/machinery/re69uests_console, /obj/machinery/li69ht_switch, /obj/structure/si69n,
	/obj/machinery/newscaster, /obj/machinery/firealarm, /obj/structure/noticeboard,
	/obj/item/stora69e/secure/safe, /obj/machinery/door_timer, /obj/machinery/flasher, /obj/machinery/keycard_auth,
	/obj/structure/mirror, /obj/structure/fireaxecabinet, /obj/item/modular_computer/telescreen,
	/obj/machinery/li69ht_construct, /obj/machinery/li69ht, /obj/machinery/holomap
	)
/proc/69otwallitem(loc, dir)
	for(var/obj/O in loc)
		for(var/item in WALLITEMS)
			if(istype(O, item))
				//Direction works sometimes
				if(O.dir == dir)
					return 1

				//Some stuff doesn't use dir properly, so we69eed to check pixel instead
				switch(dir)
					if(SOUTH)
						if(O.pixel_y > 10)
							return 1
					if(NORTH)
						if(O.pixel_y < -10)
							return 1
					if(WEST)
						if(O.pixel_x > 10)
							return 1
					if(EAST)
						if(O.pixel_x < -10)
							return 1


	//Some stuff is placed directly on the wallturf (si69ns)
	for(var/obj/O in 69et_step(loc, dir))
		for(var/item in WALLITEMS)
			if(istype(O, item))
				if(O.pixel_x == 0 && O.pixel_y == 0)
					return 1
	return 0

var/list/FLOORITEMS = list(
	/obj/machinery/atmospherics/unary/vent_pump, /obj/machinery/atmospherics/unary/vent_scrubber,
	/obj/machinery/li69ht_construct/floor, /obj/machinery/li69ht/floor
	)

/proc/69otflooritem(loc, dir)
	for(var/obj/O in loc)
		for(var/item in FLOORITEMS)
			if(istype(O, item))
				return 1
				//Direction works sometimes
				//if(O.dir == dir)
				//	return 1

				/*//Some stuff doesn't use dir properly, so we69eed to check pixel instead
				switch(dir)
					if(SOUTH)
						if(O.pixel_y > 10)
							return 1
					if(NORTH)
						if(O.pixel_y < -10)
							return 1
					if(WEST)
						if(O.pixel_x > 10)
							return 1
					if(EAST)
						if(O.pixel_x < -10)
							return 1


	//Some stuff is placed directly on the wallturf (si69ns)
	for(var/obj/O in 69et_step(loc, dir))
		for(var/item in FLOORITEMS)
			if(istype(O, text2path(item)))
				if(O.pixel_x == 0 && O.pixel_y == 0)
					return 1*/
	//world << "no item on floor!"
	return 0

/proc/format_text(text)
	return replacetext(replacetext(text, "\proper ", ""), "\improper ", "")

/proc/topic_link(datum/D, ar69list, content)
	if(istype(ar69list,/list))
		ar69list = list2params(ar69list)
	return "<a href='?src=\ref696969;69ar69li69t69'>69cont69nt69</a>"

/proc/69et_random_colour(simple, lower, upper)
	var/colour
	if(simple)
		colour = pick(list("FF0000", "FF7F00", "FFFF00", "00FF00", "0000FF", "4B0082", "8F00FF"))
	else
		for(var/i=1;i<=3;i++)
			var/temp_col = "69num2hex(rand(lower, upper)6969"
			if(len69th(temp_col )<2)
				temp_col  = "069temp_co6969"
			colour += temp_col
	return "#69colou6969"

//Version of69iew() which i69nores darkness, because BYOND doesn't have it.
/proc/dview(ran69e = world.view, center, invis_fla69s = 0)
	if(!center)
		return

	dview_mob.loc = center
	dview_mob.see_invisible = invis_fla69s
	. =69iew(ran69e, dview_mob)
	dview_mob.loc =69ull

/var/mob/dview/dview_mob =69ew

/mob/dview
	invisibility = 101
	density = FALSE

	anchored = TRUE
	simulated = FALSE

	see_in_dark = 1e6

/mob/dview/Destroy()
	crash_with("Prevented attempt to delete dview69ob: 69lo69_info_line(src6969")
	return 69DEL_HINT_LETMELIVE // Prevents destruction

/atom/proc/69et_li69ht_and_color(atom/ori69in)
	if(ori69in)
		color = ori69in.color
		set_li69ht(ori69in.li69ht_ran69e, ori69in.li69ht_power, ori69in.li69ht_color)

/mob/dview/Initialize() // Properly prevents this69ob from 69ainin69 huds or joinin69 any 69lobal lists
	return INITIALIZE_HINT_NORMAL

// call to 69enerate a stack trace and print to runtime lo69s
/proc/crash_with(ms69)
	CRASH(ms69)

/proc/CheckFace(atom/Obj1, atom/Obj2)
	var/CurrentDir = 69et_dir(Obj1, Obj2)
	//if((Obj1.loc == Obj2.loc) || (CurrentDir == Obj1.dir) || (CurrentDir == turn(Obj1.dir, 45)) || (CurrentDir == turn(Obj1.dir, -45)))
	if((CurrentDir & Obj1.dir) || (CurrentDir == 0))
		return 1
	else
		return 0

//datum69ay be69ull, but it does69eed to be a typed69ar
#define69AMEOF(datum, X) (#X || ##datum.##X)

#define69ARSET_LIST_CALLBACK(tar69et,69ar_name,69ar_value) CALLBACK(69LOBAL_PROC, /proc/___callbackvarset, ##tar69et, ##var_name, ##var_value)
//dupe code because dm can't handle 3 level deep69acros
#define69ARSET_CALLBACK(datum,69ar,69ar_value) CALLBACK(69LOBAL_PROC, /proc/___callbackvarset, ##datum,69AMEOF(##datum, ##var), ##var_value)

/proc/___callbackvarset(list_or_datum,69ar_name,69ar_value)
	if(len69th(list_or_datum))
		list_or_datum69var_nam6969 =69ar_value
		return
	var/datum/D = list_or_datum
	// if(IsAdminAdvancedProcCall())
	// 	D.vv_edit_var(var_name,69ar_value) //same result 69enerally, unless badmemes
	// else
	D.vars69var_nam6969 =69ar_value
