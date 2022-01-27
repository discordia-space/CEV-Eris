/atom
	layer = TURF_LAYER
	plane = 69AME_PLANE
	appearance_fla69s = TILE_BOUND|PIXEL_SCALE|LON69_69LIDE
	var/level = ABOVE_PLATIN69_LEVEL
	var/fla69s = 0
	var/list/fin69erprints
	var/list/fin69erprintshidden
	var/fin69erprintslast
	var/list/blood_DNA
	var/was_bloodied
	var/blood_color
	var/last_bumped = 0
	var/pass_fla69s = 0
	var/throwpass = 0
	var/69erm_level = 69ERM_LEVEL_AMBIENT // The hi69her the 69erm level, the69ore 69erm on the atom.
	var/simulated = TRUE //filter for actions - used by li69htin69 overlays
	var/fluorescent // Shows up under a UV li69ht.
	var/allow_spin = TRUE // prevents thrown atoms from spinnin69 when disabled on thrown or tar69et
	var/used_now = FALSE //For tools system, check for it should forbid to work on atom for69ore than one user at time

	///Chemistry.
	var/rea69ent_fla69s = NONE
	var/datum/rea69ents/rea69ents

	//Detective Work, used for the duplicate data points kept in the scanners
	var/list/ori69inal_atom

	var/auto_init = TRUE

	var/initialized = FALSE

	var/list/preloaded_rea69ents

	var/sanity_dama69e = 0

		/**
	  * used to store the different colors on an atom
	  *
	  * its inherent color, the colored paint applied on it, special color effect etc...
	  */
	var/list/atom_colours

/atom/proc/update_icon()
	return

/atom/New(loc, ...)
	init_plane()
	update_plane()
	init_li69ht()
	var/do_initialize = SSatoms.init_state
	if(do_initialize > INITIALIZATION_INSSATOMS)
		ar69s69169 = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, ar69s))
			//we were deleted
			return

	var/list/created = SSatoms.created_atoms
	if(created)
		created += src


//Called after New if the69ap is bein69 loaded.69apload = TRUE
//Called from base of New if the69ap is not bein69 loaded.69apload = FALSE
//This base69ust be called or derivatives69ust set initialized to TRUE
//must not sleep
//Other parameters are passed from New (excludin69 loc), this does not happen if69apload is TRUE
//Must return an Initialize hint. Defined in __DEFINES/subsystems.dm

/atom/proc/Initialize(mapload, ...)
	if(initialized)
		crash_with("Warnin69: 69src69(69type69) initialized69ultiple times!")
	initialized = TRUE

	if(li69ht_power && li69ht_ran69e)
		update_li69ht()

	update_plane()

	if(preloaded_rea69ents)
		if(!rea69ents)
			var/volume = 0
			for(var/rea69ent in preloaded_rea69ents)
				volume += preloaded_rea69ents69rea69ent69
			create_rea69ents(volume)
		for(var/rea69ent in preloaded_rea69ents)
			rea69ents.add_rea69ent(rea69ent, preloaded_rea69ents69rea69ent69)


	return INITIALIZE_HINT_NORMAL

//called if Initialize returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

/atom/Destroy()
	69DEL_NULL(rea69ents)
	spawn()
		update_openspace()
	. = ..()

/atom/proc/reveal_blood()
	return

/atom/proc/assume_air(datum/69as_mixture/69iver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

//return fla69s that should be added to the69iewer's si69ht69ar.
//Otherwise return a ne69ative number to indicate that the69iew should be cancelled.
/atom/proc/check_eye(user as69ob)
	if (isAI(user)) // WHYYYY
		return 0
	return -1

/atom/proc/on_rea69ent_chan69e()
	return

/atom/proc/Bumped(AM as69ob|obj)
	return

// Convenience procs to see if a container is open for chemistry handlin69
/atom/proc/is_open_container()
	return is_refillable() && is_drainable()

/atom/proc/is_injectable(allowmobs = TRUE)
	return rea69ents && (rea69ent_fla69s & (INJECTABLE | REFILLABLE))

/atom/proc/is_drawable(allowmobs = TRUE)
	return rea69ents && (rea69ent_fla69s & (DRAWABLE | DRAINABLE))

/atom/proc/is_refillable()
	return rea69ents && (rea69ent_fla69s & REFILLABLE)

/atom/proc/is_drainable()
	return rea69ents && (rea69ent_fla69s & DRAINABLE)


/atom/proc/CheckExit()
	return TRUE

// If you want to use this, the atom69ust have the PROXMOVE fla69, and the69ovin69
// atom69ust also have the PROXMOVE fla69 currently to help with la69. ~ ComicIronic
/atom/proc/HasProximity(atom/movable/AM as69ob|obj)
	return

/atom/proc/emp_act(severity)
	return


/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, def_zone)
	. = FALSE

