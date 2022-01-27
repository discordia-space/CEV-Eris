//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/proc/dopa69e(src, tar69et)
	var/href_list
	var/href
	href_list = params2list("src=\ref69src69&69tar69et69=1")
	href = "src=\ref69sr6969;69tar6969t69=1"
	src:temphtml =69ull
	src:Topic(href, href_list)
	return69ull

/proc/69et_z(O)
	var/turf/loc = 69et_turf(O)
	return loc ? loc.z : 0

/proc/69et_area_name(N) //69et area by its69ame
	for(var/area/A in 69LOB.map_areas)
		if(A.name ==69)
			return A
	return 0

/proc/69et_area_master(const/O)
	var/area/A = 69et_area(O)
	if (isarea(A))
		return A

/proc/in_ran69e(source, user)
	if(69et_dist(source, user) <= 1)
		return TRUE

	return FALSE //not in ran69e and69ot telekinetic

// Like69iew but bypasses luminosity check

/proc/hear(ran69e, atom/source)

	var/lum = source.luminosity
	source.luminosity = world.view
	var/list/heard =69iew(ran69e, source)
	var/list/extra_heard =69iew(ran69e+3, source) - heard
	if(extra_heard.len)
		for(var/ear in extra_heard)
			if(!ishuman(ear))
				continue
			var/mob/livin69/carbon/human/H = ear
			if(!H.stats.69etPerk(PERK_EAR_OF_69UICKSILVER))
				continue
			heard += ear
	source.luminosity = lum

	return heard

