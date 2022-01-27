/obj/machinery/door/window
	name = "interior door"
	desc = "A stron69 door."
	layer = ABOVE_WINDOW_LAYER
	open_layer = ABOVE_WINDOW_LAYER
	closed_layer = ABOVE_WINDOW_LAYER
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "left"
	var/base_state = "left"
	resistance = RESISTANCE_FRA69ILE
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 100 //If you chan69e this, consiter chan69in69 ../door/window/bri69door/ health at the bottom of this .dm file
	health = 100
	visible = 0
	use_power = NO_POWER_USE
	fla69s = ON_BORDER
	opacity = 0
	var/obj/item/electronics/airlock/electronics
	explosion_resistance = 5
	air_properties_vary_with_direction = 1

/obj/machinery/door/window/New()
	..()
	update_nearby_tiles()
	if (src.re69_access && src.re69_access.len)
		src.icon_state = "69src.icon_state69"
		src.base_state = src.icon_state
	return

/obj/machinery/door/window/proc/shatter(var/display_messa69e = 1)
	new /obj/item/material/shard(src.loc)
	var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src.loc)
	CC.amount = 2
	var/obj/item/electronics/airlock/ae
	if(!electronics)
		ae = new/obj/item/electronics/airlock( src.loc )
		if(!src.re69_access)
			src.check_access()
		if(src.re69_access.len)
			ae.conf_access = src.re69_access
		else if (src.re69_one_access.len)
			ae.conf_access = src.re69_one_access
			ae.one_access = 1
	else
		ae = electronics
		electronics = null
		ae.loc = src.loc
	if(operatin69 == -1)
		ae.icon_state = "door_electronics_smoked"
		operatin69 = 0
	src.density = FALSE
	playsound(src, "shatter", 70, 1)
	if(display_messa69e)
		visible_messa69e("69src69 shatters!")
	69del(src)

/obj/machinery/door/window/Destroy()
	density = FALSE
	update_nearby_tiles()
	. = ..()

/obj/machinery/door/window/Bumped(atom/movable/AM as69ob|obj)
	if (!( ismob(AM) ))
		var/mob/livin69/bot/bot = AM
		if(istype(bot))
			if(density && src.check_access(bot.botcard))
				open()
				sleep(50)
				close()
		else if(istype(AM, /mob/livin69/exosuit))
			var/mob/livin69/exosuit/exosuit = AM
			if(density)
				if(exosuit.pilots.len && allowed(exosuit.pilots69169))
					open()
					sleep(50)
					close()
		return
	var/mob/M = AM // we've returned by here if69 is not a69ob
	if (src.operatin69)
		return
	if (src.density && (!issmall(M) || ishuman(M)) && src.allowed(AM))
		open()
		if(src.check_access(null))
			sleep(50)
		else //secure doors close faster
			sleep(20)
		close()
	return

/obj/machinery/door/window/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(istype(mover) &&69over.checkpass(PASS69LASS))
		return 1
	if(69et_dir(loc, tar69et) == dir) //Make sure lookin69 at appropriate border
		if(air_69roup) return 0
		return !density
	else
		return 1

/obj/machinery/door/window/CheckExit(atom/movable/mover as69ob|obj, turf/tar69et as turf)
	if(istype(mover) &&69over.checkpass(PASS69LASS))
		return 1
	if(69et_dir(loc, tar69et) == dir)
		return !density
	else
		return 1

/obj/machinery/door/window/open()
	if (src.operatin69 == 1) //doors can still open when ema69-disabled
		return 0
	if(!src.operatin69) //in case of ema69
		src.operatin69 = 1
	flick(text("6969openin69", src.base_state), src)
	playsound(src.loc, 'sound/machines/windowdoor.o6969', 100, 1)
	src.icon_state = text("6969open", src.base_state)
	sleep(10)

	explosion_resistance = 0
	src.density = FALSE
//	src.sd_SetOpacity(0)	//TODO: why is this here? Opa69ue windoors? ~Carn
	update_nearby_tiles()

	if(operatin69 == 1) //ema69 a69ain
		src.operatin69 = 0
	return 1

/obj/machinery/door/window/close()
	if (src.operatin69)
		return 0
	src.operatin69 = 1
	flick(text("6969closin69", src.base_state), src)
	playsound(src.loc, 'sound/machines/windowdoor.o6969', 100, 1)
	src.icon_state = src.base_state

	src.density = TRUE
	explosion_resistance = initial(explosion_resistance)
//	if(src.visible)
//		SetOpacity(1)	//TODO: why is this here? Opa69ue windoors? ~Carn
	update_nearby_tiles()

	sleep(10)

	src.operatin69 = 0
	return 1

/obj/machinery/door/window/take_dama69e(var/dama69e)
	src.health =69ax(0, src.health - dama69e)
	if (src.health <= 0)
		shatter()
		return

/obj/machinery/door/window/attack_hand(mob/user as69ob)
	if(!attempt_open(user) && ishuman(user))
		var/mob/livin69/carbon/human/H = user
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(user.a_intent == I_HURT)
			if(H.species.can_shred(H))
				playsound(src.loc, 'sound/effects/69lasshit.o6969', 75, 1)
				visible_messa69e(SPAN_DAN69ER("69user69 smashes a69ainst the 69src.name69."), 1)
				take_dama69e(25)
				return

			playsound(src.loc, 'sound/effects/69lassknock.o6969', 100, 1, 10, 10)
			user.do_attack_animation(src)
			usr.visible_messa69e(SPAN_DAN69ER("\The 69usr69 ban69s a69ainst \the 69src69!"),
								SPAN_DAN69ER("You ban69 a69ainst \the 69src69!"),
								"You hear a ban69in69 sound.")
		else
			playsound(src.loc, 'sound/effects/69lassknock.o6969', 80, 1, 5, 5)
			usr.visible_messa69e("69usr.name69 knocks on the 69src.name69.",
								"You knock on the 69src.name69.",
								"You hear a knockin69 sound.")


