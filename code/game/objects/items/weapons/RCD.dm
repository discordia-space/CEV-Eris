//Contains the rapid construction device.
/obj/item/rcd
	name = "rapid construction device"
	desc = "A device used to rapidly build walls and floors."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rcd"
	opacity = 0
	density = FALSE
	anchored = FALSE
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASMA = 10, MATERIAL_URANIUM = 10)
	price_tag = 2000
	spawn_blacklisted = TRUE//antag_item_targets
	var/datum/effect/effect/system/spark_spread/spark_system
	var/max_stored_matter = 30
	var/stored_matter = 0
	var/working = 0
	var/mode = 1
	var/list/modes = list("Floor & Walls","Low wall", "Airlock","Deconstruct")
	var/disabled = 0

/obj/item/rcd/attack()
	return 0

/obj/item/rcd/proc/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && user.get_active_hand() == src && !user.stat && !user.restrained())

/obj/item/rcd/examine(mob/user, extra_description = "")
	if(get_dist(user, src) < 2)
		extra_description += "It holds [stored_matter] out of [max_stored_matter] charges."
	..(user, extra_description)

/obj/item/rcd/New()
	..()
	src.spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	update_icon()	//Initializes the fancy ammo counter

/obj/item/rcd/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/rcd/attackby(obj/item/W, mob/user)
	var/obj/item/stack/material/M = W
	if(istype(M) && M.material.name == MATERIAL_COMPRESSED)
		var/amount = min(M.get_amount(), round(max_stored_matter - stored_matter))
		if(M.use(amount) && stored_matter < max_stored_matter)
			stored_matter += amount
			playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You load [amount] Compressed Matter into \the [src]</span>.")
			update_icon()	//Updates the ammo counter
	else
		..()

/obj/item/rcd/attack_self(mob/user)
	//Change the mode
	if(++mode > modes.len) mode = 1
	to_chat(user, SPAN_NOTICE("Changed mode to '[modes[mode]]'"))
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	if(prob(20)) src.spark_system.start()

/obj/item/rcd/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(disabled && !isrobot(user))
		return 0
	if(istype(get_area(A),/area/shuttle)||istype(get_area(A),/turf/space/transit))
		return 0
	return alter_turf(A,user)

/obj/item/rcd/proc/useResource(var/amount, var/mob/user, var/checkOnly)
	if(stored_matter < amount)
		return 0
	if (!checkOnly)
		stored_matter -= amount
		update_icon()	//Updates the ammo counter if ammo is succesfully used
	return 1

/obj/item/rcd/proc/alter_turf(var/T,var/mob/user)

	var/build_cost = 0
	var/build_type
	var/build_turf
	var/build_object
	var/build_delay

	if(working == 1)
		return 0
	var/turf/local_turf = T
	if(!T)
		local_turf = get_turf(T)
	var/gotFloor = istype(local_turf,/turf/floor)
	var/gotSpace = (istype(local_turf,/turf/space) || istype(local_turf,get_base_turf(local_turf.z)))
	var/gotBlocked = (istype(T, /obj/machinery/door/airlock))

	switch(mode)
		if(1)
			if(gotSpace)
				build_cost =  1
				build_type =  "floor"
				build_turf =  /turf/floor/airless
			if(gotFloor)
				build_delay = 40
				build_cost =  3
				build_type =  "wall"
				build_turf =  /turf/wall
		if(2)
			if(gotSpace)
				build_cost =  1
				build_type =  "floor"
				build_turf =  /turf/floor/airless
			if(gotFloor)
				build_delay = 40
				build_cost =  3
				build_type =  "low wall"
				build_turf =  /turf/wall/low
		if(3)
			if(gotBlocked)
				return 0
			if(gotSpace)
				build_type = "airlock"
				build_cost =  7
				build_delay = 50
				build_turf =  /turf/floor/airless
				build_object = /obj/machinery/door/airlock
			if(gotFloor)
				build_type = "airlock"
				build_cost =  6
				build_delay = 40
				build_object = /obj/machinery/door/airlock

		if(4)
			build_type =  "deconstruct"
			if(gotFloor)
				build_cost =  5
				build_delay = 50
				build_turf = get_base_turf(local_turf.z)
			else if(istype(T,/turf/wall))
				var/turf/wall/W = T
				build_delay = 40
				build_cost =  W.is_reinforced
				build_turf =  /turf/floor
			else if(istype(T,/obj/machinery/door/airlock))
				build_cost =  10
				build_delay = 50
			else
				build_type =  ""

	if(!build_type)
		working = 0
		return 0

	if(!useResource(build_cost, user, 1))
		to_chat(user, "The \'Low Ammo\' light on the device blinks yellow.")
		flick("[icon_state]-empty", src)
		return 0

	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)

	working = 1
	to_chat(user, "[(mode==modes.len ? "Deconstructing" : "Building [build_type]")]...")

	if(build_delay && !do_after(user, build_delay, src))
		working = 0
		return 0

	working = 0
	if(build_delay && !can_use(user,T))
		return 0

	if(!useResource(build_cost, user))
		to_chat(user, "The \'Low Ammo\' light on the device blinks yellow.")
		flick("[icon_state]-empty", src)
		return 0

	if(build_turf)
		local_turf.ChangeTurf(build_turf)
	if(build_object)
		new build_object(local_turf)

	if(build_type == "deconstruct")
		qdel(T)

	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	return 1

/obj/item/rcd/update_icon()	//For the fancy "ammo" counter
	cut_overlays()

	var/ratio = 0
	ratio = stored_matter / 30	//30 is the hardcoded max capacity of the RCD
	ratio = max(round(ratio, 0.10) * 100, 10)

	overlays += "[icon_state]-[ratio]"

/obj/item/rcd/borg
	spawn_tags = null

/obj/item/rcd/borg/useResource(var/amount, mob/user, var/checkOnly)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			var/cost = amount*30
			if(R.cell.charge >= cost)
				if (!checkOnly)
					R.cell.use(cost)
				return 1
	return 0

/obj/item/rcd/borg/attackby()
	return

/obj/item/rcd/borg/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat)

/obj/item/rcd/mounted
	spawn_tags = null//mech item

/obj/item/rcd/mounted/useResource(var/amount, mob/user, var/checkOnly)
	var/cost = amount*130 //so that a rig with default powercell can build ~2.5x the stuff a fully-loaded RCD can.
	/// RIG MOUNTED
	if(istype(loc,/obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(module.holder && module.holder.cell)
			if(module.holder.cell.charge >= cost)
				if (!checkOnly)
					module.holder.cell.use(cost)
				return TRUE
	/// MECH MOUNTED
	if(istype(loc, /obj/item/mech_equipment/mounted_system/rcd))
		var/mob/living/exosuit/mech = loc.loc
		if(!mech || !istype(mech))
			return FALSE
		var/obj/item/cell/power = mech.get_cell()
		if(power && power.charge >= cost)
			power.use(cost)
			return TRUE
	return FALSE

/obj/item/rcd/mounted/attackby()
	return

/obj/item/rcd/mounted/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat && !user.restrained())
