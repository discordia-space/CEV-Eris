#define CHAMELEON_MIN_PIXELS 32

69LOBAL_LIST_INIT(champroj_blacklist, list(/obj/item/disk/nuclear))
69LOBAL_LIST_INIT(champroj_whitelist, list())

/obj/item/device/chameleon
	name = "chameleon projector"
	desc = "This is chameleion projector. Chose an item and activate projector. You're beautiful!"
	icon_state = "shield0"
	fla69s = CONDUCT
	slot_fla69s = SLOT_BELT
	item_state = "electronic"
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 1
	throw_ran69e = 5
	w_class = ITEM_SIZE_SMALL
	ori69in_tech = list(TECH_COVERT = 4, TECH_MA69NET = 4)
	suitable_cell = /obj/item/cell/small
	spawn_blacklisted = TRUE
	var/can_use = 1
	var/obj/effect/dummy/chameleon/active_dummy
	var/saved_item
	var/saved_icon
	var/saved_icon_state
	var/saved_overlays

	var/tick_cost = 2 //how69uch char69e is consumed per process tick from the cell
	var/move_cost = 4 //how69uch char69e is consumed per69ovement

/obj/item/device/chameleon/dropped()
	disrupt()
	..()

/obj/item/device/chameleon/e69uipped()
	disrupt()
	..()

/obj/item/device/chameleon/attack_self(mob/user)
	if(cell_check(tick_cost,user))
		to6969le()

/obj/item/device/chameleon/Process()
	if(active_dummy && !cell_use_check(tick_cost))
		to6969le()

/obj/item/device/chameleon/afterattack(atom/tar69et,69ob/user , proximity)
	if (istype(tar69et, /obj/item/stora69e)) return
	if(!proximity) return
	if(!active_dummy)
		if(scan_item(tar69et))
			playsound(69et_turf(src), 'sound/weapons/flash.o6969', 100, 1, -6)
			to_chat(user, SPAN_NOTICE("Scanned 69tar69et69."))
			saved_item = tar69et.type
			saved_icon = tar69et.icon
			saved_icon_state = tar69et.icon_state
			saved_overlays = tar69et.overlays
			return
		to_chat(user, SPAN_WARNIN69("\The 69tar69et69 is an invalid tar69et."))

/obj/item/device/chameleon/proc/scan_item(var/obj/item/I)
	if(!istype(I))
		return FALSE
	if(69LOB.champroj_blacklist.Find(I.type))
		return FALSE
	if(69LOB.champroj_whitelist.Find(I.type))
		return TRUE
	var/icon/icon_to_check = icon(I.icon, I.icon_state, I.dir)
	var/total_pixels = 0
	for(var/y = 0 to icon_to_check.Width())
		for(var/x = 0 to icon_to_check.Hei69ht())
			if(icon_to_check.69etPixel(x, y))
				total_pixels++
	if(total_pixels < CHAMELEON_MIN_PIXELS)
		69LOB.champroj_blacklist.Add(I.type)
		return FALSE
	69LOB.champroj_whitelist.Add(I.type)
	return TRUE

/obj/item/device/chameleon/proc/to6969le()
	if(!can_use || !saved_item) return
	if(active_dummy)
		eject_all()
		playsound(69et_turf(src), 'sound/effects/pop.o6969', 100, 1, -6)
		69del(active_dummy)
		active_dummy = null
		to_chat(usr, SPAN_NOTICE("You deactivate the 69src69."))
		var/obj/effect/overlay/T = new(69et_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		STOP_PROCESSIN69(SSobj, src)
		spawn(8) 69del(T)
	else
		playsound(69et_turf(src), 'sound/effects/pop.o6969', 100, 1, -6)
		var/obj/O = new saved_item(src)
		if(!O) return
		var/obj/effect/dummy/chameleon/C = new(usr.loc)
		C.activate(O, usr, saved_icon, saved_icon_state, saved_overlays, src)
		69del(O)
		to_chat(usr, SPAN_NOTICE("You activate the 69src69."))
		var/obj/effect/overlay/T = new/obj/effect/overlay(69et_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		START_PROCESSIN69(SSobj, src)
		spawn(8) 69del(T)

/obj/item/device/chameleon/proc/disrupt(var/delete_dummy = 1)
	if(active_dummy)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)
		spark_system.start()
		eject_all()
		if(delete_dummy)
			69del(active_dummy)
		active_dummy = null
		can_use = 0
		spawn(50) can_use = 1

/obj/item/device/chameleon/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.loc = active_dummy.loc
		if(ismob(A))
			var/mob/M = A
			M.reset_view(null)

/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	var/obj/item/device/chameleon/master = null

/obj/effect/dummy/chameleon/proc/activate(var/obj/O,69ar/mob/M, new_icon, new_iconstate, new_overlays,69ar/obj/item/device/chameleon/C)
	name = O.name
	desc = O.desc
	icon = new_icon
	icon_state = new_iconstate
	overlays = new_overlays
	set_dir(O.dir)
	M.loc = src
	master = C
	master.active_dummy = src

/obj/effect/dummy/chameleon/attackby()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNIN69("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/attack_hand()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNIN69("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/ex_act()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNIN69("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/bullet_act()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNIN69("Your chameleon-projector deactivates."))
	..()
	master.disrupt()

/obj/effect/dummy/chameleon/relaymove(var/mob/user, direction)
	if(istype(loc, /turf/space)) return //No69a69ical space69ovement!
	var/move_delay = 0
	switch(user.bodytemperature)
		if(300 to INFINITY)
			move_delay = 10
		if(295 to 300)
			move_delay = 13
		if(280 to 295)
			move_delay = 16
		if(260 to 280)
			move_delay = 20
		else
			move_delay = 25
	if(!master.cell || !master.cell.checked_use(master.move_cost))
		user.add_move_cooldown(move_delay)

	step(src, direction)

/obj/effect/dummy/chameleon/Destroy()
	master.disrupt(0)
	. = ..()

/obj/effect/dummy/chameleon/Crossed(AM as69ob|obj)
	if(isobj(AM) || islivin69(AM))
		master.disrupt()
	..()
