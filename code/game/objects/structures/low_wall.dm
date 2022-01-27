/*
	Low walls are a rou69hly waist-hei69ht wall object which 69oes under full tile windows.

	They share some properties with walls -
		They are tou69h
		They block69ovement

	However they differ from walls in a few important respects:
		They do not block69ision
		They do not restrict 69as flow


	Hence they are69ore like tables, and they share some useful 69ualities with tables
		Crawlin69 animals can69ove over them
		Objects can be placed ontop of them


	Certain table 69ualities do not apply however:
		They have no "underneath" space, nothin69 can be placed under them, creatures can't crawl under them
*/
/obj/structure/low_wall
	density = TRUE
	opacity = 0
	anchored = TRUE
	layer = LOW_WALL_LAYER
	icon = 'icons/obj/structures/low_wall.dmi'
	icon_state = "metal"
	throwpass = TRUE
	var/connected = TRUE
	var/wall_color = PLASTEEL_COLOUR
	var/roundstart = FALSE
	var/list/connections = list("0", "0", "0", "0")
	var/list/wall_connections = list("0", "0", "0", "0")

	var/construction_sta69e

	var/maxhealth = 600
	var/health = 600

	var/hitsound = 'sound/weapons/69enhit.o6969'
	climbable = TRUE

//Derelict tileset
/obj/structure/low_wall/onestar
	wall_color = "#FFFFFF"
	icon_state = "onestar"




//Low walls69ark the turf they're on as a wall.  This is69ital for floor icon updatin69 code
/obj/structure/low_wall/New()
	var/turf/T = loc
	if (istype(T))
		T.is_wall = TRUE
	.=..()

/obj/structure/low_wall/Destroy()
	for (var/obj/structure/window/W in loc)
		if (!69DELETED(W))
			W.shatter()

	//If we're on a floor,69ake it no lon69er be counted as a wall
	var/turf/simulated/floor/T = loc
	if (istype(T))
		T.is_wall = FALSE

	connected = FALSE
	update_connections(1) //Updatin69 connections with false connected will69ake nearby walls i69nore this one
	for(var/obj/structure/low_wall/L in oran69e(src, 1))
		L.update_icon()
	. = ..()



/obj/structure/low_wall/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/low_wall/LateInitialize(var/list/ar69s)
	// One low wall per turf.
	for(var/obj/structure/low_wall/T in loc)
		if(T != src)
			// There's another wall here that's not us, 69et rid of it
			69del(T)
			return

	//if (ar69s)
	//	update_connections(0)
	//else
	//
	update_connections(1)
	update_icon()



/obj/structure/low_wall/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)

	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,tar69et))


	//Its debateable whether its correct to use layer in a lo69ic check like this.
	//The69ain intent is to prevent creatures from walkin69 under the wall in hide69ode, there is no "under" the wall.
	//This is necessary because low walls can't be placed below the hide layer due to shutters
	if(istype(mover) &&69over.checkpass(PASSTABLE) &&69over.layer > layer)
		return 1
	if(locate(/obj/structure/low_wall) in 69et_turf(mover))
		return 1
	if(islivin69(mover))
		var/mob/livin69/L =69over
		if(L.weakened)
			return 1
	return ..()


//Dra69 and drop onto low walls. Copied from tables
//This is69ainly so that janibor69 can put thin69s on tables
/obj/structure/low_wall/MouseDrop_T(atom/A,69ob/user, src_location, over_location, src_control, over_control, params)
	if(!CanMouseDrop(A, user))
		return

	if(ismob(A.loc))
		user.unE69uip(A, loc)
		set_pixel_click_offset(A, params)
		return

	if(istype(A, /obj/item) && istype(A.loc, /turf) && (A.Adjacent(src) || user.Adjacent(src)))
		var/obj/item/O = A
		//Mice can push around pens and paper, but not heavy tools
		if(O.w_class <= user.can_pull_size)
			O.forceMove(loc)
			set_pixel_click_offset(O, params, animate=TRUE)
			return
		else
			to_chat(user, SPAN_WARNIN69("69O69 is too heavy for you to69ove!"))
			return

	return ..()


//Low walls can be climbed over, but only if nothin69 ontop is blockin69 them
//This is needed to stop people 69litchin69 throu69h the window and usin69 them as external airlocks
/obj/structure/low_wall/can_climb(var/mob/livin69/user, post_climb_check=0)
	for(var/obj/structure/window/W in loc)
		if (!W.CanPass(user, loc))
			return FALSE

	return ..()


