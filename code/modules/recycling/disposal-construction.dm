// Disposal pipe construction
// This is the pipe that you drag around,69ot the attached ones.

/obj/structure/disposalconstruct

	name = "disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "conpipe-s"
	anchored = FALSE
	density = FALSE
	matter = list(MATERIAL_STEEL = 6)
	level = ABOVE_PLATING_LEVEL
	var/sortType = list()
	var/pipe_type = 0
	var/sort_mode = 0
	var/pipe_dir = 0	// directions as disposalpipe
	var/base_state = "pipe-s"

/obj/structure/disposalconstruct/can_fall()
	var/turf/below = GetBelow(get_turf(src))
	var/pipe_below = istype(below)
	if(pipe_below)
		pipe_below = locate(/obj/structure/disposalpipe/up) in below
	return !(anchored || pipe_below)

	// update iconstate and pipe_dir due to dir and type
/obj/structure/disposalconstruct/proc/update()
	var/flip = turn(dir, 180)
	var/left = turn(dir, 90)
	var/right = turn(dir, -90)
	switch(pipe_type)
		if(PIPE_TYPE_STRAIGHT)
			base_state = "pipe-s"
			pipe_dir = dir | flip
		if(PIPE_TYPE_BENT)
			base_state = "pipe-c"
			pipe_dir = dir | right
		if(PIPE_TYPE_JUNC)
			base_state = "pipe-j1"
			pipe_dir = dir | right | flip
		if(PIPE_TYPE_JUNC_FLIP)
			base_state = "pipe-j2"
			pipe_dir = dir | left | flip
		if(PIPE_TYPE_JUNC_Y)
			base_state = "pipe-y"
			pipe_dir = dir | left | right
		if(PIPE_TYPE_TRUNK)
			base_state = "pipe-t"
			pipe_dir = dir
		 // disposal bin has only one dir, thus we don't69eed to care about setting it
		if(PIPE_TYPE_BIN)
			if(anchored)
				base_state = "disposal"
			else
				base_state = "condisposal"

		if(PIPE_TYPE_OUTLET)
			base_state = "outlet"
			pipe_dir = dir

		if(PIPE_TYPE_INTAKE)
			base_state = "intake"
			pipe_dir = dir

		if(PIPE_TYPE_JUNC_SORT)
			base_state = "pipe-j1s"
			pipe_dir = dir | right | flip

		if(PIPE_TYPE_JUNC_SORT_FLIP)
			base_state = "pipe-j2s"
			pipe_dir = dir | left | flip
///// Z-Level stuff
		if(PIPE_TYPE_UP)
			base_state = "pipe-u"
			pipe_dir = dir
		if(PIPE_TYPE_DOWN)
			base_state = "pipe-d"
			pipe_dir = dir
///// Z-Level stuff
		if(PIPE_TYPE_TAGGER)
			base_state = "pipe-tagger"
			pipe_dir = dir | flip
		if(PIPE_TYPE_TAGGER_PART)
			base_state = "pipe-tagger-partial"
			pipe_dir = dir | flip

///// Z-Level stuff
	if(!(pipe_type in list(PIPE_TYPE_BIN, PIPE_TYPE_OUTLET, PIPE_TYPE_INTAKE, PIPE_TYPE_UP, PIPE_TYPE_DOWN, PIPE_TYPE_TAGGER, PIPE_TYPE_TAGGER_PART)))
///// Z-Level stuff
		icon_state = "con69base_state69"
	else
		icon_state = base_state

	if(invisibility)				// if invisible, fade icon
		alpha = 128
	else
		alpha = 255
			//otherwise burying half-finished pipes under floors causes them to half-fade

	// hide called by levelupdate if turf intact status changes
	// change69isibility status and force update of icon
/obj/structure/disposalconstruct/hide(var/intact)
	invisibility = (intact && level == BELOW_PLATING_LEVEL) ? 101 : 0	// hide if floor is intact
	update()


	// flip and rotate69erbs
/obj/structure/disposalconstruct/verb/rotate()
	set category = "Object"
	set69ame = "Rotate Pipe"
	set src in69iew(1)

	if(usr.stat)
		return

	if(anchored)
		to_chat(usr, "You69ust unfasten the pipe before rotating it.")
		return

	set_dir(turn(dir, -90))
	update()