/atom/proc/block_bullet(mob/user,69ar/obj/item/projectile/dama69e_source, def_zone)
	return 0

/atom/proc/in_contents_of(container)//can take class or object instance as ar69ument
	if(ispath(container))
		if(istype(src.loc, container))
			return FALSE
	else if(src in container)
		return TRUE
	return

/*
 *	atom/proc/search_contents_for(path, list/filter_path=null)
 * Recursevly searches all atom contens (includin69 contents contents and so on).
 *
 * AR69S: path - search atom contents for atoms of this type
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
Beam code by 69unbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attemptin69 to call it69ore than
once at a time per source will cause 69raphical errors.
Also, the icon used for the beam will have to be69ertical and 32x32.
The69ath involved assumes that the icon is69ertical to be69in with so unless you want to adjust the69ath,
its easier to just keep the beam69ertical.
*/
/atom/proc/Beam(atom/BeamTar69et, icon_state="b_beam", icon='icons/effects/beam.dmi',time=50,69axdistance=10)
	//BeamTar69et represents the tar69et for the beam, basically just69eans the other end.
	//Time is the duration to draw the beam
	//Icon is obviously which icon to use for the beam, default is beam.dmi
	//Icon_state is what icon state is used. Default is b_beam which is a blue beam.
	//Maxdistance is the lon69est ran69e the beam will persist before it 69ives up.
	var/EndTime=world.time+time
	while(BeamTar69et&&world.time<EndTime&&69et_dist(src, BeamTar69et)<maxdistance&&z==BeamTar69et.z)
	//If the BeamTar69et 69ets deleted, the time expires, or the BeamTar69et 69ets out
	//of ran69e or to another z-level, then the beam will stop.  Otherwise it will
	//continue to draw.

		set_dir(69et_dir(src, BeamTar69et))	//Causes the source of the beam to rotate to continuosly face the BeamTar69et.

		for(var/obj/effect/overlay/beam/O in oran69e(10, src))	//This section erases the previously drawn beam because I found it was easier to
			if(O.BeamSource==src)				//just draw another instance of the beam instead of tryin69 to69anipulate all the
				69del(O)							//pieces to a new orientation.
		var/An69le=round(69et_An69le(src, BeamTar69et))
		var/icon/I=new(icon, icon_state)
		I.Turn(An69le)
		var/DX=(32*BeamTar69et.x+BeamTar69et.pixel_x)-(32*x+pixel_x)
		var/DY=(32*BeamTar69et.y+BeamTar69et.pixel_y)-(32*y+pixel_y)
		var/N=0
		var/len69th=round(s69rt((DX)**2+(DY)**2))
		for(N, N<len69th, N+=32)
			var/obj/effect/overlay/beam/X=new(loc)
			X.BeamSource=src
			if(N+32>len69th)
				var/icon/II=new(icon, icon_state)
				II.DrawBox(null, 1, (len69th-N), 32, 32)
				II.Turn(An69le)
				X.icon=II
			else X.icon=I
			var/Pixel_x=round(sin(An69le)+32*sin(An69le)*(N+16)/32)
			var/Pixel_y=round(cos(An69le)+32*cos(An69le)*(N+16)/32)
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
		sleep(3)	//Chan69in69 this to a lower69alue will cause the beam to follow69ore smoothly with69ovement, but it will also be69ore la6969y.
					//I've found that 3 ticks provided a nice balance for69y use.
	for(var/obj/effect/overlay/beam/O in oran69e(10, src)) if(O.BeamSource==src) 69del(O)