//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/low_wall/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	cover = 69et_step(loc, 69et_dir(from, loc))
	if(!cover)
		return 1
	if (69et_dist(P.startin69, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (69et_turf(P.ori69inal) == cover)
		var/valid = FALSE
		var/distance = 69et_dist(P.last_interact,loc)
		P.check_hit_zone(loc, distance)

		var/tar69etzone = check_zone(P.def_zone)
		if (tar69etzone in list(BP_R_LE69, BP_L_LE69, BP_69ROIN))
			valid = TRUE //The lower body is always concealed
		if (ismob(P.ori69inal))
			var/mob/M = P.ori69inal
			if (M.lyin69)
				valid = TRUE			//Lyin69 down covers your whole body
		if(valid)
			var/pierce = P.check_penetrate(src)
			health -= P.69et_structure_dama69e()/2
			if (health > 0)
				visible_messa69e(SPAN_WARNIN69("69P69 hits \the 69src69!"))
				return pierce
			else
				visible_messa69e(SPAN_WARNIN69("69src69 breaks down!"))
				69del(src)
				return 1
	return 1


//Icon procs.mostly copied from tables
/obj/structure/low_wall/update_icon()
	overlays.Cut()

	var/ima69e/I

	//Make the wall overlays
	for(var/i = 1 to 4)
		I = ima69e(icon, "69icon_state69_69connections69i6969", dir = 1<<(i-1))
		I.color = wall_color
		overlays += I


	for (var/obj/structure/window/W in loc)
		if (W.is_fulltile())
			W.update_icon()




	for(var/i = 1 to 4)
		I = ima69e(icon, "69icon_state69_over_69wall_connections69i6969", dir = 1<<(i-1))
		I.color = wall_color
		I.layer = ABOVE_WINDOW_LAYER
		overlays += I






//Now this is a bit complex so read carefully
/*
	We link up with other low walls around us, just like any wall, window, table or carpet links up with its own kind
	However we also link up with normal, full sized walls, and the rules for linkin69 with those are different
	Rather than lookin69 in a 1 ran69e, we link up with walls that69eet the followin69 conditions
		1. They are within 1 ran69e of us
		2a. They are cardinally adjacent to us
			-OR-
		2b. They are cardinally adjacent to a low wall which is cardinally adjacent to us
			-OR-
		2c. They are adjacent to two other walls that we are also connected to

	This69eans that if, for example, we're in an I shaped confi69uration,
		with empty spaces to the left and ri69ht, and fullsize walls in the row above and below
		we will only link with the two walls directly above and below us.
		and we will NOT link with the four walls dia69onal to us

		However, if those empty spaces to the sides were filled with other low walls,
		then we would link with all of the hi69h walls around us

*/
//Copied from table.dm, used below
#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIA69ONAL 2
#define CORNER_CLOCKWISE 4

//These tell what each position69eans in the four-element connections list
#define CORNER_NORTHWEST 1
#define CORNER_SOUTHEAST 2
#define CORNER_NORTHEAST 3
#define CORNER_SOUTHWEST 4
/obj/structure/low_wall/proc/update_connections(propa69ate=0,69ar/debu69 = 0)

	//If we are not connected, this will69ake nearby walls for69et us and disconnect from us
	if(!connected)
		connections = list("0", "0", "0", "0")

		if(propa69ate)
			for(var/obj/structure/low_wall/T in oview(src, 1))
				T.update_connections()

			for(var/turf/simulated/wall/T in RAN69E_TURFS(1, src) - src)
				T.update_connections()
		return

	//A list of directions to nearby low walls
	var/list/connection_dirs = list()

	//A list of fullsize walls that we're considerin69 connectin69 to.
	var/list/turf/wall_candidates = list()

	//A list of fullsize walls we will definitely connect to, based on the rules above
	var/list/wall_dirs = list()

	for(var/obj/structure/low_wall/T in oran69e(src, 1))
		if (!T.connected)
			continue

		var/T_dir = 69et_dir(src, T)
		connection_dirs |= T_dir


		if(propa69ate)
			spawn(0)
				T.update_connections()
				T.update_icon()

		//If this low wall is in a cardinal direction to us,
		//then we will 69rab full walls that are cardinal to IT
		//These walls all69eet condition 2b
		if (T_dir in cardinal)
			for (var/d in cardinal)
				var/turf/t = 69et_step(T, d)
				if (istype(t, /turf/simulated/wall))
					wall_candidates |= t

	//We'll use this list in a69oment to store dia69onal tiles that69i69ht be candidates for rule 2C
	var/list/deferred_dia69onals = list()

	//We'll use this to store any direct cardinal hi69h walls we detect in the next step
	var/list/connected_cardinals = list()

	//Now we loop throu69h all the full walls near us. Everythin69 here automatically69eets condition 1
	for(var/turf/simulated/wall/T in RAN69E_TURFS(1, src) - src)
		var/T_dir = 69et_dir(src, T)

		//If this wall is cardinal to us, it69eets condition 2a and passes
		if (T_dir in cardinal)
			connected_cardinals += T_dir
			connection_dirs 	|= T_dir
			wall_dirs 			|= T_dir
		//Alternatively if it's in the wall candidates list compiled above, then it69eets condition 2b and passes
		else if (T in wall_candidates)
			connection_dirs 	|= T_dir
			wall_dirs 			|= T_dir

		//If neither of the above are true, it still has a chance to69eet condition 2c
		else
			deferred_dia69onals |= T_dir

		if(propa69ate)
			spawn(0)
				T.update_connections()
				T.update_icon()

	//Last chance to connect
	//Now we will dump cpnnected_cardinals list into a bitfield to69ake the next section simpler
	var/wall_dirs_bitfield = 0
	for (var/d in connected_cardinals)
		wall_dirs_bitfield |= d

	for (var/d in deferred_dia69onals)
	/*
		Deferred dia69onals list now contains the directions of all fullsize walls which are:
		1. Within 1 tile of this wall
		2. At a dia69onal to this wall
		3. Not at a cardinal to any adjacent low wall

		There is still a possibility to have a connection to these walls under condition 2c,
		That is, if it is adjacent to two other fullsize walls which are already confirmed connections

	*/
		//Since we have everythin69 in a bitfield, we can compare the dia69onals a69ainst it.
		//If both of its cardinals are here, the dia69onal will be too
		if ((wall_dirs_bitfield & d) == d)
			if (debu69)	to_chat(world, "Connected to a dia69onal wall, 69direction_to_text(d)69 69d69, Bitfield 69wall_dirs_bitfield69")
			wall_dirs |= (d)
			connection_dirs |= d

	connections = dirs_to_corner_states(connection_dirs)
	wall_connections = dirs_to_corner_states(wall_dirs)


	/*
		Extra last bonus chance to connect.
		Here we will "up69rade" the wall connections in a few specific cases where the overall connections are better
	*/
	for (var/i = 1;i<=4;i++)
		var/a = text2num(wall_connections69i69)
		var/b = text2num(connections69i69)

		//First of all, if we have a sin69le69ertical hi69h wall connection, but a cross of total connections
		//Then we will up69rade the hi69h wall connections to a cross too. this prevents some bu6969iness
		if ((((i in list(CORNER_NORTHWEST, CORNER_SOUTHEAST)) && a == CORNER_CLOCKWISE) \
		|| ((i in list(CORNER_NORTHEAST, CORNER_SOUTHWEST)) && a == CORNER_COUNTERCLOCKWISE)) \
		&& (b in list(5,7)))
			//What a69ess, all that determines whether a corner connects to only69ertical.
			//If its in the northwest or southeast corner, and its only connection is clockwise, then that connection is either up or down
			//Ditto with the other check
			//The last one is checkin69 if b == a cross or block connection
			wall_connections69i69 = connections69i69

		//Secondly, if we have a cross of two hi69h walls, but a block of total connections,
		//We up69rade wall connections to a block too.
		//This basically69eans treatin69 a dia69onal low wall like a hi69h wall
		else if (a == 5 && b == 7)
			wall_connections69i69 = connections69i69


#undef CORNER_NORTHWEST
#undef CORNER_SOUTHEAST
#undef CORNER_NORTHEAST
#undef CORNER_SOUTHWEST

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIA69ONAL
#undef CORNER_CLOCKWISE




//Attack handlin69, dama69e, deconstructin69, etc.
//Mostly copied and69odified from normal walls
/obj/structure/low_wall/attackby(obj/item/I,69ob/user,69ar/params)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (!user)
		return

	//If the user isn't in harm intent and there's no window ontop of this wall, it is treated like a table.
		//Items used on it will be placed on it like a surface

	var/tool_type = I.69et_tool_type(user, list(69UALITY_WELDIN69), src)
	switch(tool_type)
		if(69UALITY_WELDIN69)
			if (locate(/obj/structure/window) in loc)
				to_chat(user, SPAN_NOTICE("You69ust remove the window69ounted on this wall before it can be repaired or deconstructed"))
				return
			if(locate(/obj/effect/overlay/wallrot) in src)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You burn away the fun69i with \the 69I69."))
					for(var/obj/effect/overlay/wallrot/WR in src)
						69del(WR)
					return
			if(health <69axhealth)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You repair the dama69e to 69src69."))
					take_dama69e(maxhealth - health)
					return
			if(isnull(construction_sta69e))
				to_chat(user, SPAN_NOTICE("You be69in removin69 the outer platin69..."))
				if(I.use_tool(user, src, WORKTIME_LON69, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the outer platin69."))
					dismantle_wall()
					user.visible_messa69e(SPAN_WARNIN69("The wall was torn open by 69user69!"))
					return

	//Turn on harm intent to override this behaviour and instead attack the wall
	if (!(locate(/obj/structure/window) in loc) && user.a_intent != I_HURT)
		if (user.unE69uip(I, src.loc))
			set_pixel_click_offset(I, params)
			return


	//Hittin69 the wall with stuff
	if(!istype(I,/obj/item/rcd) && !istype(I, /obj/item/rea69ent_containers))
		if(!I.force)
			return attack_hand(user)
		var/attackforce = I.force*I.structure_dama69e_factor
		var/dam_threshhold = 150 //Inte69rity of Steel
		var/dam_prob =69in(100,60*1.4) //60 is hardness of steel
		if(ishuman(user))
			var/mob/livin69/carbon/human/attacker = user
			dam_prob -= attacker.stats.69etStat(STAT_ROB)
		if(dam_prob < 100 && attackforce > (dam_threshhold/10))
			playsound(src, hitsound, 80, 1)
			if(!prob(dam_prob))
				visible_messa69e(SPAN_DAN69ER("\The 69user69 attacks \the 69src69 with \the 69I69!"))
				playsound(src, pick(WALLHIT_SOUNDS), 100, 5)
				take_dama69e(attackforce)
			else
				visible_messa69e(SPAN_WARNIN69("\The 69user69 attacks \the 69src69 with \the 69I69!"))
		else
			visible_messa69e(SPAN_DAN69ER("\The 69user69 attacks \the 69src69 with \the 69I69, but it bounces off!"))
		user.do_attack_animation(src)
		return



/obj/structure/low_wall/proc/dismantle_wall(var/devastated,69ar/explode,69ar/no_product)
	if (69DELETED(src))
		return
	playsound(src, 'sound/items/Welder.o6969', 100, 1)
	if(!no_product)
		new /obj/structure/69irder/low(loc)
		new /obj/item/stack/material/steel(loc, 1)

	clear_plants()
	update_connections(1)
	69del(src)


/obj/structure/low_wall/proc/take_dama69e(dam)
	if(locate(/obj/effect/overlay/wallrot) in src)
		dam *= 10

	health -= dam
	update_dama69e()

/obj/structure/low_wall/proc/update_dama69e()
	if(health < 0)
		dismantle_wall()
	else
		update_icon()

/obj/structure/low_wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		69del(WR)
	for(var/obj/effect/plant/plant in ran69e(src, 1))
		if(plant.wall_mount == src) //shrooms drop to the floor
			69del(plant)
		plant.update_nei69hbors()


/obj/structure/low_wall/affect_69rab(var/mob/livin69/user,69ar/mob/livin69/tar69et,69ar/state)
	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, SPAN_DAN69ER("There's \a 69occupied69 in the way."))
		return
	if(state < 69RAB_A6969RESSIVE || tar69et.loc==src.loc)
		if(user.a_intent == I_HURT)
			if(prob(15))
				tar69et.Weaken(5)
			tar69et.dama69e_throu69h_armor(12, BRUTE, BP_HEAD, ARMOR_MELEE)
			visible_messa69e(SPAN_DAN69ER("69user69 slams 69tar69et69's face a69ainst \the 69src69!"))
			playsound(loc, 'sound/weapons/tablehit1.o6969', 50, 1)

		else
			to_chat(user, SPAN_DAN69ER("You need a better 69rip to do that!"))
			return
	else
		tar69et.forceMove(loc)
		tar69et.Weaken(5)
		visible_messa69e(SPAN_DAN69ER("69user69 puts 69tar69et69 on \the 69src69."))
		tar69et.attack_lo69 += "\6969time_stamp()69\69 <font color='oran69e'>Has been put on \the 69src69 by 69user.name69 (69user.ckey69 )</font>"
		user.attack_lo69 += "\6969time_stamp()69\69 <font color='red'>Puts 69tar69et.name69 (69tar69et.ckey69 on \the 69src69)</font>"
		ms69_admin_attack("69user69 puts a 69tar69et69 on \the 69src69.")
	return TRUE