/obj/structure/disposalconstruct/verb/flip()
	set category = "Object"
	set69ame = "Flip Pipe"
	set src in69iew(1)
	if(usr.stat)
		return

	if(anchored)
		to_chat(usr, "You69ust unfasten the pipe before flipping it.")
		return

	set_dir(turn(dir, 180))
	switch(pipe_type)
		if(PIPE_TYPE_JUNC)
			pipe_type = PIPE_TYPE_JUNC_FLIP
		if(PIPE_TYPE_JUNC_FLIP)
			pipe_type = PIPE_TYPE_JUNC
		if(PIPE_TYPE_JUNC_SORT)
			pipe_type = PIPE_TYPE_JUNC_SORT_FLIP
		if(PIPE_TYPE_JUNC_SORT_FLIP)
			pipe_type = PIPE_TYPE_JUNC_SORT

	update()

	// returns the type path of disposalpipe corresponding to this item dtype
/obj/structure/disposalconstruct/proc/dpipetype()
	switch(pipe_type)
		if(PIPE_TYPE_STRAIGHT, PIPE_TYPE_BENT)
			return /obj/structure/disposalpipe/segment
		if(PIPE_TYPE_JUNC, PIPE_TYPE_JUNC_FLIP, PIPE_TYPE_JUNC_Y)
			return /obj/structure/disposalpipe/junction
		if(PIPE_TYPE_TRUNK)
			return /obj/structure/disposalpipe/trunk
		if(PIPE_TYPE_BIN)
			return /obj/machinery/disposal
		if(PIPE_TYPE_OUTLET)
			return /obj/structure/disposaloutlet
		if(PIPE_TYPE_INTAKE)
			return /obj/machinery/disposal/deliveryChute
		if(PIPE_TYPE_JUNC_SORT)
			switch(sort_mode)
				if(SORT_TYPE_NORMAL)
					return /obj/structure/disposalpipe/sortjunction
				if(SORT_TYPE_WILDCARD)
					return /obj/structure/disposalpipe/sortjunction/wildcard
				if(SORT_TYPE_UNTAGGED)
					return /obj/structure/disposalpipe/sortjunction/untagged
		if(PIPE_TYPE_JUNC_SORT_FLIP)
			switch(sort_mode)
				if(SORT_TYPE_NORMAL)
					return /obj/structure/disposalpipe/sortjunction/flipped
				if(SORT_TYPE_WILDCARD)
					return /obj/structure/disposalpipe/sortjunction/wildcard/flipped
				if(SORT_TYPE_UNTAGGED)
					return /obj/structure/disposalpipe/sortjunction/untagged/flipped
///// Z-Level stuff
		if(PIPE_TYPE_UP)
			return /obj/structure/disposalpipe/up
		if(PIPE_TYPE_DOWN)
			return /obj/structure/disposalpipe/down
///// Z-Level stuff
		if(PIPE_TYPE_TAGGER)
			return /obj/structure/disposalpipe/tagger
		if(PIPE_TYPE_TAGGER_PART)
			return /obj/structure/disposalpipe/tagger/partial
	return



	// attackby item
	// wrench: (un)anchor
	// weldingtool: convert to real pipe