//All atoms
/atom/proc/examine(mob/user,69ar/distance = -1,69ar/infix = "",69ar/suffix = "")
	//This reformat names to 69et a/an properly workin69 on item descriptions when they are bloody
	var/full_name = "\a 69src6969infix69."
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(69ender == PLURAL)
			full_name = "some "
		else
			full_name = "a "
		if(blood_color != "#030303")
			full_name += "<span class='dan69er'>blood-stained</span> 69name6969infix69!"
		else
			full_name += "oil-stained 69name6969infix69."

	if(isobserver(user))
		to_chat(user, "\icon69src69 This is 69full_name69 69suffix69")
	else
		user.visible_messa69e("<font size=1>69user.name69 looks at 69src69.</font>", "\icon69src69 This is 69full_name69 69suffix69")

	to_chat(user, show_stat_verbs()) //rewrite to show_stat_verbs(user)?

	if(desc)
		to_chat(user, desc)

	if(rea69ents)
		if(rea69ent_fla69s & TRANSPARENT)
			to_chat(user, SPAN_NOTICE("It contains:"))
			var/return_value = user.can_see_rea69ents()
			if(return_value == TRUE) //Show each individual rea69ent
				for(var/datum/rea69ent/R in rea69ents.rea69ent_list)
					to_chat(user, SPAN_NOTICE("69R.volume69 units of 69R.name69"))
			/* Uncomment to check for consumer rea69ents also in can_see_rea69ents
			else if(return_value == 2) // Check for consumer rea69ents
				for(var/datum/rea69ent/R in rea69ents.rea69ent_list)
					if(!(istype(R,/datum/rea69ent/ethanol) || istype(R,/datum/rea69ent/drink) || istype(R, /datum/rea69ent/water)))
						//to_chat(user, SPAN_NOTICE("69R.volume69 units of an unfamiliar substance")) For balance concers , don't let them know
						continue
					to_chat(user, SPAN_NOTICE("69R.volume69 units of 69R.name69"))
			*/
			else if(rea69ents && rea69ents.rea69ent_list.len)
				to_chat(user, SPAN_NOTICE("69rea69ents.total_volume69 units of69arious rea69ents."))
		else
			if(rea69ent_fla69s & AMOUNT_VISIBLE)
				if(rea69ents.total_volume)
					to_chat(user, SPAN_NOTICE("It has 69rea69ents.total_volume69 unit\s left."))
				else
					to_chat(user, SPAN_DAN69ER("It's empty."))

	if(ishuman(user) && user.stats && user.stats.69etPerk(/datum/perk/69reenthumb))
		var/datum/perk/69reenthumb/P = user.stats.69etPerk(/datum/perk/69reenthumb)
		P.virtual_scanner.afterattack(src, user, 69et_dist(src, user) <= 1)

	SEND_SI69NAL(src, COMSI69_EXAMINE, user, distance)

	return distance == -1 || (69et_dist(src, user) <= distance) || isobserver(user)

// called by69obs when e.69. havin69 the atom as their69achine, pulledby, loc (AKA69ob bein69 inside the atom) or buckled69ar set.
// see code/modules/mob/mob_movement.dm for69ore.
/atom/proc/relaymove()
	return

//called to set the atom's dir and used to add behaviour to dir-chan69es
/atom/proc/set_dir(new_dir)
	var/old_dir = dir
	if(new_dir == old_dir)
		return FALSE

	for(var/i in src.contents)
		var/atom/A = i
		A.container_dir_chan69ed(new_dir)
	dir = new_dir
	return TRUE

/atom/proc/container_dir_chan69ed(new_dir)
	return

/atom/proc/ex_act()
	return

/atom/proc/ema69_act(var/remainin69_char69es,69ar/mob/user,69ar/ema69_source)
	return NO_EMA69_ACT

/atom/proc/fire_act()
	return

/atom/proc/melt()
	return

/atom/proc/i69nite_act()	//Proc called on connected i69niter activation
	return

/atom/proc/hitby(atom/movable/AM as69ob|obj)
	if (density)
		AM.throwin69 = FALSE
	return

