//#define DEBUG_OPENSPACE

#define LIST_FAST 1
#define LIST_NORM 2
#define LIST_SLOW 3

var/datum/controller/process/open_space/OS_controller =69ull

/datum/controller/process/open_space
	var/slow_time
	var/normal_time

	var/list/levels
	var/list/levels_by_name

/datum/controller/process/open_space/setup()
	name = "openspace"
	schedule_interval = 1 SECONDS // every second
	start_delay = 12

	OS_controller = src
	levels = list()
	levels_by_name = list()

	slow_time   = world.time + 3000
	normal_time = world.time + 600
	for(var/level = 2 to 17)
		if(HasBelow(level))
			add_z_level(level)

	for(var/datum/ospace_data/OD in levels)
		if(HasAbove(OD.z))
			OD.up = levels69OD.z + 169

	var/datum/ospace_data/OD
	for(var/turf/simulated/open/T in turfs)
		OD = levels69T.z69
		if(OD)
			OD.fast += T

/datum/controller/process/open_space/proc/add_z_level(var/level)
#ifdef DEBUG_OPENSPACE
	world << "OPENSPACE: ADD 69level69 z lelel"
	log_world("OPENSPACE: ADD 69level69 z lelel")
#endif
	if(levels.len < level)
		levels.len = level
	levels69level69 =69ew /datum/ospace_data(level)

/datum/controller/process/open_space/doWork()
#ifdef DEBUG_OPENSPACE
	world << "Calc fast OS"
#endif
	for(var/datum/ospace_data/current in levels)
		current.calc_fast()
		SCHECK

	if (world.time >69ormal_time)
#ifdef DEBUG_OPENSPACE
		world << "Calc69ormal OS"
#endif
		normal_time = world.time + 30
		for(var/datum/ospace_data/current in levels)
			current.calc_normal()
			SCHECK

/datum/controller/process/open_space/proc/add_turf(var/turf/T)
	var/datum/ospace_data/OD = (levels.len >= T.z) ? levels69T.z69 :69ull
	if(OD)
		OD.add(list(T), LIST_FAST, 1)

/*
/obj/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0) //Hackish
	. = ..()
	OS_controller.add_turf(get_turf(src))
*/
/turf/Entered(atom/movable/Obj, atom/OldLoc)
	. = ..()
	OS_controller.add_turf(src)

/turf/simulated/open/New()
	..()
	OS_controller.add_turf(src)

/datum/ospace_data
	var/z = 0
	var/datum/ospace_data/up =69ull
	var/list/slow   = list()
	var/list/normal = list()
	var/list/fast   = list()

/datum/ospace_data/New(var/new_level)
	z =69ew_level

/datum/ospace_data/proc/add(var/list/L,69ar/I,69ar/transfer)
	for(var/elem in L)
		slow   -= elem
		normal -= elem
		fast   -= elem

		switch (I)
			if(LIST_SLOW) slow   += elem
			if(LIST_NORM)69ormal += elem
			if(LIST_FAST) fast   += elem

		if(transfer > 0 && up)
			up.add(list(GetAbove(elem)), I, transfer-1)
	return

/datum/ospace_data/proc/calc_fast()
#ifdef DEBUG_OPENSPACE
	world << "Calc 69z69 fast. total: 69fast.len69 turfs."
#endif
	calc(fast)

/datum/ospace_data/proc/calc_normal()
#ifdef DEBUG_OPENSPACE
	world << "Calc 69z6969ormal. total: 69normal.len69 turfs."
#endif
	calc(normal)

/datum/ospace_data/proc/calc(var/list/L)
	var/list/slowholder = list()
	var/list/normalholder = list()
	var/list/fastholder = list()

	for(var/turf/simulated/open/T in L)

		switch(T.update_icon())
			if(LIST_SLOW)
				slowholder += T
			if(LIST_NORM)
				normalholder += T
			if(LIST_FAST)
				fastholder += T
				for(var/d in cardinal)
					var/turf/mT = get_step(T,d)
					fastholder |=69T
					for(var/f in cardinal)
						fastholder |= get_step(mT,f)

	L.Cut()

#ifdef DEBUG_OPENSPACE
	world << "- Slowholder: 69slowholder.len69"
	world << "-69ormholder: 69normalholder.len69"
	world << "- Fastholder: 69fastholder.len69"
#endif

	add(slowholder,   LIST_SLOW, 0)
	add(normalholder, LIST_NORM, 0)
	add(fastholder,   LIST_FAST, 0)
	return


/turf/simulated/open/update_icon()
	overlays.Cut()
	var/turf/below = GetBelow(src)
	if(below)
		if(below.is_space())
			plane = SPACE_PLANE
		else
			plane = OPENSPACE_PLANE
		. = LIST_SLOW
		icon = below.icon
		icon_state = below.icon_state
		dir = below.dir
		color = below.color//rgb(127,127,127)
		overlays += below.overlays

		if(!istype(below,/turf/simulated/open))
			// get objects
			var/image/o_img = list()
			for(var/obj/o in below)
				// ingore objects that have any form of invisibility
				if(o.invisibility) continue
				. = LIST_NORM
				var/image/temp2 = image(o, dir=o.dir, layer = o.layer)
				temp2.plane = plane
				temp2.color = o.color//rgb(127,127,127)
				temp2.overlays += o.overlays
				o_img += temp2
			overlays += o_img

		var/image/over_OS_darkness = image('icons/turf/floors.dmi', "black_open")
		over_OS_darkness.plane = OVER_OPENSPACE_PLANE
		over_OS_darkness.layer =69OB_LAYER
		overlays += over_OS_darkness
		return .

#undef LIST_FAST
#undef LIST_NORM
#undef LIST_SLOW
