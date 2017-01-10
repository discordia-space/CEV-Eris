#ifdef USE_OPENSPACE

//#define DEBUG_OPENSPACE

#define LIST_FAST 1
#define LIST_NORM 2
#define LIST_SLOW 3

var/datum/controller/process/open_space/OS_controller = null

/datum/controller/process/open_space
	var/slow_time
	var/normal_time

	var/list/levels
	var/list/levels_by_name

/datum/controller/process/open_space/setup()
	name = "openspace"
	schedule_interval = 5 // every second
	start_delay = 12

	OS_controller = src
	levels = list()
	levels_by_name = list()

	slow_time   = world.time + 3000
	normal_time = world.time + 600
	for(var/level = 2 to 17)
		if(HasBelow(level))
			add_z_level(level)

/datum/controller/process/open_space/proc/add_z_level(var/z)
#ifdef DEBUG_OPENSPACE
	world << "OPENSPACE: ADD [z] z lelel"
	world.log << "OPENSPACE: ADD [z] z lelel"
#endif
	levels_by_name["[z]"] = new /datum/ospace_data(z)
	levels += levels_by_name["[z]"]

/datum/controller/process/open_space/doWork()
#ifdef DEBUG_OPENSPACE
	world << "Calc fast OS"
#endif
	var/datum/ospace_data/current = null
	for(var/i in levels)
		current = i
		current.calc_fast()
		SCHECK

	if (world.time > normal_time)
#ifdef DEBUG_OPENSPACE
		world << "Calc normal OS"
#endif
		normal_time = world.time + 600
		for(var/i in levels)
			current = i
			current.calc(current.normal)
			SCHECK


/datum/controller/process/open_space/proc/add_turf(var/turf/T)
	var/datum/ospace_data/OD = levels["[T.z]"]
	if(OD) OD.add(list(T), LIST_FAST, 1)

/turf/simulated/open/Entered(atom/movable/Obj)
	. = ..()
	if(ticker)
		OS_controller.add_turf(src)

/turf/simulated/open/New()
	..()
	if(ticker)
		OS_controller.add_turf(src)

/datum/ospace_data
	var/z = 0
	var/datum/ospace_data/up = null
	var/datum/ospace_data/down = null
	var/list/slow   = list()
	var/list/normal = list()
	var/list/fast   = list()

/datum/ospace_data/New(var/new_level)
	z = new_level
	for (var/turf/simulated/open/T in world)
		if (T.z == z)
			fast += T
	spawn(5)
		up   = OS_controller.levels["[z+1]"]
		down = OS_controller.levels["[z-1]"]

/datum/ospace_data/proc/add(var/list/L, var/I, var/transfer)
	for(var/elem in L)
		slow   -= elem
		normal -= elem
		fast   -= elem

		switch (I)
			if(LIST_SLOW) slow   += elem
			if(LIST_NORM) normal += elem
			if(LIST_FAST) fast   += elem

		if(transfer > 0)
			if(up)
				up.add(list(GetAbove(elem)),   I, transfer-1)
			if(down)
				down.add(list(GetBelow(elem)), I, transfer-1)
	return

/datum/ospace_data/proc/calc_fast()
#ifdef DEBUG_OPENSPACE
	world << "Calc [z] fast. total: [fast.len] turfs."
#endif
	calc(fast)

/datum/ospace_data/proc/calc_normal()
#ifdef DEBUG_OPENSPACE
	world << "Calc [z] normal. total: [normal.len] turfs."
#endif
	calc(normal)

/datum/ospace_data/proc/calc(var/list/L)
	var/list/slowholder = list()
	var/list/normalholder = list()
	var/list/fastholder = list()
	var/new_list
	var/down = HasBelow(z)

	var/turf/T = null
	for(var/elem in L)
		L -= elem
		T = elem
		new_list = 0

		T.overlays.Cut()

		if(down && (istype(T, /turf/space) || istype(T, /turf/simulated/open)))
			var/turf/below = GetBelow(T)
			if(below)
				if(!(istype(below, /turf/space) || istype(below, /turf/simulated/open)))
					new_list = LIST_SLOW

					var/image/temp = image(below, dir=below.dir, layer = TURF_LAYER + 0.04)

					temp.color = below.color//rgb(127,127,127)
					temp.overlays += below.overlays
					T.overlays += temp

				// get objects
				var/image/o_img = list()
				for(var/obj/o in below)
					// ingore objects that have any form of invisibility
					if(o.invisibility || o.pixel_x || o.pixel_y) continue
					new_list = LIST_NORM
					var/image/temp2 = image(o, dir=o.dir, layer = TURF_LAYER+0.05*o.layer)
					temp2.color = o.color//rgb(127,127,127)
					temp2.overlays += o.overlays
					o_img += temp2
				T.overlays   += o_img

				// get mobs
				var/image/m_img = list()
				for(var/mob/m in below)
					// ingore mobs that have any form of invisibility
					if(m.invisibility) continue
					// only add this tile to fastprocessing if there is a living mob, not a dead one
					if(istype(m, /mob/living))
						new_list = LIST_FAST
					var/image/temp2 = image(m, dir=m.dir, layer = TURF_LAYER+0.05*m.layer)
					temp2.color = m.color//rgb(127,127,127)
					temp2.overlays += m.overlays
					m_img += temp2
					// you need to add a list to .overlays or it will not display any because space
				T.overlays   += m_img

				T.overlays   += image('icons/turf/floors.dmi', "black_open", TURF_LAYER+0.3)

			switch(new_list)
				if(LIST_SLOW)
					slowholder += T
				if(LIST_NORM)
					normalholder += T
				if(LIST_FAST)
					fastholder += T
					for(var/d in cardinal)
						var/turf/mT = get_step(T,d)
						fastholder |= mT
						for(var/f in cardinal)
							fastholder |= get_step(mT,f)

#ifdef DEBUG_OPENSPACE
	world << "- Slowholder: [slowholder.len]"
	world << "- Normholder: [normalholder.len]"
	world << "- Fastholder: [fastholder.len]"
#endif

	add(slowholder,   LIST_SLOW, 0)
	add(normalholder, LIST_NORM, 0)
	add(fastholder,   LIST_FAST, 0)
	return

#undef LIST_FAST
#undef LIST_NORM
#undef LIST_SLOW

#endif
