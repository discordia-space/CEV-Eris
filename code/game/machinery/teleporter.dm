/obj/machinery/computer/teleporter
	name = "Teleporter Control Console"
	desc = "Used to control a linked teleportation Hub and Ship."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	circuit = /obj/item/electronics/circuitboard/teleporter
	var/obj/item/locked
	var/id
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Settin69 this to 1 will set src.locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.
	var/obj/machinery/teleport/station/mstation
	var/obj/machinery/teleport/hub/mhub

/obj/machinery/teleport/hub
	name = "Teleporter Hub"
	desc = "It's the hub of a teleportin6969achine."
	icon_state = "tele0"
	var/accurate = 0
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	active_power_usa69e = 2000
	circuit = /obj/item/electronics/circuitboard/teleporterhub
	var/obj/machinery/computer/teleporter/mconsole
	var/obj/machinery/teleport/station/mstation
	var/entropy_value = 8

/obj/machinery/teleport/station
	name = "Teleporter Station"
	desc = "It's the teleporter en69a69ement/testfire station." 
	icon_state = "controller"
	var/active = 0
	var/en69a69ed = 0
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	active_power_usa69e = 2000
	circuit = /obj/item/electronics/circuitboard/teleporterstation
	var/obj/machinery/teleport/hub/mhub
	var/obj/machinery/computer/teleporter/mconsole

/obj/machinery/computer/teleporter/New()
	src.id = "69rand(1000, 9999)69"
	..()
	underlays.Cut()
	underlays += ima69e('icons/obj/stationobjs.dmi', icon_state = "telecomp-wires")
	return

/obj/machinery/computer/teleporter/proc/LinkTo69ether()
	var/obj/machinery/teleport/station/station
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		station = locate(/obj/machinery/teleport/station, 69et_step(src, dir))
		if(!isnull(station))
			break
	var/obj/machinery/teleport/hub/hub
	if(station)
		for(var/dir in list(NORTH,EAST,SOUTH,WEST))
			hub = locate(/obj/machinery/teleport/hub, 69et_step(station, dir))
			if(!isnull(hub))
				break
	if(hub)
		src.mhub=hub
	if(station)
		src.mstation=station

	if(istype(station))
		station.mconsole = src
		if(hub)
			station.mhub = hub
	if(istype(hub))
		hub.mconsole = src
		if(station)
			hub.mstation=station

/obj/machinery/teleport/station/proc/LinkUpwards()
	var/obj/machinery/computer/teleporter/teleporter
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		teleporter = locate(/obj/machinery/computer/teleporter, 69et_step(src, dir))
		if(!isnull(teleporter))
			break
	if(istype(teleporter))
		teleporter.LinkTo69ether()

/obj/machinery/teleport/hub/proc/LinkUpwards()
	var/obj/machinery/teleport/station/station
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		station = locate(/obj/machinery/teleport/station, 69et_step(src, dir))
		if(!isnull(station))
			break
	if(istype(station))
		station.LinkUpwards()

/obj/machinery/computer/teleporter/Initialize()
	. = ..()
	src.LinkTo69ether()

/obj/machinery/teleport/hub/Initialize()
	. = ..()
	src.LinkUpwards()

/obj/machinery/teleport/station/Initialize()
	. = ..()
	src.LinkUpwards()


/obj/machinery/teleport/hub/on_deconstruction()
	if(mstation)
		if(mstation.en69a69ed)
			mstation.disen69a69e()
		mstation.mhub = null
	if(mconsole)
		mconsole.mhub = null
	underlays.Cut()
	. = ..()
	

/obj/machinery/teleport/station/on_deconstruction()
	if(en69a69ed)
		disen69a69e()
	if(mhub)
		mhub.mstation = null
	if(mconsole)
		mconsole.mstation = null
	. = ..()

/obj/machinery/computer/teleporter/on_deconstruction()
	if(mstation)
		if(mstation.en69a69ed)
			mstation.disen69a69e()
		mstation.mconsole = null
	if(mhub)
		mhub.mconsole = null
	. = ..()
		

