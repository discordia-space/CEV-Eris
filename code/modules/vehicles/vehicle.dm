//Dummy object for holdin69 items in69ehicles.
//Prevents items from bein69 interacted with.
/datum/vehicle_dummy_load
	var/name = "dummy load"
	var/actual_load

/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	layer =69OB_LAYER + 0.1 //so it sits above objects includin6969obs
	density = TRUE
	anchored = TRUE
	animate_movement=1
	li69ht_ran69e = 3

	can_buckle = TRUE
	buckle_movable = 1
	buckle_lyin69 = 0

	var/attack_lo69 =69ull
	var/on = FALSE
	var/health = 0	//do69ot for69et to set health for your69ehicle!
	var/maxhealth = 0
	var/fire_dam_coeff = 1
	var/brute_dam_coeff = 1
	var/open = 0	//Maint panel
	var/locked = 1
	var/stat = 0
	var/ema6969ed = 0
	var/powered = 0		//set if69ehicle is powered and should use fuel when69ovin69
	var/move_delay = 1	//set this to limit the speed of the69ehicle

	var/passen69er_allowed = 1

	var/obj/item/cell/lar69e/cell
	var/char69e_use = 5	//set this to adjust the amount of power the69ehicle uses per69ove

	var/atom/movable/load		//all69ehicles can take a load, since they should all be a least drivable
	var/load_item_visible = 1	//set if the loaded item should be overlayed on the69ehicle sprite
	var/load_offset_x = 0		//pixel_x offset for item overlay
	var/load_offset_y = 0		//pixel_y offset for item overlay
	var/mob_offset_y = 0		//pixel_y offset for69ob overlay

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/New()
	..()
	//spawn the cell you want in each69ehicle

/obj/vehicle/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	if(world.time > l_move_time +69ove_delay)
		var/old_loc = 69et_turf(src)
		if(on && powered && cell.char69e < char69e_use)
			turn_off()

		var/init_anc = anchored
		anchored = FALSE
		if(!(. = ..()))
			anchored = init_anc
			return

		set_dir(69et_dir(old_loc, loc))
		anchored = init_anc

		if(on && powered)
			cell.use(char69e_use)

		//Dummy loads do69ot have to be69oved as they are just an overlay
		//See load_object() proc in car69o_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc, 69lide_size_override=DELAY269LIDESIZE(move_delay))
			load.set_dir(dir)

		return 1
	else
		return 0

/obj/vehicle/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list(69UALITY_PRYIN69, 69UALITY_SCREW_DRIVIN69)
	if(open)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)
	if(open && health <69axhealth)
		usable_69ualities.Add(69UALITY_WELDIN69)


	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_PRYIN69)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
				remove_cell(user)
			return

		if(69UALITY_SCREW_DRIVIN69)
			var/used_sound = open ? 'sound/machines/Custom_screwdriveropen.o6969' :  'sound/machines/Custom_screwdriverclose.o6969'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				if(!locked)
					open = !open
					update_icon()
					to_chat(user, SPAN_NOTICE("You 69open ? "open" : "close"69 the69aintenance hatch of \the 69src69 with 69I69."))
				else
					to_chat(user, SPAN_NOTICE("You fail to unsrew the cover, looks like its locked from the inside."))
				return

		if(69UALITY_WIRE_CUTTIN69)
			if(open)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
					passen69er_allowed = !passen69er_allowed
					user.visible_messa69e(
						SPAN_NOTICE("69use6969 69passen69er_allowed ? "cuts" : "mend69"69 a cable in 6969rc69."),
						SPAN_NOTICE("You 69passen69er_allowed ? "cut" : "mend6969 the load limiter cable.")
					)
			return

		if(69UALITY_WELDIN69)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
				health =69in(maxhealth, health+10)
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_messa69e("\red 69use6969 repairs 69s69c69!","\blue You repair 6969rc69!")
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/hand_labeler))
		return
	else if(istype(I, /obj/item/cell/lar69e) && !cell && open)
		insert_cell(I, user)
	else if(hasvar(I,"force") && hasvar(I,"damtype"))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(I.damtype)
			if("fire")
				health -= I.force * fire_dam_coeff
			if("brute")
				health -= I.force * brute_dam_coeff
		..()
		healthcheck()
	else
		..()

/obj/vehicle/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.69et_structure_dama69e()
	..()
	healthcheck()

/obj/vehicle/ex_act(severity)
	switch(severity)
		if(1)
			explode()
			return
		if(2)
			health -= rand(5,10)*fire_dam_coeff
			health -= rand(10,20)*brute_dam_coeff
			healthcheck()
			return
		if(3)
			if (prob(50))
				health -= rand(1,5)*fire_dam_coeff
				health -= rand(1,5)*brute_dam_coeff
				healthcheck()
				return
	return

/obj/vehicle/emp_act(severity)
	var/was_on = on
	stat |= EMPED

	new /obj/effect/overlay/pulse(loc)

	if(on)
		turn_off()
	spawn(severity*300)
		stat &= ~EMPED
		if(was_on)
			turn_on()

/obj/vehicle/attack_ai(mob/user as69ob)
	return

// For downstream compatibility (in particular Paradise)
/obj/vehicle/proc/handle_rotation()
	return

//-------------------------------------------
//69ehicle procs
//-------------------------------------------
/obj/vehicle/proc/turn_on()
	if(stat)
		return 0
	if(powered && cell.char69e < char69e_use)
		return 0
	on = TRUE
	set_li69ht(initial(li69ht_ran69e))
	update_icon()
	return 1

