// Disposal pipe construction
// This is the pipe that you drag around, not the attached ones.

#define PIPE_TYPE_STRAIGHT 0
#define PIPE_TYPE_BENT 1
#define PIPE_TYPE_JUNC 2
#define PIPE_TYPE_JUNC_FLIP 3
#define PIPE_TYPE_JUNC_Y 4
#define PIPE_TYPE_TRUNK 5
#define PIPE_TYPE_BIN 6
#define PIPE_TYPE_OUTLET 7
#define PIPE_TYPE_INTAKE 8
#define PIPE_TYPE_JUNC_SORT 9
#define PIPE_TYPE_JUNC_SORT_FLIP 10
#define PIPE_TYPE_UP 11
#define PIPE_TYPE_DOWN 12
#define PIPE_TYPE_TAGGER 13
#define PIPE_TYPE_TAGGER_PART 14

#define SORT_TYPE_NORMAL 0
#define SORT_TYPE_WILDCARD 1
#define SORT_TYPE_UNTAGGED 2

/obj/structure/disposalconstruct

	name = "disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "conpipe-s"
	anchored = 0
	density = 0
	matter = list(DEFAULT_WALL_MATERIAL = 1850)
	level = 2
	var/sortType = ""
	var/pipe_type = 0
	var/sort_type = 0
	var/dpdir = 0	// directions as disposalpipe
	var/base_state = "pipe-s"

	// update iconstate and dpdir due to dir and type
	proc/update()
		var/flip = turn(dir, 180)
		var/left = turn(dir, 90)
		var/right = turn(dir, -90)
		switch(pipe_type)
			if(PIPE_TYPE_STRAIGHT)
				base_state = "pipe-s"
				dpdir = dir | flip
			if(PIPE_TYPE_BENT)
				base_state = "pipe-c"
				dpdir = dir | right
			if(PIPE_TYPE_JUNC)
				base_state = "pipe-j1"
				dpdir = dir | right | flip
			if(PIPE_TYPE_JUNC_FLIP)
				base_state = "pipe-j2"
				dpdir = dir | left | flip
			if(PIPE_TYPE_JUNC_Y)
				base_state = "pipe-y"
				dpdir = dir | left | right
			if(PIPE_TYPE_TRUNK)
				base_state = "pipe-t"
				dpdir = dir
			 // disposal bin has only one dir, thus we don't need to care about setting it
			if(PIPE_TYPE_BIN)
				if(anchored)
					base_state = "disposal"
				else
					base_state = "condisposal"

			if(PIPE_TYPE_OUTLET)
				base_state = "outlet"
				dpdir = dir

			if(PIPE_TYPE_INTAKE)
				base_state = "intake"
				dpdir = dir

			if(PIPE_TYPE_JUNC_SORT)
				base_state = "pipe-j1s"
				dpdir = dir | right | flip

			if(PIPE_TYPE_JUNC_SORT_FLIP)
				base_state = "pipe-j2s"
				dpdir = dir | left | flip
///// Z-Level stuff
			if(PIPE_TYPE_UP)
				base_state = "pipe-u"
				dpdir = dir
			if(PIPE_TYPE_DOWN)
				base_state = "pipe-d"
				dpdir = dir
///// Z-Level stuff
			if(PIPE_TYPE_TAGGER)
				base_state = "pipe-tagger"
				dpdir = dir | flip
			if(PIPE_TYPE_TAGGER_PART)
				base_state = "pipe-tagger-partial"
				dpdir = dir | flip


///// Z-Level stuff
		if(!(pipe_type in list(6, 7, 8, 11, 12, 13, 14)))
///// Z-Level stuff
			icon_state = "con[base_state]"
		else
			icon_state = base_state

		if(invisibility)				// if invisible, fade icon
			alpha = 128
		else
			alpha = 255
			//otherwise burying half-finished pipes under floors causes them to half-fade

	// hide called by levelupdate if turf intact status changes
	// change visibility status and force update of icon
/obj/structure/disposalconstruct/hide(var/intact)
	invisibility = (intact && level==1) ? 101: 0	// hide if floor is intact
	update()


	// flip and rotate verbs
/obj/structure/disposalconstruct/verb/rotate()
	set category = "Object"
	set name = "Rotate Pipe"
	set src in view(1)

	if(usr.stat)
		return

	if(anchored)
		usr << "You must unfasten the pipe before rotating it."
		return

	set_dir(turn(dir, -90))
	update()

/obj/structure/disposalconstruct/verb/flip()
	set category = "Object"
	set name = "Flip Pipe"
	set src in view(1)
	if(usr.stat)
		return

	if(anchored)
		usr << "You must unfasten the pipe before flipping it."
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
			switch(sort_type)
				if(SORT_TYPE_NORMAL)
					return /obj/structure/disposalpipe/sortjunction
				if(SORT_TYPE_WILDCARD)
					return /obj/structure/disposalpipe/sortjunction/wildcard
				if(SORT_TYPE_UNTAGGED)
					return /obj/structure/disposalpipe/sortjunction/untagged
		if(PIPE_TYPE_JUNC_SORT_FLIP)
			switch(sort_type)
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

