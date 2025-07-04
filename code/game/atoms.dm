/atom
	layer = TURF_LAYER
	plane = GAME_PLANE
	appearance_flags = TILE_BOUND|PIXEL_SCALE|LONG_GLIDE
	var/original_plane = null
	var/level = ABOVE_PLATING_LEVEL
	var/flags = NONE
	var/reagent_flags = NONE
	var/last_bumped = 0
	var/pass_flags = 0
	var/throwpass = 0
	var/simulated = TRUE //filter for actions - used by lighting overlays
	var/fluorescent // Shows up under a UV light.
	var/allow_spin = TRUE // prevents thrown atoms from spinning when disabled on thrown or target
	var/used_now = FALSE //For tools system, check for it should forbid to work on atom for more than one user at time
	var/auto_init = TRUE
	var/initialized = FALSE
	var/sanity_damage = 0

	var/light_power = 1 // Intensity of the light.
	var/light_range = 0 // Range in tiles of the light.
	var/light_color     // Hexadecimal RGB string representing the colour of the light.

	var/can_buckle = FALSE
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_pixel_shift = "x=0;y=0" //where the buckled mob should be pixel shifted to, or null for no pixel shift control
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob = null

	var/was_bloodied
	var/blood_color
	var/fingerprintslast
	var/list/fingerprints
	var/list/fingerprintshidden
	var/list/blood_DNA
	var/list/original_atom // Detective Work, used for the duplicate data points kept in the scanners
	var/list/statverbs
	var/list/atom_colours // Inherent color, the colored paint applied on it, special color effect etc...
	var/list/preloaded_reagents
	var/datum/reagents/reagents
	var/tmp/list/light_sources       // Any light sources that are "inside" of us, for example, if src here was a mob that's carrying a flashlight, that flashlight's light source would be part of this list.
	var/tmp/datum/light_source/light // Our light source. Don't fuck with this directly unless you have a good reason!


/atom/proc/update_icon()
	return

/**
 * Called when an atom is created in byond (built in engine proc)
 *
 * Not a lot happens here in SS13 code, as we offload most of the work to the
 * [Intialization][/atom/proc/Initialize] proc, mostly we run the preloader
 * if the preloader is being used and then call [InitAtom][/datum/controller/subsystem/atoms/proc/InitAtom] of which the ultimate
 * result is that the Intialize proc is called.
 *
 * We also generate a tag here if the DF_USE_TAG flag is set on the atom
 */
/atom/New(loc, ...)
	init_plane()
	update_plane()
	init_light()

	if(datum_flags & DF_USE_TAG)
		GenerateTag()

	var/do_initialize = SSatoms.initialized
	if(do_initialize != INITIALIZATION_INSSATOMS)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, FALSE, args))
			//we were deleted
			return

/**
 * The primary method that objects are setup in SS13 with
 *
 * we don't use New as we have better control over when this is called and we can choose
 * to delay calls or hook other logic in and so forth
 *
 * During roundstart map parsing, atoms are queued for intialization in the base atom/New(),
 * After the map has loaded, then Initalize is called on all atoms one by one. NB: this
 * is also true for loading map templates as well, so they don't Initalize until all objects
 * in the map file are parsed and present in the world
 *
 * If you're creating an object at any point after SSInit has run then this proc will be
 * immediately be called from New.
 *
 * mapload: This parameter is true if the atom being loaded is either being intialized during
 * the Atom subsystem intialization, or if the atom is being loaded from the map template.
 * If the item is being created at runtime any time after the Atom subsystem is intialized then
 * it's false.
 *
 * You must always call the parent of this proc, otherwise failures will occur as the item
 * will not be seen as initalized (this can lead to all sorts of strange behaviour, like
 * the item being completely unclickable)
 *
 * You must not sleep in this proc, or any subprocs
 *
 * Any parameters from new are passed through (excluding loc), naturally if you're loading from a map
 * there are no other arguments
 *
 * Must return an [initialization hint][INITIALIZE_HINT_NORMAL] or a runtime will occur.
 *
 * Note: the following functions don't call the base for optimization and must copypasta handling:
 * * [/turf/proc/Initialize]
 * * [/turf/open/space/proc/Initialize]
 */
