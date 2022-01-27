/obj/vehicle/train
	name = "train"
	dir = 4

	move_delay = 1

	health = 100
	maxhealth = 100
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5

	var/active_en69ines = 0
	var/train_len69th = 0

	var/obj/vehicle/train/lead
	var/obj/vehicle/train/tow


//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/Initialize()
	. = ..()
	for(var/obj/vehicle/train/T in oran69e(1, src))
		latch(T)

/obj/vehicle/train/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	var/old_loc = 69et_turf(src)
	if((. = ..()))
		if(tow)
			tow.Move(old_loc)
		return 1
	else
		if(lead)
			unattach()
		return 0

/obj/vehicle/train/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = 69et_step(A, dir)
		if(isturf(T))
			A.Move(T)	//bump thin69s away when hit

	if(ema6969ed)
		if(islivin69(A))
			var/mob/livin69/M = A
			visible_messa69e("\red 69src69 knocks over 69M69!")
			M.apply_effects(5, 5)				//knock people down if you hit them
			M.apply_dama69es(22 /69ove_delay)	// and do dama69e accordin69 to how fast the train is 69oin69

			var/dama69e = rand(5,15)
			M.dama69e_throu69h_armor( 2  * dama69e /69ove_delay, BRUTE, BP_HEAD, ARMOR_MELEE)
			M.dama69e_throu69h_armor( 2  * dama69e /69ove_delay, BRUTE, BP_CHEST, ARMOR_MELEE)
			M.dama69e_throu69h_armor(0.5 * dama69e /69ove_delay, BRUTE, BP_L_LE69, ARMOR_MELEE)
			M.dama69e_throu69h_armor(0.5 * dama69e /69ove_delay, BRUTE, BP_R_LE69, ARMOR_MELEE)
			M.dama69e_throu69h_armor(0.5 * dama69e /69ove_delay, BRUTE, BP_L_ARM, ARMOR_MELEE)
			M.dama69e_throu69h_armor(0.5 * dama69e /69ove_delay, BRUTE, BP_R_ARM, ARMOR_MELEE)

			if(ishuman(load))
				var/mob/livin69/D = load
				to_chat(D, "\red You hit 696969!")
				ms69_admin_attack("69D.nam6969 (69D.ck69y69) hit 69M.n69me69 (69M.69key69) with 699src69. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=669src.x69;Y=699src.y69;Z6969src.z69'>JMP</a>)")


//-------------------------------------------
//69ehicle procs
//-------------------------------------------
/obj/vehicle/train/explode()
	if (tow)
		tow.unattach()
	unattach()
	..()


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/relaymove(mob/user, direction)
	var/turf/T = 69et_step_to(src, 69et_step(src, direction))
	if(!T)
		to_chat(user, "You can't find a clear area to step onto.")
		return 0

	if(user != load)
		if(user in src)		//for handlin69 players stuck in src - this shouldn't happen - but just in case it does
			user.forceMove(T)
			return 1
		return 0

	unload(user, direction)

	to_chat(user, "\blue You climb down from 69sr6969.")

	return 1

/obj/vehicle/train/MouseDrop_T(var/atom/movable/C,69ob/user as69ob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C) || !istype(C) || (user == C && !user.canmove))
		return
	if(istype(C,/obj/vehicle/train))
		latch(C, user)
	else
		if(!load(C))
			to_chat(user, "\red You were unable to load 696969 on 69s69c69.")

/obj/vehicle/train/attack_hand(mob/user as69ob)
	if(user.stat || user.restrained() || !Adjacent(user))
		return 0

	if(user != load && (user in src))
		user.forceMove(loc)			//for handlin69 players stuck in src
	else if(load)
		unload(user)			//unload if loaded
	else if(!load && !user.buckled)
		load(user)				//else try climbin69 on board
	else
		return 0

/obj/vehicle/train/verb/unlatch_v()
	set69ame = "Unlatch"
	set desc = "Unhitches this train from the one in front of it."
	set cate69ory = "Vehicle"
	set src in69iew(1)

	if(!ishuman(usr))
		return

	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return

	unattach(usr)


//-------------------------------------------
// Latchin69/unlatchin69 procs
//-------------------------------------------

//attempts to attach src as a follower of the train T
//Note: there is a69odified69ersion of this in code\modules\vehicles\car69o_train.dm specifically for car69o train en69ines
/obj/vehicle/train/proc/attach_to(obj/vehicle/train/T,69ob/user)
	if (69et_dist(src, T) > 1)
		to_chat(user, "\red 69sr6969 is too far away from 669T69 to hitch them to69ether.")
		return

	if (lead)
		to_chat(user, "\red 69sr6969 is already hitched to somethin69.")
		return

	if (T.tow)
		to_chat(user, "\red 696969 is already towin69 somethin69.")
		return

	//check for cycles.
	var/obj/vehicle/train/next_car = T
	while (next_car)
		if (next_car == src)
			to_chat(user, "\red That seems69ery silly.")
			return
		next_car =69ext_car.lead

	//latch with src as the follower
	lead = T
	T.tow = src
	set_dir(lead.dir)

	if(user)
		to_chat(user, "\blue You hitch 69sr6969 to 669T69.")

	update_stats()


//detaches the train from whatever is towin69 it
/obj/vehicle/train/proc/unattach(mob/user)
	if (!lead)
		to_chat(user, "\red 69sr6969 is69ot hitched to anythin69.")
		return

	lead.tow =69ull
	lead.update_stats()

	to_chat(user, "\blue You unhitch 69sr6969 from 69le69d69.")
	lead =69ull

	update_stats()

/obj/vehicle/train/proc/latch(obj/vehicle/train/T,69ob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	var/T_dir = 69et_dir(src, T)	//fi69ure out where T is wrt src

	if(dir == T_dir) 	//if car is ahead
		src.attach_to(T, user)
	else if(reverse_direction(dir) == T_dir)	//else if car is behind
		T.attach_to(src, user)

//returns 1 if this is the lead car of the train
/obj/vehicle/train/proc/is_train_head()
	if (lead)
		return 0
	return 1

//-------------------------------------------------------
// Stat update procs
//
// Used for updatin69 the stats for how lon69 the train is.
// These are useful for calculatin69 speed based on the
// size of the train, to limit super lon69 trains.
//-------------------------------------------------------
/obj/vehicle/train/update_stats()
	//first, seek to the end of the train
	var/obj/vehicle/train/T = src
	while(T.tow)
		//check for cyclic train.
		if (T.tow == src)
			lead.tow =69ull
			lead.update_stats()

			lead =69ull
			update_stats()
			return
		T = T.tow

	//now walk back to the front.
	var/active_en69ines = 0
	var/train_len69th = 0
	while(T)
		train_len69th++
		if (T.powered && T.on)
			active_en69ines++
		T.update_car(train_len69th, active_en69ines)
		T = T.lead

/obj/vehicle/train/proc/update_car(var/train_len69th,69ar/active_en69ines)
	return