/obj/structure/disposalconstruct/attackby(var/obj/item/I, var/mob/user)
	var/nicetype = "pipe"
	var/ispipe = 0 // Indicates if we should change the level of this pipe
	src.add_fingerprint(user)
	switch(pipe_type)
		if(PIPE_TYPE_BIN)
			nicetype = "disposal bin"
		if(PIPE_TYPE_OUTLET)
			nicetype = "disposal outlet"
		if(PIPE_TYPE_INTAKE)
			nicetype = "delivery chute"
		if(PIPE_TYPE_JUNC_SORT, PIPE_TYPE_JUNC_SORT_FLIP)
			switch(sort_type)
				if(SORT_TYPE_NORMAL)
					nicetype = "sorting pipe"
				if(SORT_TYPE_WILDCARD)
					nicetype = "wildcard sorting pipe"
				if(SORT_TYPE_UNTAGGED)
					nicetype = "untagged sorting pipe"
			ispipe = 1
		if(PIPE_TYPE_TAGGER)
			nicetype = "tagging pipe"
			ispipe = 1
		if(PIPE_TYPE_TAGGER_PART)
			nicetype = "partial tagging pipe"
			ispipe = 1
		else
			nicetype = "pipe"
			ispipe = 1

	var/turf/T = src.loc
	if(!T.is_plating())
		user << "You can only attach the [nicetype] if the floor plating is removed."
		return

	var/obj/structure/disposalpipe/CP = locate() in T

	if(istype(I, /obj/item/weapon/wrench))
		if(anchored)
			anchored = 0
			if(ispipe)
				level = 2
				density = 0
			else
				density = 1
			user << "You detach the [nicetype] from the underfloor."
		else
			if(pipe_type in list(PIPE_TYPE_BIN, PIPE_TYPE_OUTLET, PIPE_TYPE_INTAKE))
				if(CP) // There's something there
					if(!istype(CP,/obj/structure/disposalpipe/trunk))
						user << "The [nicetype] requires a trunk underneath it in order to work."
						return
				else // Nothing under, fuck.
					user << "The [nicetype] requires a trunk underneath it in order to work."
					return
			else
				if(CP)
					update()
					var/pdir = CP.dpdir
					if(istype(CP, /obj/structure/disposalpipe/broken))
						pdir = CP.dir
					if(pdir & dpdir)
						user << "There is already a [nicetype] at that location."
						return

			anchored = 1
			if(ispipe)
				level = 1 // We don't want disposal bins to disappear under the floors
				density = 0
			else
				density = 1 // We don't want disposal bins or outlets to go density 0
			user << "You attach the [nicetype] to the underfloor."
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		update()

	else if(istype(I, /obj/item/weapon/weldingtool))
		if(anchored)
			var/obj/item/weapon/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				user << "Welding the [nicetype] in place."
				if(do_after(user, 20, src))
					if(!src || !W.isOn()) return
					user << "The [nicetype] has been welded in place!"
					update() // TODO: Make this neat
					if(ispipe) // Pipe

						var/pipetype = dpipetype()
						var/obj/structure/disposalpipe/P = new pipetype(src.loc)
						src.transfer_fingerprints_to(P)
						P.base_icon_state = base_state
						P.set_dir(dir)
						P.dpdir = dpdir
						P.updateicon()

						//Needs some special treatment ;)
						if(pipe_type in list(PIPE_TYPE_JUNC_SORT, PIPE_TYPE_JUNC_SORT_FLIP))
							var/obj/structure/disposalpipe/sortjunction/SortP = P
							SortP.sortType = sortType
							SortP.updatedir()
							SortP.updatedesc()
							SortP.updatename()

					else if(pipe_type == PIPE_TYPE_BIN) // Disposal bin
						var/obj/machinery/disposal/P = new /obj/machinery/disposal(src.loc)
						src.transfer_fingerprints_to(P)
						P.mode = 0 // start with pump off

					else if(pipe_type == PIPE_TYPE_OUTLET) // Disposal outlet

						var/obj/structure/disposaloutlet/P = new /obj/structure/disposaloutlet(src.loc)
						src.transfer_fingerprints_to(P)
						P.set_dir(dir)
						var/obj/structure/disposalpipe/trunk/Trunk = CP
						Trunk.linked = P

					else if(pipe_type == PIPE_TYPE_INTAKE) // Disposal outlet

						var/obj/machinery/disposal/deliveryChute/P = new /obj/machinery/disposal/deliveryChute(src.loc)
						src.transfer_fingerprints_to(P)
						P.set_dir(dir)

					qdel(src)
					return
			else
				user << "You need more welding fuel to complete this task."
				return
		else
			user << "You need to attach it to the plating first!"
			return

/obj/structure/disposalconstruct/hides_under_flooring()
	if(anchored)
		return 1
	else
		return 0