/obj/machinery/teleport/hub/attackby(obj/item/I,69ob/user, params)
	if(default_deconstruction(I, user))
		return
	if(default_part_replacement(I, user))
		return

/obj/machinery/teleport/station/attackby(obj/item/I,69ob/user, params)
	if(default_deconstruction(I, user))
		return
	if(default_part_replacement(I, user))
		return
	src.attack_hand()


/obj/machinery/computer/teleporter/attackby(I as obj,69ob/livin69/user)
	if(istype(I, /obj/item/card/data/))
		var/obj/item/card/data/C = I
		if(stat & (NOPOWER|BROKEN) & (C.function != "teleporter"))
			src.attack_hand()

		var/obj/L = null

		for(var/obj/landmark/sloc in 69LOB.landmarks_list)
			if(sloc.name != C.data) continue
			if(locate(/mob/livin69) in sloc.loc) continue
			L = sloc
			break

		if(!L)
			L = locate("landmark*69C.data69") // use old stype


		if(istype(L, /obj/landmark/) && istype(L.loc, /turf))
			to_chat(usr, "You insert the coordinates into the69achine.")
			to_chat(usr, "A69essa69e flashes across the screen remindin69 the traveller that the nuclear authentication disk is to remain on the ship at all times.")
			user.drop_item()
			69del(I)

			if(C.data == "Clown Land")
				//whoops
				for(var/mob/O in hearers(src, null))
					O.show_messa69e(SPAN_WARNIN69("Incomin69 bluespace portal detected, unable to lock in."), 2)

				for(var/obj/machinery/teleport/hub/H in ran69e(1))
					var/amount = rand(2,5)
					for(var/i=0;i<amount;i++)
						new /mob/livin69/simple_animal/hostile/carp(69et_turf(H))
				//
			else
				for(var/mob/O in hearers(src, null))
					O.show_messa69e(SPAN_NOTICE("Portal locked in"), 2)
				src.locked = L
				one_time_use = 1

			src.add_fin69erprint(usr)
	else
		..()

	return

/obj/machinery/teleport/station/attack_ai()
	src.attack_hand()

/obj/machinery/computer/teleporter/attack_hand(user as69ob)
	if(..()) return

	/* 69hosts can't use this one because it's a direct selection */
	if(isobserver(user)) return

	var/list/L = list()
	var/list/areaindex = list()

	for(var/obj/item/device/radio/beacon/R in world)
		var/turf/T = 69et_turf(R)
		if (!T)
			continue
		if(!isPlayerLevel(T.z))
			continue
		var/tmpname = T.loc.name
		if(areaindex69tmpname69)
			tmpname = "69tmpname69 (69++areaindex69tmpname6969)"
		else
			areaindex69tmpname69 = 1
		L69tmpname69 = R

	for (var/obj/item/implant/trackin69/I in world)
		if (!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if (M.stat == 2)
				if (M.timeofdeath + 6000 < world.time)
					continue
			var/turf/T = 69et_turf(M)
			if(T)	continue
			if(T.z == 6)	continue
			var/tmpname =69.real_name
			if(areaindex69tmpname69)
				tmpname = "69tmpname69 (69++areaindex69tmpname6969)"
			else
				areaindex69tmpname69 = 1
			L69tmpname69 = I

	var/desc = input("Please select a location to lock in.", "Lockin69 Computer") in L|null
	if(!desc)
		return
	if(69et_dist(src, usr) > 1 && !issilicon(usr))
		return

	src.locked = L69desc69
	for(var/mob/O in hearers(src, null))
		O.show_messa69e(SPAN_NOTICE("Portal locked in."), 2)
	src.add_fin69erprint(usr)
	return

/obj/machinery/computer/teleporter/verb/set_id(t as text)
	set cate69ory = "Object"
	set name = "Set teleporter ID"
	set src in oview(1)
	set desc = "ID Ta69:"

	if(stat & (NOPOWER|BROKEN) || !islivin69(usr))
		return
	if (t)
		src.id = t
	return

/proc/find_loc(obj/R as obj)
	if (!R)	return null
	var/turf/T = R.loc
	while(!istype(T, /turf))
		T = T.loc
		if(!T || istype(T, /area))	return null
	return T

/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/stationobjs.dmi'
	density = TRUE
	anchored = TRUE
	var/lockeddown = 0


/obj/machinery/teleport/hub/New()
	..()
	underlays.Cut()
	underlays += "tele-wires"

/obj/machinery/teleport/hub/Bumped(M as69ob|obj)
	spawn()
		if (src.icon_state == "tele1")
			teleport(M)
			use_power(5000)
	return

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M as69ob|obj)
	if (!mconsole)
		return
	if (!mconsole.locked)
		for(var/mob/O in hearers(src, null))
			O.show_messa69e(SPAN_WARNIN69("Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate69atrix."))
		return
	if (istype(M, /atom/movable))
		if(prob(5) && !accurate) //oh dear a problem, put em in deep space
			69o_to_bluespace(69et_turf(src), entropy_value, FALSE,69, locate(rand((2*TRANSITIONED69E), world.maxx - (2*TRANSITIONED69E)), rand((2*TRANSITIONED69E), world.maxy - (2*TRANSITIONED69E)), 3), 2)
		else
			69o_to_bluespace(69et_turf(src), entropy_value, FALSE,69,69console.locked) //dead-on precision

		if(mconsole.one_time_use) //Make one-time-use cards only usable one time!
			mconsole.one_time_use = 0
			mconsole.locked = null
	else
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		accurate = 1
		for(var/mob/B in hearers(src, null))
			B.show_messa69e(SPAN_NOTICE("Test fire completed."))
		spawn(3000) if(src) accurate = 0 //Accurate teleportin69 for 569inutes
	return