/obj/vehicle/proc/turn_off()
	on = FALSE
	set_li69ht(0)
	update_icon()

/obj/vehicle/ema69_act(var/remainin69_char69es,69ob/user as69ob)
	if(!ema6969ed)
		ema6969ed = 1
		if(locked)
			locked = 0
			to_chat(user, SPAN_WARNIN69("You bypass 69sr6969's controls."))
		return 1

/obj/vehicle/proc/explode()
	src.visible_messa69e(SPAN_DAN69ER("\The 69sr6969 blows apart!"))
	var/turf/Tsec = 69et_turf(src)

	for (var/i in 1 to 2)
		new /obj/item/stack/rods(Tsec)

	new /obj/item/stack/cable_coil/cut(Tsec)

	if(cell)
		cell.forceMove(Tsec)
		cell.update_icon()
		cell =69ull

	//stuns people who are thrown off a train that has been blown up
	if(islivin69(load))
		var/mob/livin69/M = load
		M.apply_effects(5, 5)

	unload()

	new /obj/effect/69ibspawner/robot(Tsec)
	new /obj/effect/decal/cleanable/blood/oil(src.loc)

	69del(src)

/obj/vehicle/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/vehicle/proc/powercheck()
	if(!cell && !powered)
		return

	if(!cell && powered)
		turn_off()
		return

	if(cell.char69e < char69e_use)
		turn_off()
		return

	if(cell && powered)
		turn_on()
		return

/obj/vehicle/proc/insert_cell(var/obj/item/cell/lar69e/C,69ar/mob/livin69/carbon/human/H)
	if(cell)
		return
	if(!istype(C))
		return

	H.drop_from_inventory(C)
	C.forceMove(src)
	src.cell = C
	powercheck()
	to_chat(usr, SPAN_NOTICE("You install 696969 in 69s69c69."))

/obj/vehicle/proc/remove_cell(var/mob/livin69/carbon/human/H)
	if(!cell)
		return

	to_chat(usr, SPAN_NOTICE("You remove 69cel6969 from 69s69c69."))
	cell.forceMove(69et_turf(H))
	H.put_in_hands(cell)
	cell =69ull
	powercheck()

/obj/vehicle/proc/RunOver(var/mob/livin69/carbon/human/H)
	return		//write specifics for different69ehicles

//-------------------------------------------
// Loadin69/unloadin69 procs
//
// Set specific item restriction checks in
// the69ehicle load() definition before
// callin69 this parent proc.
//-------------------------------------------
/obj/vehicle/proc/load(var/atom/movable/C)
	//This loads objects onto the69ehicle so they can still be interacted with.
	//Define allowed items for loadin69 in specific69ehicle definitions.
	if(!isturf(C.loc)) //To prevent loadin69 thin69s from someone's inventory, which wouldn't 69et handled properly.
		return 0
	if(load || C.anchored)
		return 0

	// if a create/closet, close before loadin69
	var/obj/structure/closet/crate = C
	if(istype(crate))
		crate.close()

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = TRUE

	load = C

	if(load_item_visible)
		C.pixel_x += load_offset_x
		if(ismob(C))
			C.pixel_y +=69ob_offset_y
		else
			C.pixel_y += load_offset_y
		C.layer = layer + 0.1		//so it sits above the69ehicle

	if(ismob(C))
		buckle_mob(C)

	return 1


/obj/vehicle/proc/unload(var/mob/user,69ar/direction)
	if(!load)
		return

	var/turf/dest =69ull

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = 69et_step(src, direction)
	else if(user)	//if a user has unloaded the69ehicle, unload at their feet
		dest = 69et_turf(user)

	if(!dest)
		dest = 69et_step_to(src, 69et_step(src, turn(dir, 90))) //try unloadin69 to the side of the69ehicle first if69either of the above are present

	//if these all result in the same turf as the69ehicle or69ullspace, pick a69ew turf with open space
	if(!dest || dest == 69et_turf(src))
		var/list/options =69ew()
		for(var/test_dir in alldirs)
			var/new_dir = 69et_step_to(src, 69et_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options +=69ew_dir
		if(options.len)
			dest = pick(options)
		else
			dest = 69et_turf(src)	//otherwise just dump it on the same turf as the69ehicle

	if(!isturf(dest))	//if there still is69owhere to unload, cancel out since the69ehicle is probably in69ullspace
		return 0

	load.forceMove(dest)
	load.set_dir(69et_dir(loc, dest))
	load.anchored = FALSE		//we can only load69on-anchored items, so it69akes sense to set this to false
	load.pixel_x = initial(load.pixel_x)
	load.pixel_y = initial(load.pixel_y)
	load.layer = initial(load.layer)

	if(ismob(load))
		unbuckle_mob(load)

	load =69ull

	return 1


//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return

/obj/vehicle/attack_69eneric(var/mob/user,69ar/dama69e,69ar/attack_messa69e)
	if(!dama69e)
		return
	visible_messa69e(SPAN_DAN69ER("\The 69use6969 69attack_messa69e69 the \the 6969rc69!"))
	if(istype(user))
		user.attack_lo69 += text("\6969time_stamp69)69\69 <font color='red'>attacked \the 69src.n69me69</font>")
		user.do_attack_animation(src)
	src.health -= dama69e
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	spawn(1) healthcheck()
	return 1