/atom/proc/Initialize(mapload, ...)
	if(initialized)
		CRASH("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE

	if(light_power && light_range)
		update_light()

	update_plane()

	if(preloaded_reagents)
		if(!reagents)
			var/volume = 0
			for(var/reagent in preloaded_reagents)
				volume += preloaded_reagents[reagent]
			create_reagents(volume)
		for(var/reagent in preloaded_reagents)
			reagents.add_reagent(reagent, preloaded_reagents[reagent])

	return INITIALIZE_HINT_NORMAL

/**
 * Late Intialization, for code that should run after all atoms have run Intialization
 *
 * To have your LateIntialize proc be called, your atoms [Initalization][/atom/proc/Initialize]
 *  proc must return the hint
 * [INITIALIZE_HINT_LATELOAD] otherwise you will never be called.
 *
 * useful for doing things like finding other machines on GLOB.machines because you can guarantee
 * that all atoms will actually exist in the "WORLD" at this time and that all their Intialization
 * code has been run
 */
/atom/proc/LateInitialize()
	set waitfor = FALSE

/**
 * Top level of the destroy chain for most atoms
 *
 * Cleans up the following:
 * * Removes alternate apperances from huds that see them
 * * qdels the reagent holder from atoms if it exists
 * * Clears itself from any targeting-related vars that hold a reference to it
 * * clears the orbiters list
 * * clears overlays and priority overlays
 * * clears the light object
 */
/atom/Destroy()
	if(buckled_mob)
		unbuckle_mob()
	if(light)
		light.destroy()
		light = null
	if(statverbs)
		statverbs.Cut()
	if(reagents)
		QDEL_NULL(reagents)

	SEND_SIGNAL(src, COMSIG_NULL_TARGET)
	SEND_SIGNAL(src, COMSIG_NULL_SECONDARY_TARGET)

	update_openspace()
	return ..()

///Generate a tag for this atom
/atom/proc/GenerateTag()
	return

/atom/proc/reveal_blood()
	return

/atom/proc/assume_air(datum/gas_mixture/giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

//return flags that should be added to the viewer's sight var.
//Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (isAI(user)) // WHYYYY
		return 0
	return -1

/atom/proc/on_reagent_change()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

// Convenience procs to see if a container is open for chemistry handling
/atom/proc/is_open_container()
	return is_refillable() && is_drainable()

/atom/proc/is_injectable(allowmobs = TRUE)
	return reagents && (reagent_flags & (INJECTABLE | REFILLABLE))

/atom/proc/is_drawable(allowmobs = TRUE)
	return reagents && (reagent_flags & (DRAWABLE | DRAINABLE))

/atom/proc/is_refillable()
	return reagents && (reagent_flags & REFILLABLE)

/atom/proc/is_drainable()
	return reagents && (reagent_flags & DRAINABLE)


/atom/proc/CheckExit()
	return TRUE

// If you want to use this, the atom must have the PROXMOVE flag, and the moving
// atom must also have the PROXMOVE flag currently to help with lag. ~ ComicIronic
/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(severity)
	return


/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, def_zone)
	. = FALSE

/atom/proc/block_bullet(mob/user, obj/item/projectile/damage_source, def_zone)
	return 0

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return FALSE
	else if(src in container)
		return TRUE
	return

/*
 *	atom/proc/search_contents_for(path, list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path, list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path, filter_path)
	return found

//This proc is called on the location of an atom when the atom is Destroy()'d
/atom/proc/handle_atom_del(atom/A)
	return



/*
Beam code by Gunbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attempting to call it more than
once at a time per source will cause graphical errors.
Also, the icon used for the beam will have to be vertical and 32x32.
The math involved assumes that the icon is vertical to begin with so unless you want to adjust the math,
its easier to just keep the beam vertical.
*/
/atom/proc/Beam(atom/BeamTarget, icon_state="b_beam", icon='icons/effects/beam.dmi',time=50, maxdistance=10)
	//BeamTarget represents the target for the beam, basically just means the other end.
	//Time is the duration to draw the beam
	//Icon is obviously which icon to use for the beam, default is beam.dmi
	//Icon_state is what icon state is used. Default is b_beam which is a blue beam.
	//Maxdistance is the longest range the beam will persist before it gives up.
	var/EndTime=world.time+time
	while(BeamTarget&&world.time<EndTime&&get_dist(src, BeamTarget)<maxdistance&&z==BeamTarget.z)
	//If the BeamTarget gets deleted, the time expires, or the BeamTarget gets out
	//of range or to another z-level, then the beam will stop.  Otherwise it will
	//continue to draw.

		set_dir(get_dir(src, BeamTarget))	//Causes the source of the beam to rotate to continuosly face the BeamTarget.

		for(var/obj/effect/overlay/beam/O in orange(10, src))	//This section erases the previously drawn beam because I found it was easier to
			if(O.BeamSource==src)				//just draw another instance of the beam instead of trying to manipulate all the
				qdel(O)							//pieces to a new orientation.
		var/Angle=round(Get_Angle(src, BeamTarget))
		var/icon/I=new(icon, icon_state)
		I.Turn(Angle)
		var/DX=(32*BeamTarget.x+BeamTarget.pixel_x)-(32*x+pixel_x)
		var/DY=(32*BeamTarget.y+BeamTarget.pixel_y)-(32*y+pixel_y)
		var/N=0
		var/length=round(sqrt((DX)**2+(DY)**2))
		for(N, N<length, N+=32)
			var/obj/effect/overlay/beam/X=new(loc)
			X.BeamSource=src
			if(N+32>length)
				var/icon/II=new(icon, icon_state)
				II.DrawBox(null, 1, (length-N), 32, 32)
				II.Turn(Angle)
				X.icon=II
			else X.icon=I
			var/Pixel_x=round(sin(Angle)+32*sin(Angle)*(N+16)/32)
			var/Pixel_y=round(cos(Angle)+32*cos(Angle)*(N+16)/32)
			if(DX==0) Pixel_x=0
			if(DY==0) Pixel_y=0
			if(Pixel_x>32)
				for(var/a=0, a<=Pixel_x, a+=32)
					X.x++
					Pixel_x-=32
			if(Pixel_x<-32)
				for(var/a=0, a>=Pixel_x, a-=32)
					X.x--
					Pixel_x+=32
			if(Pixel_y>32)
				for(var/a=0, a<=Pixel_y, a+=32)
					X.y++
					Pixel_y-=32
			if(Pixel_y<-32)
				for(var/a=0, a>=Pixel_y, a-=32)
					X.y--
					Pixel_y+=32
			X.pixel_x=Pixel_x
			X.pixel_y=Pixel_y
		sleep(3)	//Changing this to a lower value will cause the beam to follow more smoothly with movement, but it will also be more laggy.
					//I've found that 3 ticks provided a nice balance for my use.
	for(var/obj/effect/overlay/beam/O in orange(10, src)) if(O.BeamSource==src) qdel(O)


//All atoms
/atom/proc/examine(mob/user, extra_description = "")
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/full_name = "\a [src]."
	var/output = ""
	if(blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			full_name = "some "
		else
			full_name = "a "
		if(blood_color != "#030303")
			full_name += "<span class='danger'>blood-stained</span> [name]!"
		else
			full_name += "oil-stained [name]."

	output += "<div id='examine'>"
	output += "\icon[src] This is [full_name]"
	if(desc)
		output += "\n[desc]"
	if(extra_description)
		output += "\n[extra_description]"

	if(reagents)
		if(reagent_flags & TRANSPARENT)
			if(LAZYLEN(reagents.reagent_list) > 1)
				if(user.can_see_reagents())
					output += SPAN_NOTICE("\nIt contains:")
					for(var/datum/reagent/R in reagents.reagent_list)
						output += SPAN_NOTICE("\n[R.volume] units of [R.name]")
				else
					output += SPAN_NOTICE("\nIt contains [reagents.total_volume] units of various reagents.")
			else if(length(reagents.reagent_list))
				output += SPAN_NOTICE("\nIt contains [reagents.total_volume] units of [user.can_see_reagents() ? reagents.reagent_list[1].name : "something"]")
			else
				output += SPAN_NOTICE("\nIt's dry.")
		else if(reagent_flags & AMOUNT_VISIBLE)
			output += SPAN_NOTICE("[reagents.total_volume ? "\nIt has [reagents.total_volume] units left." : "\nIt's empty."]")

	var/desc_info = get_description_info()
	if(desc_info)
		output += "\n<font color='#084b8a'><b>[desc_info]</b></font>"

	var/desc_fluff = get_description_fluff()
	if(desc_fluff)
		output += "\n<font color='#298a08'><b>[desc_fluff]</b></font>"

	var/desc_antag = (isghost(user) || player_is_antag(user.mind)) ? get_description_antag() : null
	if(desc_antag)
		output += "\n<font color='#8a0808'><b>[desc_antag]</b></font>"

	output += "</div>"

	if(isobserver(user))
		to_chat(user, output)
	else
		user.visible_message("<font size=1>[user.name] looks at [src].</font>", output)

	to_chat(user, show_stat_verbs()) //rewrite to show_stat_verbs(user)?

	if(ishuman(user) && user.stats && user.stats.getPerk(/datum/perk/greenthumb))
		var/datum/perk/greenthumb/P = user.stats.getPerk(/datum/perk/greenthumb)
		P.virtual_scanner.afterattack(src, user, get_dist(src, user) <= 1)

	SEND_SIGNAL_OLD(src, COMSIG_EXAMINE, user)

	return (get_dist(src, user) <= world.view) || isobserver(user)

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

//called to set the atom's dir and used to add behaviour to dir-changes
/atom/proc/set_dir(new_dir)
	var/old_dir = dir
	if(new_dir == old_dir)
		return FALSE

	for(var/i in src.contents)
		var/atom/A = i
		A.container_dir_changed(new_dir)
	dir = new_dir
	return TRUE

/atom/proc/container_dir_changed(new_dir)
	return

// Explosion action proc , should never SLEEP, and should avoid icon updates , overlays and other visual stuff as much as possible , since they cause massive time delays
// in explosion processing.
/atom/proc/explosion_act(target_power, explosion_handler/handler)
	return 0

/atom/proc/emag_act(remaining_charges, mob/user, emag_source)
	return NO_EMAG_ACT

/atom/proc/fire_act()
	return

/atom/proc/melt()
	return

/atom/proc/ignite_act()	//Proc called on connected igniter activation
	return

/atom/proc/hitby(atom/movable/AM as mob|obj)
	if (density)
		AM.throwing = FALSE
	return

/atom/proc/add_hiddenprint(mob/living/M)
	if(isnull(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.gloves)
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] (Wearing gloves). Real name: [], Key: []", H.real_name, H.key)
				src.fingerprintslast = H.key
			return FALSE
		if (!( src.fingerprints ))
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []", H.real_name, H.key)
				src.fingerprintslast = H.key
			return TRUE
	else
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []", M.real_name, M.key)
			src.fingerprintslast = M.key
	return

/atom/proc/add_fingerprint(mob/living/M, ignoregloves = FALSE)
	if(isnull(M) || isnull(M.key) || isAI(M))
		return

	if(ishuman(M))
		//Add the list if it does not exist.
		if(!fingerprintshidden)
			fingerprintshidden = list()

		//Fibers~
		add_fibers(M)

		//He has no prints!
		if(get_active_mutation(M, MUTATION_NOPRINTS))
			if(fingerprintslast != M.key)
				fingerprintshidden += "(Has no fingerprints) Real name: [M.real_name], Key: [M.key]"
				fingerprintslast = M.key
			return FALSE		//Now, lets get to the dirty work.
		//First, make sure their DNA makes sense.
		var/mob/living/carbon/human/H = M
		if(!H.fingers_trace)
			H.fingers_trace = md5(H.real_name)

		//Now, deal with gloves.
		if (H.gloves && H.gloves != src)
			if(fingerprintslast != H.key)
				fingerprintshidden += text("\[[]\](Wearing gloves). Real name: [], Key: []", time_stamp(), H.real_name, H.key)
				fingerprintslast = H.key
			H.gloves.add_fingerprint(M)

		//Deal with gloves the pass finger/palm prints.
		if(!ignoregloves)
			if(H.gloves != src)
				if(prob(75) && istype(H.gloves, /obj/item/clothing/gloves/latex))
					return FALSE
				else if(H.gloves && !istype(H.gloves, /obj/item/clothing/gloves/latex))
					return FALSE

		//More adminstuffz
		if(fingerprintslast != H.key)
			fingerprintshidden += text("\[[]\]Real name: [], Key: []", time_stamp(), H.real_name, H.key)
			fingerprintslast = H.key

		//Make the list if it does not exist.
		if(!fingerprints)
			fingerprints = list()

		//Hash this shit.
		var/full_print = H.get_full_print()

		// Add the fingerprints
		//
		if(fingerprints[full_print])
			switch(stringpercent(fingerprints[full_print]))		//tells us how many stars are in the current prints.

				if(28 to 32)
					if(prob(1))
						fingerprints[full_print] = full_print 		// You rolled a one buddy.
					else
						fingerprints[full_print] = stars(full_print, rand(0, 40)) // 24 to 32

				if(24 to 27)
					if(prob(3))
						fingerprints[full_print] = full_print     	//Sucks to be you.
					else
						fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

				if(20 to 23)
					if(prob(5))
						fingerprints[full_print] = full_print		//Had a good run didn't ya.
					else
						fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

				if(16 to 19)
					if(prob(5))
						fingerprints[full_print] = full_print		//Welp.
					else
						fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

				if(0 to 15)
					if(prob(5))
						fingerprints[full_print] = stars(full_print, rand(0, 50)) 	// small chance you can smudge.
					else
						fingerprints[full_print] = full_print

		else
			fingerprints[full_print] = stars(full_print, rand(0, 20))	//Initial touch, not leaving much evidence the first time.


		return TRUE
	else
		//Smudge up dem prints some
		if(fingerprintslast != M.key)
			fingerprintshidden += text("\[[]\]Real name: [], Key: []", time_stamp(), M.real_name, M.key)
			fingerprintslast = M.key

	//Cleaning up shit.
	if(fingerprints && !fingerprints.len)
		fingerprints = null
	return


/atom/proc/transfer_fingerprints_to(atom/A)

	if(!istype(A.fingerprints,/list))
		A.fingerprints = list()

	if(!istype(A.fingerprintshidden,/list))
		A.fingerprintshidden = list()

	if(!istype(fingerprintshidden, /list))
		fingerprintshidden = list()

	//skytodo
	//A.fingerprints |= fingerprints            //detective
	//A.fingerprintshidden |= fingerprintshidden    //admin
	if(A.fingerprints && fingerprints)
		A.fingerprints |= fingerprints.Copy()            //detective
	if(A.fingerprintshidden && fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()    //admin	A.fingerprintslast = fingerprintslast


//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M)
	if(flags & NOBLOODY)
		return FALSE

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	was_bloodied = TRUE
	blood_color = "#A10808"
	if(istype(M))
		if(!M.fingers_trace)
			M.fingers_trace = md5(M.real_name)
		if (M.species)
			blood_color = M.species.blood_color
			if(!blood_color)
				return FALSE
	return TRUE

/atom/proc/add_vomit_floor(mob/living/carbon/M, toxvomit = FALSE)
	if( istype(src, /turf) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1, 4)]"

/atom/proc/clean_blood()
	if(!simulated)
		return
	fluorescent = 0
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return TRUE

/atom/proc/get_global_map_pos()
	if(!islist(global_map) || isemptylist(global_map)) return
	var/cur_x
	var/cur_y
	var/list/y_arr
	for(cur_x=1, cur_x<=global_map.len, cur_x++)
		y_arr = global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
	if(cur_x && cur_y)
		return list("x"=cur_x, "y"=cur_y)
	else
		return FALSE

/atom/proc/checkpass(passflag)
	return pass_flags&passflag

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return TRUE
	else
		return FALSE

//Multi-z falling procs


//Execution by grand piano!
/atom/movable/proc/get_fall_damage(turf/from, turf/dest)
	return 42

/atom/movable/proc/fall_impact(turf/from, turf/dest)

//If atom stands under open space, it can prevent fall, or not
/atom/proc/can_prevent_fall(above, atom/movable/thing)
	return FALSE

// Show a message to all mobs and objects in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(message, blind_message, range = world.view)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T,range, mobs, objs, ONLY_GHOSTS_IN_VIEW)

	for(var/obj/O as anything in objs)
		if(!QDELETED(O))
			O.show_message(message,1,blind_message,2)

	for(var/m in mobs)
		var/mob/M = m
		if(M.see_invisible >= invisibility)
			M.show_message(message,1,blind_message,2)
		else if(blind_message)
			M.show_message(blind_message, 2)


// Show a message to all mobs and objects in earshot of this atom
// Use for objects performing audible actions
// message is the message output to anyone who can hear.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/atom/proc/audible_message(message, deaf_message, hearing_distance)

	var/range = world.view
	if(hearing_distance)
		range = hearing_distance
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T,range, mobs, objs, ONLY_GHOSTS_IN_VIEW)

	for(var/m in mobs)
		var/mob/M = m
		M.show_message(message,2,deaf_message,1)
	for(var/o in objs)
		var/obj/O = o
		O.show_message(message,2,deaf_message,1)

/atom/movable/proc/dropInto(atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return forceMove(null)

/atom/proc/onDropInto(atom/movable/AM)
	return // If onDropInto returns null, then dropInto will forceMove AM into us.

/atom/movable/onDropInto(atom/movable/AM)
	return loc // If onDropInto returns something, then dropInto will attempt to drop AM there.


/atom/Entered(atom/movable/AM, atom/old_loc, special_event)
	GLOB.moved_event.raise_event(AM, old_loc, AM.loc)
	GLOB.entered_event.raise_event(src, AM, old_loc)

	// This code makes the light be queued for update when it is moved.
	// Entered() should handle it, however Exited() can do it if it is being moved to nullspace (as there would be no Entered() call in that situation).
	if(AM && old_loc != src)
		for(var/A in AM.light_sources) // Cycle through the light sources on this atom and tell them to update.
			var/datum/light_source/L = A
			L.source_atom.update_light()
	if(loc && special_event)
		AM.forceMove(destination = loc, special_event = TRUE)
		return CANCEL_MOVE_EVENT

/atom/Exited(atom/movable/Obj, atom/newloc)
	GLOB.exited_event.raise_event(src, Obj, newloc)

	if(!newloc && Obj && newloc != src) // Incase the atom is being moved to nullspace, we handle queuing for a lighting update here.
		for(var/A in Obj.light_sources) // Cycle through the light sources on this atom and tell them to update.
			var/datum/light_source/L = A
			L.source_atom.update_light()

/atom/proc/get_footstep_sound()
	return

/atom/proc/set_density(new_density)
	if(density != new_density)
		density = !!new_density

//This proc is called when objects are created during the round by players.
//This allows them to behave differently from objects that are mapped in, adminspawned, or purchased
/atom/proc/Created(mob/user)
	return
	//Should be called when:
		//An item is printed at an autolathe or protolathe **COMPLETE**
		//Item is created at mech fab, organ printer, prosthetics builder, or any other machine which creates things
		//An item is constructed from sheets or any similar crafting system

	//Should NOT be called when:
		//An item is mapped in
		//An item is adminspawned
		//An item is spawned by events
		//An item is delivered on the cargo shuttle
		//An item is purchased or dispensed from a vendor (Those things contain premade items and just release them)

/atom/proc/get_cell()
	return

/atom/proc/get_coords()
	var/turf/T = get_turf(src)
	if (T)
		return new /datum/coords(T)

/atom/proc/change_area(area/old_area, area/new_area)
	return

//Bullethole shit.
/atom/proc/create_bullethole(obj/item/projectile/Proj)
	var/p_x = Proj.p_x + rand(-8,8) // really ugly way of coding "sometimes offset Proj.p_x!"
	var/p_y = Proj.p_y + rand(-8,8) // Used for bulletholes
	var/obj/effect/overlay/bmark/BM = new(src)

	BM.pixel_x = p_x
	BM.pixel_y = p_y
	// offset correction
	BM.pixel_x--
	BM.pixel_y--

	if(Proj.get_structure_damage() >= WEAPON_FORCE_DANGEROUS)//If it does a lot of damage it makes a nice big black hole.
		BM.icon_state = "scorch"
		BM.set_dir(pick(NORTH,SOUTH,EAST,WEST)) // random scorch design
	else //Otherwise it's a light dent.
		BM.icon_state = "light_scorch"

/atom/proc/clear_bulletholes()
	for(var/obj/effect/overlay/bmark/BM in src)
		qdel(BM)


//Returns a list of things in this atom, can be overridden for more nuanced behaviour
/atom/proc/get_contents()
	return contents


/atom/proc/get_recursive_contents()
	var/list/result = list()
	for (var/atom/a in contents)
		result += a
		result |= a.get_recursive_contents()
	return result

/atom/proc/AllowDrop()
	return FALSE

/atom/proc/drop_location()
	var/atom/L = loc
	if(!L)
		return null
	return L.AllowDrop() ? L : L.drop_location()

//Return flags that may be added as part of a mobs sight
/atom/proc/additional_sight_flags()
	return 0

/atom/proc/additional_see_invisible()
	return 0
/atom/proc/lava_act()
	visible_message("<span class='danger'>\The [src] sizzles and melts away, consumed by the lava!</span>")
	playsound(src, 'sound/effects/flare.ogg', 100, 3)
	if(ismob(src))
		var/mob/M = src
		M.death(FALSE, FALSE)
	qdel(src)
	. = TRUE

// Passes Stat Panel clicks to the game and calls client click on an atom
/atom/Topic(href, list/href_list)
	. = ..()
	if(!usr?.client)
		return
	var/client/usr_client = usr.client
	var/list/paramslist = list()
	if(href_list["statpanel_item_shiftclick"])
		paramslist["shift"] = "1"
	if(href_list["statpanel_item_ctrlclick"])
		paramslist["ctrl"] = "1"
	if(href_list["statpanel_item_altclick"])
		paramslist["alt"] = "1"
	if(href_list["statpanel_item_click"])
		var/mouseparams = list2params(paramslist)
		usr_client.Click(src, loc, null, mouseparams)

// Called after we wrench/unwrench this object
/obj/proc/wrenched_change()
	return