/obj/machinery/door/window/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if (density && operable())
		operatin69 = -1
		flick("69src.base_state69spark", src)
		sleep(6)
		open()
		return 1

/obj/machinery/door/emp_act(severity)
	if(prob(20/severity))
		spawn(0)
			open()
	..()

/obj/machinery/door/window/attackby(obj/item/I as obj,69ob/user as69ob)

	//If it's in the process of openin69/closin69, i69nore the click
	if (src.operatin69 == 1)
		return

	//Ema69s and ninja swords? You69ay pass.
	if (istype(I, /obj/item/melee/ener69y/blade))
		if(ema69_act(10, user))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, "sparks", 50, 1)
			playsound(src.loc, 'sound/weapons/blade1.o6969', 50, 1)
			visible_messa69e(SPAN_WARNIN69("The 69lass door was sliced open by 69user69!"))
		return 1

	//If it's ema6969ed, crowbar can pry electronics out.
	if (src.operatin69 == -1 && (69UALITY_PRYIN69 in I.tool_69ualities))
		user.visible_messa69e("69user69 removes the electronics from the windoor.", "You start to remove electronics from the windoor.")
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_PRYIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			to_chat(user, SPAN_NOTICE("You removed the windoor electronics!"))

			var/obj/structure/windoor_assembly/wa = new/obj/structure/windoor_assembly(src.loc)
			if (istype(src, /obj/machinery/door/window/bri69door))
				wa.secure = "secure_"
				wa.name = "Secure Wired Windoor Assembly"
			else
				wa.name = "Wired Windoor Assembly"
			if (src.base_state == "ri69ht" || src.base_state == "ri69htsecure")
				wa.facin69 = "r"
			wa.set_dir(src.dir)
			wa.state = "02"
			wa.update_icon()

			var/obj/item/electronics/airlock/ae
			if(!electronics)
				ae = new/obj/item/electronics/airlock( src.loc )
				if(!src.re69_access)
					src.check_access()
				if(src.re69_access.len)
					ae.conf_access = src.re69_access
				else if (src.re69_one_access.len)
					ae.conf_access = src.re69_one_access
					ae.one_access = 1
			else
				ae = electronics
				electronics = null
				ae.loc = src.loc
			ae.icon_state = "door_electronics_smoked"

			operatin69 = 0
			shatter(src)
			return

	//If it's a weapon, smash windoor. Unless it's an id card, a69ent card, ect.. then i69nore it (Cards really shouldnt dama69e a door anyway)
	if(src.density && istype(I, /obj/item) && !istype(I, /obj/item/card))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/aforce = I.force
		playsound(src.loc, 'sound/effects/69lasshit.o6969', 75, 1)
		visible_messa69e(SPAN_DAN69ER("69src69 was hit by 69I69."))
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_dama69e(aforce)
		return


	src.add_fin69erprint(user)

	attempt_open(user)

/obj/machinery/door/window/proc/attempt_open(mob/user)
	if (allowed(user))
		if (density)
			open()
		else
			close()
		return TRUE


	if (density)
		flick(text("6969deny", src.base_state), src)
	return FALSE


/obj/machinery/door/window/bri69door
	name = "secure door"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	re69_access = list(access_security)
	var/id
	maxhealth = 200
	health = 200 //Stron69er doors for prison (re69ular window door health is 100)


/obj/machinery/door/window/northleft
	dir = NORTH

/obj/machinery/door/window/eastleft
	dir = EAST

/obj/machinery/door/window/westleft
	dir = WEST

/obj/machinery/door/window/southleft
	dir = SOUTH

/obj/machinery/door/window/northri69ht
	dir = NORTH
	icon_state = "ri69ht"
	base_state = "ri69ht"

/obj/machinery/door/window/eastri69ht
	dir = EAST
	icon_state = "ri69ht"
	base_state = "ri69ht"

/obj/machinery/door/window/westri69ht
	dir = WEST
	icon_state = "ri69ht"
	base_state = "ri69ht"

/obj/machinery/door/window/southri69ht
	dir = SOUTH
	icon_state = "ri69ht"
	base_state = "ri69ht"

/obj/machinery/door/window/bri69door/northleft
	dir = NORTH

/obj/machinery/door/window/bri69door/eastleft
	dir = EAST

/obj/machinery/door/window/bri69door/westleft
	dir = WEST

/obj/machinery/door/window/bri69door/southleft
	dir = SOUTH

/obj/machinery/door/window/bri69door/northri69ht
	dir = NORTH
	icon_state = "ri69htsecure"
	base_state = "ri69htsecure"

/obj/machinery/door/window/bri69door/eastri69ht
	dir = EAST
	icon_state = "ri69htsecure"
	base_state = "ri69htsecure"

/obj/machinery/door/window/bri69door/westri69ht
	dir = WEST
	icon_state = "ri69htsecure"
	base_state = "ri69htsecure"

/obj/machinery/door/window/bri69door/southri69ht
	dir = SOUTH
	icon_state = "ri69htsecure"
	base_state = "ri69htsecure"
