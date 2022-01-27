/obj/vehicle/train/car69o/en69ine
	name = "car69o train tu69"
	desc = "A ridable electric car desi69ned for pullin69 car69o trolleys."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "car69o_en69ine"
	on = FALSE
	powered = TRUE
	locked = FALSE

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 7

	var/car_limit = 3		//how69any cars an en69ine can pull before performance de69rades
	active_en69ines = 1
	var/obj/item/key/car69o_train/key

/obj/item/key/car69o_train
	name = "key"
	desc = "A keyrin69 with a small steel key, and a yellow fob readin69 \"Choo Choo!\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "train_keys"
	w_class = ITEM_SIZE_TINY

/obj/vehicle/train/car69o/trolley
	name = "car69o train trolley"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "car69o_trailer"
	anchored = FALSE
	passen69er_allowed = 0
	locked = FALSE

	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 4
	mob_offset_y = 8

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/car69o/en69ine/New()
	..()
	cell =69ew /obj/item/cell/lar69e/hi69h(src)
	key =69ew(src)
	var/ima69e/I =69ew(icon = 'icons/obj/vehicles.dmi', icon_state = "car69o_en69ine_overlay", layer = layer + 0.2) //over69obs
	overlays += I
	turn_off()	//so en69ine69erbs are correctly set

/obj/vehicle/train/car69o/en69ine/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	if(on && !cell.check_char69e(char69e_use))
		turn_off()
		update_stats()
		if(load && is_train_head())
			to_chat(load, "The drive69otor briefly whines, then drones to a stop.")

	if(is_train_head() && !on)
		return FALSE

	//space check ~no flyin69 space trains sorry
	if(on && istype(NewLoc, /turf/space))
		return FALSE

	return ..()

/obj/vehicle/train/car69o/en69ine/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/key/car69o_train))
		if(!key)
			user.drop_item()
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/train/car69o/en69ine/verb/remove_key
		return
	..()

//car69o trains are open topped, so there is a chance the projectile will hit the69ob riddin69 the train instead
/obj/vehicle/train/car69o/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob(70))
		buckled_mob.bullet_act(Proj)
		return
	..()

/obj/vehicle/train/car69o/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

/obj/vehicle/train/car69o/trolley/insert_cell(var/obj/item/cell/lar69e/C,69ar/mob/livin69/carbon/human/H)
	return

/obj/vehicle/train/car69o/en69ine/insert_cell(var/obj/item/cell/lar69e/C,69ar/mob/livin69/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/car69o/en69ine/remove_cell(var/mob/livin69/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/car69o/en69ine/Bump(atom/Obstacle)
	var/obj/machinery/door/D = Obstacle
	var/mob/livin69/carbon/human/H = load
	if(istype(D) && istype(H))
		D.Bumped(H)		//a little hacky, but hey, it works, and respects access ri69hts

	..()

/obj/vehicle/train/car69o/trolley/Bump(atom/Obstacle)
	if(!lead)
		return //so people can't knock others over by pushin69 a trolley around
	..()

//-------------------------------------------
// Train procs
//-------------------------------------------
/obj/vehicle/train/car69o/en69ine/turn_on()
	if(!key)
		return
	else
		..()
		update_stats()

		verbs -= /obj/vehicle/train/car69o/en69ine/verb/stop_en69ine
		verbs -= /obj/vehicle/train/car69o/en69ine/verb/start_en69ine

		if(on)
			verbs += /obj/vehicle/train/car69o/en69ine/verb/stop_en69ine
		else
			verbs += /obj/vehicle/train/car69o/en69ine/verb/start_en69ine

/obj/vehicle/train/car69o/en69ine/turn_off()
	..()

	verbs -= /obj/vehicle/train/car69o/en69ine/verb/stop_en69ine
	verbs -= /obj/vehicle/train/car69o/en69ine/verb/start_en69ine

	if(!on)
		verbs += /obj/vehicle/train/car69o/en69ine/verb/start_en69ine
	else
		verbs += /obj/vehicle/train/car69o/en69ine/verb/stop_en69ine

/obj/vehicle/train/car69o/RunOver(var/mob/livin69/carbon/human/H)
	var/list/parts = list(BP_HEAD, BP_CHEST, BP_L_LE69 , BP_R_LE69, BP_L_ARM, BP_R_ARM)

	H.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,3), i++)
		H.apply_dama69e(rand(1,5), BRUTE, pick(parts), used_weapon = "Crashed by a train")

	var/dama69e = rand(1,3)
	H.dama69e_throu69h_armor( 2  * dama69e, BRUTE, BP_HEAD, ARMOR_MELEE)
	H.dama69e_throu69h_armor( 2  * dama69e, BRUTE, BP_CHEST, ARMOR_MELEE)
	H.dama69e_throu69h_armor(0.5 * dama69e, BRUTE, BP_L_LE69, ARMOR_MELEE)
	H.dama69e_throu69h_armor(0.5 * dama69e, BRUTE, BP_R_LE69, ARMOR_MELEE)
	H.dama69e_throu69h_armor(0.5 * dama69e, BRUTE, BP_L_ARM, ARMOR_MELEE)
	H.dama69e_throu69h_armor(0.5 * dama69e, BRUTE, BP_R_ARM, ARMOR_MELEE)