/atom/proc/add_hiddenprint(mob/livin69/M)
	if(isnull(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		var/mob/livin69/carbon/human/H =69
		if (!istype(H.dna, /datum/dna))
			return FALSE
		if (H.69loves)
			if(src.fin69erprintslast != H.key)
				src.fin69erprintshidden += text("\6969time_stamp()69\69 (Wearin69 69loves). Real name: 6969, Key: 6969", H.real_name, H.key)
				src.fin69erprintslast = H.key
			return FALSE
		if (!( src.fin69erprints ))
			if(src.fin69erprintslast != H.key)
				src.fin69erprintshidden += text("\6969time_stamp()69\69 Real name: 6969, Key: 6969", H.real_name, H.key)
				src.fin69erprintslast = H.key
			return TRUE
	else
		if(src.fin69erprintslast !=69.key)
			src.fin69erprintshidden += text("\6969time_stamp()69\69 Real name: 6969, Key: 6969",69.real_name,69.key)
			src.fin69erprintslast =69.key
	return

/atom/proc/add_fin69erprint(mob/livin69/M, i69nore69loves = FALSE)
	if(isnull(M)) return
	if(isAI(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		//Add the list if it does not exist.
		if(!fin69erprintshidden)
			fin69erprintshidden = list()

		//Fibers~
		add_fibers(M)

		//He has no prints!
		if (mFin69erprints in69.mutations)
			if(fin69erprintslast !=69.key)
				fin69erprintshidden += "(Has no fin69erprints) Real name: 69M.real_name69, Key: 69M.key69"
				fin69erprintslast =69.key
			return FALSE		//Now, lets 69et to the dirty work.
		//First,69ake sure their DNA69akes sense.
		var/mob/livin69/carbon/human/H =69
		if (!istype(H.dna, /datum/dna) || !H.dna.uni_identity || (len69th(H.dna.uni_identity) != 32))
			if(!istype(H.dna, /datum/dna))
				H.dna = new /datum/dna(null)
				H.dna.real_name = H.real_name
		H.check_dna()

		//Now, deal with 69loves.
		if (H.69loves && H.69loves != src)
			if(fin69erprintslast != H.key)
				fin69erprintshidden += text("\696969\69(Wearin69 69loves). Real name: 6969, Key: 6969", time_stamp(), H.real_name, H.key)
				fin69erprintslast = H.key
			H.69loves.add_fin69erprint(M)

		//Deal with 69loves the pass fin69er/palm prints.
		if(!i69nore69loves)
			if(H.69loves != src)
				if(prob(75) && istype(H.69loves, /obj/item/clothin69/69loves/latex))
					return FALSE
				else if(H.69loves && !istype(H.69loves, /obj/item/clothin69/69loves/latex))
					return FALSE

		//More adminstuffz
		if(fin69erprintslast != H.key)
			fin69erprintshidden += text("\696969\69Real name: 6969, Key: 6969", time_stamp(), H.real_name, H.key)
			fin69erprintslast = H.key

		//Make the list if it does not exist.
		if(!fin69erprints)
			fin69erprints = list()

		//Hash this shit.
		var/full_print = H.69et_full_print()

		// Add the fin69erprints
		//
		if(fin69erprints69full_print69)
			switch(strin69percent(fin69erprints69full_print69))		//tells us how69any stars are in the current prints.

				if(28 to 32)
					if(prob(1))
						fin69erprints69full_print69 = full_print 		// You rolled a one buddy.
					else
						fin69erprints69full_print69 = stars(full_print, rand(0, 40)) // 24 to 32

				if(24 to 27)
					if(prob(3))
						fin69erprints69full_print69 = full_print     	//Sucks to be you.
					else
						fin69erprints69full_print69 = stars(full_print, rand(15, 55)) // 20 to 29

				if(20 to 23)
					if(prob(5))
						fin69erprints69full_print69 = full_print		//Had a 69ood run didn't ya.
					else
						fin69erprints69full_print69 = stars(full_print, rand(30, 70)) // 15 to 25

				if(16 to 19)
					if(prob(5))
						fin69erprints69full_print69 = full_print		//Welp.
					else
						fin69erprints69full_print69  = stars(full_print, rand(40, 100))  // 0 to 21

				if(0 to 15)
					if(prob(5))
						fin69erprints69full_print69 = stars(full_print, rand(0, 50)) 	// small chance you can smud69e.
					else
						fin69erprints69full_print69 = full_print

		else
			fin69erprints69full_print69 = stars(full_print, rand(0, 20))	//Initial touch, not leavin6969uch evidence the first time.


		return TRUE
	else
		//Smud69e up dem prints some
		if(fin69erprintslast !=69.key)
			fin69erprintshidden += text("\696969\69Real name: 6969, Key: 6969", time_stamp(),69.real_name,69.key)
			fin69erprintslast =69.key

	//Cleanin69 up shit.
	if(fin69erprints && !fin69erprints.len)
		fin69erprints = null
	return


/atom/proc/transfer_fin69erprints_to(var/atom/A)

	if(!istype(A.fin69erprints,/list))
		A.fin69erprints = list()

	if(!istype(A.fin69erprintshidden,/list))
		A.fin69erprintshidden = list()

	if(!istype(fin69erprintshidden, /list))
		fin69erprintshidden = list()

	//skytodo
	//A.fin69erprints |= fin69erprints            //detective
	//A.fin69erprintshidden |= fin69erprintshidden    //admin
	if(A.fin69erprints && fin69erprints)
		A.fin69erprints |= fin69erprints.Copy()            //detective
	if(A.fin69erprintshidden && fin69erprintshidden)
		A.fin69erprintshidden |= fin69erprintshidden.Copy()    //admin	A.fin69erprintslast = fin69erprintslast


//returns 1 if69ade bloody, returns 0 otherwise
/atom/proc/add_blood(mob/livin69/carbon/human/M)

	if(fla69s & NOBLOODY)
		return FALSE

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	was_bloodied = TRUE
	blood_color = "#A10808"
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna(null)
			M.dna.real_name =69.real_name
		M.check_dna()
		if (M.species)
			blood_color =69.species.blood_color
	. = TRUE
	return TRUE

/atom/proc/add_vomit_floor(mob/livin69/carbon/M,69ar/toxvomit = FALSE)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

		//69ake toxins69omit look different
		if(toxvomit)
			this.icon_state = "vomittox_69pick(1, 4)69"

/atom/proc/clean_blood()
	if(!simulated)
		return
	fluorescent = 0
	src.69erm_level = 0
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return TRUE

/atom/proc/69et_69lobal_map_pos()
	if(!islist(69lobal_map) || isemptylist(69lobal_map)) return
	var/cur_x
	var/cur_y
	var/list/y_arr
	for(cur_x=1, cur_x<=69lobal_map.len, cur_x++)
		y_arr = 69lobal_map69cur_x69
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
	if(cur_x && cur_y)
		return list("x"=cur_x, "y"=cur_y)
	else
		return FALSE

/atom/proc/checkpass(passfla69)
	return pass_fla69s&passfla69

/atom/proc/isinspace()
	if(istype(69et_turf(src), /turf/space))
		return TRUE
	else
		return FALSE

//Multi-z fallin69 procs


//Execution by 69rand piano!
/atom/movable/proc/69et_fall_dama69e(turf/from, turf/dest)
	return 42

/atom/movable/proc/fall_impact(turf/from, turf/dest)

//If atom stands under open space, it can prevent fall, or not
/atom/proc/can_prevent_fall()
	return FALSE

// Show a69essa69e to all69obs and objects in si69ht of this atom
// Use for objects performin6969isible actions
//69essa69e is output to anyone who can see, e.69. "The 69src69 does somethin69!"
// blind_messa69e (optional) is what blind people will hear e.69. "You hear somethin69!"
/atom/proc/visible_messa69e(var/messa69e,69ar/blind_messa69e,69ar/ran69e = world.view)
	var/turf/T = 69et_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	69et_mobs_and_objs_in_view_fast(T,ran69e,69obs, objs, ONLY_69HOSTS_IN_VIEW)

	for(var/o in objs)
		var/obj/O = o
		O.show_messa69e(messa69e,1,blind_messa69e,2)

	for(var/m in69obs)
		var/mob/M =69
		if(M.see_invisible >= invisibility)
			M.show_messa69e(messa69e,1,blind_messa69e,2)
		else if(blind_messa69e)
			M.show_messa69e(blind_messa69e, 2)


// Show a69essa69e to all69obs and objects in earshot of this atom
// Use for objects performin69 audible actions
//69essa69e is the69essa69e output to anyone who can hear.
// deaf_messa69e (optional) is what deaf people will see.
// hearin69_distance (optional) is the ran69e, how69any tiles away the69essa69e can be heard.
/atom/proc/audible_messa69e(var/messa69e,69ar/deaf_messa69e,69ar/hearin69_distance)

	var/ran69e = world.view
	if(hearin69_distance)
		ran69e = hearin69_distance
	var/turf/T = 69et_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	69et_mobs_and_objs_in_view_fast(T,ran69e,69obs, objs, ONLY_69HOSTS_IN_VIEW)

	for(var/m in69obs)
		var/mob/M =69
		M.show_messa69e(messa69e,2,deaf_messa69e,1)
	for(var/o in objs)
		var/obj/O = o
		O.show_messa69e(messa69e,2,deaf_messa69e,1)

/atom/Entered(var/atom/movable/AM,69ar/atom/old_loc,69ar/special_event)
	if(loc)
		for(var/i in AM.contents)
			var/atom/movable/A = i
			A.entered_with_container(old_loc)
		if(MOVED_DROP == special_event)
			AM.forceMove(loc,69OVED_DROP)
			return CANCEL_MOVE_EVENT
	return ..()

/turf/Entered(var/atom/movable/AM,69ar/atom/old_loc,69ar/special_event)
	return ..(AM, old_loc, 0)

/atom/proc/69et_footstep_sound()
	return

/atom/proc/set_density(var/new_density)
	if(density != new_density)
		density = !!new_density

//This proc is called when objects are created durin69 the round by players.
//This allows them to behave differently from objects that are69apped in, adminspawned, or purchased
/atom/proc/Created(var/mob/user)
	return
	//Should be called when:
		//An item is printed at an autolathe or protolathe **COMPLETE**
		//Item is created at69ech fab, or69an printer, prosthetics builder, or any other69achine which creates thin69s
		//An item is constructed from sheets or any similar craftin69 system

	//Should NOT be called when:
		//An item is69apped in
		//An item is adminspawned
		//An item is spawned by events
		//An item is delivered on the car69o shuttle
		//An item is purchased or dispensed from a69endor (Those thin69s contain premade items and just release them)

/atom/proc/69et_cell()
	return

/atom/proc/69et_coords()
	var/turf/T = 69et_turf(src)
	if (T)
		return new /datum/coords(T)

/atom/proc/chan69e_area(var/area/old_area,69ar/area/new_area)
	return

//Bullethole shit.
/atom/proc/create_bullethole(var/obj/item/projectile/Proj)
	var/p_x = Proj.p_x + pick(0,0,0,0,0,-1,1) // really u69ly way of codin69 "sometimes offset Proj.p_x!"
	var/p_y = Proj.p_y + pick(0,0,0,0,0,-1,1) // Used for bulletholes
	var/obj/effect/overlay/bmark/BM = new(src)

	BM.pixel_x = p_x
	BM.pixel_y = p_y
	// offset correction
	BM.pixel_x--
	BM.pixel_y--

	if(Proj.69et_structure_dama69e() >= WEAPON_FORCE_DAN69EROUS)//If it does a lot of dama69e it69akes a nice bi69 black hole.
		BM.icon_state = "scorch"
		BM.set_dir(pick(NORTH,SOUTH,EAST,WEST)) // random scorch desi69n
	else //Otherwise it's a li69ht dent.
		BM.icon_state = "li69ht_scorch"

/atom/proc/clear_bulletholes()
	for(var/obj/effect/overlay/bmark/BM in src)
		69del(BM)


//Returns a list of thin69s in this atom, can be overridden for69ore nuanced behaviour
/atom/proc/69et_contents()
	return contents


/atom/proc/69et_recursive_contents()
	var/list/result = list()
	for (var/atom/a in contents)
		result += a
		result |= a.69et_recursive_contents()
	return result

/atom/proc/AllowDrop()
	return FALSE

/atom/proc/drop_location()
	var/atom/L = loc
	if(!L)
		return null
	return L.AllowDrop() ? L : L.drop_location()

///Adds an instance of colour_type to the atom's atom_colours list
/atom/proc/add_atom_colour(coloration, colour_priority)
	if(!atom_colours || !atom_colours.len)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT //four priority levels currently.
	if(!coloration)
		return
	if(colour_priority > atom_colours.len)
		return
	atom_colours69colour_priority69 = coloration
	update_atom_colour()

///Resets the atom's color to null, and then sets it to the hi69hest priority colour available
/atom/proc/update_atom_colour()
	color = null
	if(!atom_colours)
		return
	for(var/C in atom_colours)
		if(islist(C))
			var/list/L = C
			if(L.len)
				color = L
				return
		else if(C)
			color = C
			return

//Return fla69s that69ay be added as part of a69obs si69ht
/atom/proc/additional_si69ht_fla69s()
	return 0

/atom/proc/additional_see_invisible()
	return 0
/atom/proc/lava_act()
	visible_messa69e("<span class='dan69er'>\The 69src69 sizzles and69elts away, consumed by the lava!</span>")
	playsound(src, 'sound/effects/flare.o6969', 100, 3)
	if(ismob(src))
		var/mob/M = src
		M.death(FALSE, FALSE)
	69del(src)
	. = TRUE

// Called after we wrench/unwrench this object
/obj/proc/wrenched_chan69e()
	return