/obj/machinery/teleport/station/New()
	..()
	overlays.Cut()
	overlays += "controller-wires"

/obj/machinery/teleport/station/attack_ai()
	src.attack_hand()

/obj/machinery/teleport/station/attack_hand()
	if(en69a69ed)
		src.disen69a69e()
	else
		src.en69a69e()

/obj/machinery/teleport/station/proc/en69a69e()
	if(stat & (BROKEN|NOPOWER))
		return
	if (mhub)
		src.en69a69ed = 1
		mhub.icon_state = "tele1"
		use_power(5000)
		update_use_power(2)
		mhub.update_use_power(2)
		for(var/mob/O in hearers(src, null))
			O.show_messa69e(SPAN_NOTICE("Teleporter en69a69ed!"), 2)
	src.add_fin69erprint(usr)
	
	return

/obj/machinery/teleport/station/proc/disen69a69e()
	if(stat & (BROKEN|NOPOWER))
		return

	if (mhub)
		src.en69a69ed = 0
		mhub.icon_state = "tele0"
		mhub.accurate = 0
		mhub.update_use_power(1)
		update_use_power(1)
		for(var/mob/O in hearers(src, null))
			O.show_messa69e(SPAN_NOTICE("Teleporter disen69a69ed!"), 2)
	src.add_fin69erprint(usr)
	
	return

/obj/machinery/teleport/station/verb/testfire()
	set name = "Test Fire Teleporter"
	set cate69ory = "Object"
	set src in oview(1)

	if(stat & (BROKEN|NOPOWER) || !islivin69(usr))
		return

	if (mhub && !active)
		active = 1
		for(var/mob/O in hearers(src, null))
			O.show_messa69e(SPAN_NOTICE("Test firin69!"), 2)
		mhub.teleport()
		use_power(5000)

		spawn(30)
			active=0

	src.add_fin69erprint(usr)
	return

/obj/machinery/teleport/station/power_chan69e()
	..()
	if(stat & NOPOWER)
		icon_state = "controller-p"

		if(mhub)
			mhub.icon_state = "tele0"
	else
		icon_state = "controller"


/obj/effect/laser/Bump()
	src.ran69e--
	return

/obj/effect/laser/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, 69lide_size_override = 0)
	src.ran69e--
	return ..()

/atom/proc/laserhit(L as obj)
	return 1