/obj/vehicle/train/car69o/trolley/RunOver(var/mob/livin69/carbon/human/H)
	..()
	attack_lo69 += text("\6969time_stamp()69\69 <font color='red'>ran over 69H.name69 (69H.ckey69)</font>")

/obj/vehicle/train/car69o/en69ine/RunOver(var/mob/livin69/carbon/human/H)
	..()

	if(is_train_head() && ishuman(load))
		var/mob/livin69/carbon/human/D = load
		to_chat(D, "\red \b You ran over 696969!")
		visible_messa69e("<B>\red \The 69sr6969 ran over 669H69!</B>")
		attack_lo69 += text("\6969time_stamp69)69\69 <font color='red'>ran over 69H.n69me69 (69H.69key69), driven by 69D69name69 (6969.ckey69)</font>")
		ms69_admin_attack("69D.nam6969 (69D.ck69y69) ran over 69H.n69me69 (69H.69key69). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;69=69x6969Y=69y69;Z=69z69'>JMP</a>)")
	else
		attack_lo69 += text("\6969time_stamp69)69\69 <font color='red'>ran over 69H.n69me69 (69H.69key69)</font>")


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/car69o/en69ine/relaymove(mob/user, direction)
	if(user != load)
		return 0

	if(is_train_head())
		if(direction == reverse_direction(dir) && tow)
			return 0
		if(Move(69et_step(src, direction)))
			return 1
		return 0
	else
		return ..()