/obj/structure/disposalconstruct/attackby(var/obj/item/I,69ar/mob/user)
	var/nice_type = "pipe"
	var/is_pipe = FALSE // Indicates if we should change the level of this pipe
	src.add_fingerprint(user)
	switch(pipe_type)
		if(PIPE_TYPE_BIN)
			nice_type = "disposal bin"
		if(PIPE_TYPE_OUTLET)
			nice_type = "disposal outlet"
		if(PIPE_TYPE_INTAKE)
			nice_type = "delivery chute"
		if(PIPE_TYPE_JUNC_SORT, PIPE_TYPE_JUNC_SORT_FLIP)
			switch(sort_mode)
				if(SORT_TYPE_NORMAL)
					nice_type = "sorting pipe"
				if(SORT_TYPE_WILDCARD)
					nice_type = "wildcard sorting pipe"
				if(SORT_TYPE_UNTAGGED)
					nice_type = "untagged sorting pipe"
			is_pipe = TRUE
		if(PIPE_TYPE_TAGGER)
			nice_type = "tagging pipe"
			is_pipe = TRUE
		if(PIPE_TYPE_TAGGER_PART)
			nice_type = "partial tagging pipe"
			is_pipe = TRUE
		else
			nice_type = "pipe"
			is_pipe = TRUE

	var/turf/T = src.loc
	if(!T.is_plating())
		to_chat(user, "You can only attach the 69nice_type69 if the floor plating is removed.")
		return

	var/obj/structure/disposalpipe/CP = locate() in T

	var/list/usable_69ualities = list(69UALITY_BOLT_TURNING)
	if(anchored)
		usable_69ualities.Add(69UALITY_WELDING)

	var/tool_type = I.get_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNING)
			if(pipe_type in list(PIPE_TYPE_BIN, PIPE_TYPE_OUTLET, PIPE_TYPE_INTAKE))
				if(CP) // There's something there
					if(!istype(CP,/obj/structure/disposalpipe/trunk))
						to_chat(user, "The 69nice_type69 re69uires a trunk underneath it in order to work.")
						return
				else //69othing under, fuck.
					to_chat(user, "The 69nice_type69 re69uires a trunk underneath it in order to work.")
					return

			if(CP)
				update()
				var/pdir = CP.pipe_dir
				if(istype(CP, /obj/structure/disposalpipe/broken))
					pdir = CP.dir
				if(pdir & pipe_dir)
					to_chat(user, "There is already a 69nice_type69 at that location.")
					return

			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				if(anchored)
					anchored = FALSE
					if(is_pipe)
						level = ABOVE_PLATING_LEVEL
						density = FALSE
					else
						density = TRUE
					to_chat(user, "You detach the 69nice_type69 from the underfloor.")
					return
				else
					anchored = TRUE
					if(is_pipe)
						level = BELOW_PLATING_LEVEL // We don't want disposal bins to disappear under the floors
						density = FALSE
					else
						density = TRUE // We don't want disposal bins or outlets to go density 0
					to_chat(user, "You attach the 69nice_type69 to the underfloor.")
					return
			return

		if(69UALITY_WELDING)
			if(anchored)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY))
					to_chat(user, "The 69nice_type69 has been welded in place!")
					update() // TODO:69ake this69eat
					if(is_pipe) // Pipe
						var/pipetype = dpipetype()
						var/obj/structure/disposalpipe/P =69ew pipetype(src.loc)
						src.transfer_fingerprints_to(P)
						P.base_icon_state = base_state
						P.set_dir(dir)
						P.pipe_dir = pipe_dir
						P.updateicon()

						//Needs some special treatment ;)
						if(pipe_type in list(PIPE_TYPE_JUNC_SORT, PIPE_TYPE_JUNC_SORT_FLIP))
							var/obj/structure/disposalpipe/sortjunction/SortP = P
							SortP.sortType = sortType
							SortP.updatedir()
							SortP.updatedesc()
							SortP.updatename()

					else if(pipe_type == PIPE_TYPE_BIN) // Disposal bin
						var/obj/machinery/disposal/P =69ew /obj/machinery/disposal(src.loc)
						src.transfer_fingerprints_to(P)
						P.mode = 0 // start with pump off

					else if(pipe_type == PIPE_TYPE_OUTLET) // Disposal outlet

						var/obj/structure/disposaloutlet/P =69ew /obj/structure/disposaloutlet(src.loc)
						src.transfer_fingerprints_to(P)
						P.set_dir(dir)
						var/obj/structure/disposalpipe/trunk/Trunk = CP
						Trunk.linked = P

					else if(pipe_type == PIPE_TYPE_INTAKE) // Disposal outlet

						var/obj/machinery/disposal/deliveryChute/P =69ew /obj/machinery/disposal/deliveryChute(src.loc)
						src.transfer_fingerprints_to(P)
						P.set_dir(dir)

					69del(src)
					return
			return

		if(ABORT_CHECK)
			return

/obj/structure/disposalconstruct/hides_under_flooring()
	if(anchored)
		return 1
	else
		return 0