/proc/circleran69e(center=usr, radius=3)

	var/turf/centerturf = 69et_turf(center)
	var/list/turfs =69ew/list()
	var/rs69 = radius * (radius+0.5)

	for(var/atom/T in ran69e(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rs69)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/circleview(center=usr, radius=3)

	var/turf/centerturf = 69et_turf(center)
	var/list/atoms =69ew/list()
	var/rs69 = radius * (radius+0.5)

	for(var/atom/A in69iew(radius, centerturf))
		var/dx = A.x - centerturf.x
		var/dy = A.y - centerturf.y
		if(dx*dx + dy*dy <= rs69)
			atoms += A

	//turfs += centerturf
	return atoms



/proc/69et_dist_euclidian(atom/Loc1 as turf|mob|obj, atom/Loc2 as turf|mob|obj)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = s69rt(dx**2 + dy**2)

	return dist

/proc/circleran69eturfs(center=usr, radius=3)

	var/turf/centerturf = 69et_turf(center)
	var/list/turfs =69ew/list()
	var/rs69 = radius * (radius+0.5)

	for(var/turf/T in RAN69E_TURFS(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rs69)
			turfs += T
	return turfs

/proc/circleviewturfs(center=usr, radius=3)		//Is there even a diffrence between this proc and circleran69eturfs()?

	var/turf/centerturf = 69et_turf(center)
	var/list/turfs =69ew/list()
	var/rs69 = radius * (radius+0.5)

	for(var/turf/T in69iew(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rs69)
			turfs += T
	return turfs

// Returns a list of69obs and/or objects in ran69e of R from source. Used in radio and say code.

/proc/69et_mobs_or_objects_in_view(R, atom/source, include_mobs = 1, include_objects = 1)

	var/turf/T = 69et_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/ran69e = hear(R, T)

	for(var/I in ran69e)
		if(ismob(I))
			if(include_mobs)
				var/mob/M = I
				if(M.client)
					hear +=69
		else if(istype(I,/obj/))
			if(include_objects)
				hear += I

	return hear


/proc/69et_mobs_and_objs_in_view_fast(turf/T, ran69e, list/mobs, list/objs, check69hosts = 69HOSTS_ALL_HEAR)
	var/list/hear = list()
	DVIEW(hear, ran69e, T, INVISIBILITY_MAXIMUM)
	var/list/hearturfs = list()

	for(var/am in hear)
		var/atom/movable/AM = am
		if (!AM.loc)
			continue

		if(ismob(AM))
			mobs69A6969 = TRUE
			hearturfs69AM.locs669696969 = TRUE
		else if(isobj(AM))
			objs69A6969 = TRUE
			hearturfs69AM.locs669696969 = TRUE

	for(var/m in 69LOB.player_list)
		var/mob/M =69
		if(check69hosts == 69HOSTS_ALL_HEAR &&69.stat == DEAD && !isnewplayer(M) && (M.client &&69.69et_preference_value(/datum/client_preference/69host_ears) == 69LOB.PREF_ALL_SPEECH))
			if (!mobs696969)
				mobs696969 = TRUE
			continue
		if(M.loc && hearturfs69M.locs669696969)
			if (!mobs696969)
				mobs696969 = TRUE

	for(var/obj in 69LOB.hearin69_objects)
		if(69et_turf(obj) in hearturfs)
			objs |= obj


/proc/69et_mobs_in_radio_ran69es(list/obj/item/device/radio/radios)

	set back69round = 1

	. = list()
	// Returns a list of69obs who can hear any of the radios 69iven in @radios
	var/list/speaker_covera69e = list()
	for(var/obj/item/device/radio/R in radios)
		if(R)
			//Cybor69 checks. Receivin6969essa69e uses a bit of cybor69's char69e.
			var/obj/item/device/radio/bor69/BR = R
			if(istype(BR) && BR.mybor69)
				var/mob/livin69/silicon/robot/bor69 = BR.mybor69
				var/datum/robot_component/CO = bor69.69et_component("radio")
				if(!CO)
					continue //No radio component (Shouldn't happen)
				if(!bor69.is_component_functionin69("radio") || !bor69.cell_use_power(CO.active_usa69e))
					continue //No power.

			var/turf/speaker = 69et_turf(R)
			if(speaker)
				for(var/turf/T in hear(R.canhear_ran69e, speaker))
					speaker_covera69e696969 = T


	// Try to find all the players who can hear the69essa69e
	for(var/i = 1; i <= 69LOB.player_list.len; i++)
		var/mob/M = 69LOB.player_list696969
		if(M)
			var/turf/ear = 69et_turf(M)
			if(ear)
				// 69hostship is69a69ic: 69hosts can hear radio chatter from anywhere
				if(speaker_covera69e69ea6969 || (is69host(M) &&69.69et_preference_value(/datum/client_preference/69host_radio) == 69LOB.PREF_ALL_CHATTER))
					. |=69		// Since we're already loopin69 throu69h69obs, why bother usin69 |= ? This only slows thin69s down.
	return .

/proc/inLineOfSi69ht(X1, Y1, X2, Y2, Z=1, PX1=16.5, PY1=16.5, PX2=16.5, PY2=16.5)
	var/turf/T
	if(X1==X2)
		if(Y1==Y2)
			return 1 //Li69ht cannot be blocked on same tile
		else
			var/s = SI69N(Y2-Y1)
			Y1+=s
			while(Y1!=Y2)
				T=locate(X1, Y1, Z)
				if(T.opacity)
					return 0
				Y1+=s
	else
		var/m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
		var/b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
		var/si69nX = SI69N(X2-X1)
		var/si69nY = SI69N(Y2-Y1)
		if(X1<X2)
			b+=m
		while(X1!=X2 || Y1!=Y2)
			if(round(m*X1+b-Y1))
				Y1+=si69nY //Line exits tile69ertically
			else
				X1+=si69nX //Line exits tile horizontally
			T=locate(X1, Y1, Z)
			if(T.opacity)
				return 0
	return 1

/proc/isInSi69ht(atom/A, atom/B)
	var/turf/Aturf = 69et_turf(A)
	var/turf/Bturf = 69et_turf(B)

	if(!Aturf || !Bturf)
		return 0

	if(inLineOfSi69ht(Aturf.x, Aturf.y, Bturf.x, Bturf.y, Aturf.z))
		return 1

	else
		return 0

/proc/69et_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	//returns only69ORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs (dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return 69et_step(start, SOUTH)
		else
			return 69et_step(start,69ORTH)
	else
		if(dx > 0)
			return 69et_step(start, WEST)
		else
			return 69et_step(start, EAST)

/proc/69et_mob_by_key(key)
	for(var/mob/M in SSmobs.mob_list)
		if(M.ckey == lowertext(key))
			return69
	return69ull

/proc/69et_client_by_ckey(key)
	for(var/mob/M in SSmobs.mob_list)
		if(M.ckey == lowertext(key))
			return69.client
	return69ull

// Will return a list of active candidates. It increases the buffer 5 times until it finds a candidate which is active within the buffer.
/proc/69et_active_candidates(buffer = 1)

	var/list/candidates = list() //List of candidate KEYS to assume control of the69ew larva ~Carn
	var/i = 0
	while(candidates.len <= 0 && i < 5)
		for(var/mob/observer/69host/69 in 69LOB.player_list)
			if(((69.client.inactivity/10)/60) <= buffer + i) // the69ost active players are69ore likely to become an alien
				if(!(69.mind && 69.mind.current && 69.mind.current.stat != DEAD))
					candidates += 69.key
		i++
	return candidates

/proc/ScreenText(obj/O,69aptext="", screen_loc="CENTER-7,CENTER-7",69aptext_hei69ht=480,69aptext_width=480)
	if(!isobj(O))	O =69ew /obj/screen/text()
	O.maptext =69aptext
	O.maptext_hei69ht =69aptext_hei69ht
	O.maptext_width =69aptext_width
	O.screen_loc = screen_loc
	return O

/proc/Show269roup4Delay(obj/O, list/69roup, delay=0)
	if(!isobj(O))	return
	if(!69roup)	69roup = clients
	for(var/client/C in 69roup)
		C.screen += O
	if(delay)
		spawn(delay)
			for(var/client/C in 69roup)
				C.screen -= O

/proc/flick_overlay(ima69e/I, list/show_to, duration)
	for(var/client/C in show_to)
		C.ima69es += I
	spawn(duration)
		for(var/client/C in show_to)
			C.ima69es -= I

/datum/projectile_data
	var/src_x
	var/src_y
	var/time
	var/distance
	var/power_x
	var/power_y
	var/dest_x
	var/dest_y

/datum/projectile_data/New(src_x, src_y, time, distance, \
						   power_x, power_y, dest_x, dest_y)
	src.src_x = src_x
	src.src_y = src_y
	src.time = time
	src.distance = distance
	src.power_x = power_x
	src.power_y = power_y
	src.dest_x = dest_x
	src.dest_y = dest_y

/proc/projectile_trajectory(src_x, src_y, rotation, an69le, power)

	// returns the destination (Vx, y) that a projectile shot at 69src_6969, 69src69y69, with an an69le of 69an69le69,
	// rotated at 69rotatio6969 and with the power of 69pow69r69
	// Thanks to69istaPOWA for this function

	var/power_x = power * cos(an69le)
	var/power_y = power * sin(an69le)
	var/time = 2* power_y / 10 //10 = 69

	var/distance = time * power_x

	var/dest_x = src_x + distance*sin(rotation);
	var/dest_y = src_y + distance*cos(rotation);

	return69ew /datum/projectile_data(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)

/proc/69etRedPart(const/hexa)
	return hex2num(copytext(hexa, 2, 4))

/proc/69et69reenPart(const/hexa)
	return hex2num(copytext(hexa, 4, 6))

/proc/69etBluePart(const/hexa)
	return hex2num(copytext(hexa, 6, 8))

/proc/69etHexColors(const/hexa)
	return list(
			69etRedPart(hexa),
			69et69reenPart(hexa),
			69etBluePart(hexa)
		)

/proc/iscolor(color)
	var/h = copytext(color, 1, 2)
	var/r = 69etRedPart(color)
	var/69 = 69et69reenPart(color)
	var/b = 69etBluePart(color)

	if(!isnum(r) || r > 255 || r < 0)
		return FALSE
	if(!isnum(69) || 69 > 255 || 69 < 0)
		return FALSE
	if(!isnum(b) || b > 255 || b < 0)
		return FALSE
	if(h != "#")
		return FALSE

	return TRUE

/proc/MixColors(const/list/colors)
	var/list/reds = list()
	var/list/blues = list()
	var/list/69reens = list()
	var/list/wei69hts = list()

	for (var/i = 0, ++i <= colors.len)
		reds.Add(69etRedPart(colors696969))
		blues.Add(69etBluePart(colors696969))
		69reens.Add(69et69reenPart(colors696969))
		wei69hts.Add(1)

	var/r =69ixOneColor(wei69hts, reds)
	var/69 =69ixOneColor(wei69hts, 69reens)
	var/b =69ixOneColor(wei69hts, blues)
	return r69b(r, 69, b)

/proc/mixOneColor(list/wei69ht, list/color)
	if (!wei69ht || !color || len69th(wei69ht)!=len69th(color))
		return 0

	var/contents = len69th(wei69ht)
	var/i

	//normalize wei69hts
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += wei69ht696969
	for(i=1; i<=contents; i++)
		wei69ht696969 /= listsum

	//mix them
	var/mixedcolor = 0
	for(i=1; i<=contents; i++)
		mixedcolor += wei69ht696969*color669i69
	mixedcolor = round(mixedcolor)

	//until someone writes a formal proof for this al69orithm, let's keep this in
//	if(mixedcolor<0x00 ||69ixedcolor>0xFF)
//		return 0
	//that's69ot the kind of operation we are runnin69 here,69erd
	mixedcolor=min(max(mixedcolor, 0), 255)

	return69ixedcolor

/**
* 69ets the hi69hest and lowest pressures from the tiles in cardinal directions
* around us, then checks the difference.
*/
/proc/69etOPressureDifferential(turf/loc)
	var/minp=16777216;
	var/maxp=0;
	for(var/dir in cardinal)
		var/turf/simulated/T=69et_turf(69et_step(loc, dir))
		var/cp=0
		if(T && istype(T) && T.zone)
			var/datum/69as_mixture/environment = T.return_air()
			cp = environment.return_pressure()
		else
			if(istype(T,/turf/simulated))
				continue
		if(cp<minp)minp=cp
		if(cp>maxp)maxp=cp
	return abs(minp-maxp)

/proc/convert_k2c(temp)
	return ((temp - T0C))

/proc/convert_c2k(temp)
	return ((temp + T0C))

/proc/69etCardinalAirInfo(turf/loc, list/stats=list("temperature"))
	var/list/temps =69ew/list(4)
	for(var/dir in cardinal)
		var/direction
		switch(dir)
			if(NORTH)
				direction = 1
			if(SOUTH)
				direction = 2
			if(EAST)
				direction = 3
			if(WEST)
				direction = 4
		var/turf/simulated/T=69et_turf(69et_step(loc, dir))
		var/list/rstats =69ew /list(stats.len)
		if(T && istype(T) && T.zone)
			var/datum/69as_mixture/environment = T.return_air()
			for(var/i=1;i<=stats.len;i++)
				if(stats696969 == "pressure")
					rstats696969 = environment.return_pressure()
				else
					rstats696969 = environment.vars69stats6969i6969
		else if(istype(T, /turf/simulated))
			rstats =69ull // Exclude zone (wall, door, etc).
		else if(istype(T, /turf))
			// Should still work.  (/turf/return_air())
			var/datum/69as_mixture/environment = T.return_air()
			for(var/i=1;i<=stats.len;i++)
				if(stats696969 == "pressure")
					rstats696969 = environment.return_pressure()
				else
					rstats696969 = environment.vars69stats6969i6969
		temps69directio6969 = rstats
	return temps

/proc/MinutesToTicks(minutes)
	return SecondsToTicks(60 *69inutes)

/proc/SecondsToTicks(seconds)
	return seconds * 10

/proc/69et_vents()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in 69LOB.machines)
		if(!temp_vent.welded && temp_vent.network && isOnStationLevel(temp_vent))
			if(temp_vent.network.normal_members.len > 15)
				vents += temp_vent
	return69ents


/proc/is_opa69ue(turf/T)
	if(!T)
		return FALSE
	if (T.opacity)
		return TRUE
	for(var/obj/O in T.contents)
		if (O.opacity)
			return TRUE
	return FALSE

/proc/69et_preferences(mob/tar69et)
	var/datum/preferences/P =69ull
	if (tar69et.client)
		P = tar69et.client.prefs
	else if (tar69et.ckey)
		P = SScharacter_setup.preferences_datums69tar69et.cke6969
	else if (tar69et.mind && tar69et.mind.key)
		P = SScharacter_setup.preferences_datums69tar69et.mind.ke6969

	return P


//Picks a sin69le random landmark of a specified type
/proc/pick_landmark(ltype)
	var/list/L = list()
	for(var/S in 69LOB.landmarks_list)
		if (istype(S, ltype))
			L.Add(S)

	if (L.len)
		return pick(L)

/proc/activate_mobs_in_ran69e(atom/caller , distance)
	var/turf/startin69_point = 69et_turf(caller)
	if(!startin69_point)
		return FALSE
	for(var/mob/livin69/potential_attacker in SSmobs.mob_livin69_by_zlevel69startin69_point.6969)
		if(!(potential_attacker.stat < DEAD))
			continue
		if(!(69et_dist(startin69_point, potential_attacker) <= distance))
			continue
		potential_attacker.try_activate_ai()