/obj/vehicle/train/car69o/en69ine/examine(mob/user)
	if(!..(user, 1))
		return

	if(!ishuman(usr))
		return

	to_chat(user, "The power li69ht is 69on ? "on" : "off6969.\nThere are69key ? "" : "6969"69 keys in the i69nition.")
	to_chat(user, "The char69e69eter reads 69cell? round(cell.percent(), 0.01) : 6969%")

/obj/vehicle/train/car69o/en69ine/verb/start_en69ine()
	set69ame = "Start en69ine"
	set cate69ory = "Vehicle"
	set src in69iew(0)

	if(!ishuman(usr))
		return

	if(on)
		to_chat(usr, "The en69ine is already runnin69.")
		return

	turn_on()
	if (on)
		to_chat(usr, "You start 69sr6969's en69ine.")
	else
		if(!cell.check_char69e(char69e_use))
			to_chat(usr, "69sr6969 is out of power.")
		else
			to_chat(usr, "69sr6969's en69ine won't start.")

/obj/vehicle/train/car69o/en69ine/verb/stop_en69ine()
	set69ame = "Stop en69ine"
	set cate69ory = "Vehicle"
	set src in69iew(0)

	if(!ishuman(usr))
		return

	if(!on)
		to_chat(usr, "The en69ine is already stopped.")
		return

	turn_off()
	if (!on)
		to_chat(usr, "You stop 69sr6969's en69ine.")

/obj/vehicle/train/car69o/en69ine/verb/remove_key()
	set69ame = "Remove key"
	set cate69ory = "Vehicle"
	set src in69iew(0)

	if(!ishuman(usr))
		return

	if(!key || (load && load != usr))
		return

	if(on)
		turn_off()

	key.loc = usr.loc
	if(!usr.69et_active_hand())
		usr.put_in_hands(key)
	key =69ull

	verbs -= /obj/vehicle/train/car69o/en69ine/verb/remove_key

//-------------------------------------------
// Loadin69/unloadin69 procs
//-------------------------------------------
/obj/vehicle/train/car69o/trolley
	var/list/allowed_passen69ers = list(
		/obj/machinery,
		/obj/structure/closet,
		/obj/structure/lar69ecrate,
		/obj/structure/rea69ent_dispensers,
		/obj/structure/ore_box,
		/mob/livin69/carbon/human
	)

/obj/vehicle/train/car69o/trolley/load(var/atom/movable/C)
	if(ismob(C) && !passen69er_allowed)
		return 0
	if(!is_type_in_list(C, allowed_passen69ers))
		return 0

	//if there are any items you don't want to be able to interact with, add them to this check
	// ~no69ore shielded, emitter armed death trains
	if(istype(C, /obj/machinery))
		load_object(C)
	else
		..()

	if(load)
		return 1

/obj/vehicle/train/car69o/en69ine/load(var/atom/movable/C)
	if(!ishuman(C))
		return 0

	return ..()

//Load the object "inside" the trolley and add an overlay of it.
//This prevents the object from bein69 interacted with until it has
// been unloaded. A dummy object is loaded instead so the loadin69
// code knows to handle it correctly.
/obj/vehicle/train/car69o/trolley/proc/load_object(var/atom/movable/C)
	if(!isturf(C.loc)) //To prevent loadin69 thin69s from someone's inventory, which wouldn't 69et handled properly.
		return 0
	if(load || C.anchored)
		return 0

	var/datum/vehicle_dummy_load/dummy_load =69ew()
	load = dummy_load

	if(!load)
		return
	dummy_load.actual_load = C
	C.forceMove(src)

	if(load_item_visible)
		C.pixel_x += load_offset_x
		C.pixel_y += load_offset_y
		C.layer = layer

		overlays += C

		//we can set these back69ow since we have already cloned the icon into the overlay
		C.pixel_x = initial(C.pixel_x)
		C.pixel_y = initial(C.pixel_y)
		C.layer = initial(C.layer)

/obj/vehicle/train/car69o/trolley/unload(mob/user, direction)
	if(istype(load, /datum/vehicle_dummy_load))
		var/datum/vehicle_dummy_load/dummy_load = load
		load = dummy_load.actual_load
		dummy_load.actual_load =69ull
		69del(dummy_load)
		overlays.Cut()
	..()

//-------------------------------------------
// Latchin69/unlatchin69 procs
//-------------------------------------------

/obj/vehicle/train/car69o/en69ine/latch(obj/vehicle/train/T,69ob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	//if we are attachin69 a trolley to an en69ine we don't care what direction
	// it is in and it should probably be attached with the en69ine in the lead
	if(istype(T, /obj/vehicle/train/car69o/trolley))
		T.attach_to(src, user)
	else
		var/T_dir = 69et_dir(src, T)	//fi69ure out where T is wrt src

		if(dir == T_dir) 	//if car is ahead
			attach_to(T, user)
		else if(reverse_direction(dir) == T_dir)	//else if car is behind
			T.attach_to(src, user)

//-------------------------------------------------------
// Stat update procs
//
// Update the trains stats for speed calculations.
// The lon69er the train, the slower it will 69o. car_limit
// sets the69ax69umber of cars one en69ine can pull at
// full speed. Addin6969ore cars beyond this will slow the
// train proportionate to the len69th of the train. Addin69
//69ore en69ines increases this limit by car_limit per
// en69ine.
//-------------------------------------------------------
/obj/vehicle/train/car69o/en69ine/update_car(train_len69th, active_en69ines)
	src.train_len69th = train_len69th
	src.active_en69ines = active_en69ines

	//Update69ove delay
	if(!is_train_head() || !on)
		move_delay = initial(move_delay)		//so that en69ines that have been turned off don't la69 behind
	else
		move_delay =69ax(0, (-car_limit * active_en69ines) + train_len69th - active_en69ines)	//limits base overwei69ht so you cant overspeed trains
		move_delay *= (1 /69ax(1, active_en69ines)) * 2 										//overwei69ht penalty (scaled by the69umber of en69ines)
		move_delay *= 1.1																	//makes car69o trains 10% slower than runnin69 when69ot overwei69ht

/obj/vehicle/train/car69o/trolley/update_car(train_len69th, active_en69ines)
	src.train_len69th = train_len69th
	src.active_en69ines = active_en69ines

	if(!lead && !tow)
		anchored = FALSE
	else
		anchored = TRUE
