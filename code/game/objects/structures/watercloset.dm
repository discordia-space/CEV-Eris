//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a tor69ue rotation-based, waste disposal unit for small69atter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	layer = SIGN_LAYER
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the69ob being given a swirlie

/obj/structure/toilet/New()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/toilet/attack_hand(mob/living/user as69ob)
	if(swirlie)
		usr.visible_message(
			SPAN_DANGER("69user69 slams the toilet seat onto 69swirlie.name69's head!"),
			SPAN_NOTICE("You slam the toilet seat onto 69swirlie.name69's head!"),
			"You hear reverberating porcelain."
		)
		swirlie.adjustBruteLoss(8)
		return

	if(cistern && !open)
		if(!contents.len)
			to_chat(user, SPAN_NOTICE("The cistern is empty."))
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.loc = get_turf(src)
			to_chat(user, SPAN_NOTICE("You find \an 69I69 in the cistern."))
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/toilet/update_icon()
	icon_state = "toilet69open6969cistern69"

/obj/structure/toilet/attackby(obj/item/I as obj,69ob/living/user as69ob)
	if(69UALITY_PRYING in I.tool_69ualities)
		to_chat(user, "<span class='notice'>You start to 69cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"69.</span>")
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_PRYING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			user.visible_message("<span class='notice'>69user69 69cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"69!</span>", "<span class='notice'>You 69cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"69!</span>", "You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
			return

	if(cistern && !isrobot(user)) //STOP PUTTING YOUR69ODULES IN THE TOILET.
		if(I.w_class >= ITEM_SIZE_BULKY)
			to_chat(user, SPAN_NOTICE("\The 69I69 does not fit."))
			return
		if(w_items + I.w_class > ITEM_SIZE_HUGE)
			to_chat(user, SPAN_NOTICE("The cistern is full."))
			return
		user.drop_item()
		I.loc = src
		w_items += I.w_class
		to_chat(user, "You carefully place \the 69I69 into the cistern.")
		return

/obj/structure/toilet/AltClick(var/mob/living/user)
	if(!open)
		return
	var/H = user.get_active_hand()
	if(istype(H,/obj/item/reagent_containers/glass) || istype(H,/obj/item/reagent_containers/food/drinks))
		var/obj/item/reagent_containers/O = user.get_active_hand()
		if(O.reagents && O.reagents.total_volume)
			O.reagents.clear_reagents()
			to_chat(user, SPAN_NOTICE("You empty the 69O69 into the 69src69."))


/obj/structure/toilet/affect_grab(var/mob/user,69ar/mob/living/target,69ar/state)
	if(state == GRAB_PASSIVE)
		to_chat(user, SPAN_NOTICE("You need a tighter grip."))
		return FALSE
	if(!target.loc == loc)
		to_chat(user, SPAN_NOTICE("69target69 needs to be on the toilet."))
		return FALSE
	if(open && !swirlie)
		user.visible_message(
			SPAN_DANGER("69user69 starts to give 69target69 a swirlie!"),
			SPAN_NOTICE("You start to give 69target69 a swirlie!")
		)
		swirlie = target
		if (do_after(user, 30, src) || !Adjacent(target))
			user.visible_message(
				SPAN_DANGER("69user69 gives 69target69 a swirlie!"),
				SPAN_NOTICE("You give 69target69 a swirlie!"),
				"You hear a toilet flushing."
			)
			var/mob/living/carbon/C = target
			if(!istype(C) || !C.internal)
				target.adjustOxyLoss(5)
		swirlie = null
	else
		user.visible_message(
			SPAN_DANGER("69user69 slams 69target69 into the 69src69!"),
			SPAN_NOTICE("You slam 69target69 into the 69src69!")
		)
		admin_attack_log(user, target,
			"slams <b>69key_name(target)69</b> into the 69src69",
			"Was slamed by <b>69key_name(user)69 into the 69src69</b>",
			"slamed into the 69src69"
		)
		target.adjustBruteLoss(8)
	return TRUE


/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/urinal/affect_grab(var/mob/living/user,69ar/mob/living/target,69ar/state)
	if(state == GRAB_PASSIVE)
		to_chat(user, SPAN_NOTICE("You need a tighter grip."))
		return FALSE
	if(!target.loc == loc)
		to_chat(user, SPAN_NOTICE("69target69 needs to be on the urinal."))
		return
	user.visible_message(
		SPAN_DANGER("69user69 slams 69target69 into the 69src69!"),
		SPAN_NOTICE("You slam 69target69 into the 69src69!")
	)
	admin_attack_log(user, target,
		"slams <b>69key_name(target)69</b> into the 69src69",
		"Was slamed by <b>69key_name(user)69 into the 69src69</b>",
		"slamed into the 69src69"
	)
	target.adjustBruteLoss(8)
	return TRUE


/obj/machinery/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2550s by the Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE
	use_power = NO_POWER_USE
	var/on = FALSE
	var/obj/effect/mist/mymist = null
	var/ismist = 0				//needs a69ar so we can69ake it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/is_washing = 0
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)

/obj/machinery/shower/New()
	..()
	create_reagents(50)

//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = FLY_LAYER
	anchored = TRUE
	mouse_opacity = 0

/obj/machinery/shower/attack_hand(mob/M as69ob)
	on = !on
	update_icon()
	if(on)
		if (M.loc == loc)
			wash(M)
			process_heat(M)
		for (var/atom/movable/G in loc)
			G.clean_blood()

/obj/machinery/shower/attackby(obj/item/I,69ob/user)
	if(69UALITY_PULSING in I.tool_69ualities)
		to_chat(user, SPAN_NOTICE("The water temperature seems to be 69watertemp69."))
	if(69UALITY_BOLT_TURNING in I.tool_69ualities)
		var/newtemp = input(user, "What setting would you like to set the temperature69alve to?", "Water Temperature69alve") in temperature_settings
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY,  re69uired_stat = STAT_MEC))
			watertemp = newtemp
			user.visible_message(SPAN_NOTICE("\The 69user69 adjusts \the 69src69 with \the 69I69."), SPAN_NOTICE("You adjust the shower with \the 69I69."))
			add_fingerprint(user)

/obj/machinery/shower/update_icon()	//this is terribly unreadable, but basically it69akes the shower69ist up
	overlays.Cut()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		69del(mymist)
		mymist = null

	if(on)
		overlays += image('icons/obj/watercloset.dmi', src, "water", ABOVE_MOB_LAYER, dir)
		if(temperature_settings69watertemp69 < T20C)
			return //no69ist for cold water
		if(!ismist)
			spawn(50)
				if(src && on)
					ismist = 1
					mymist = new(loc)
		else
			mymist = new(loc)
	else if(ismist)
		mymist = new(loc)
		spawn(250)
			if(src && !on)
				69del(mymist)
				mymist = null
				ismist = 0

//Yes, showers are super powerful as far as washing goes.
/obj/machinery/shower/proc/wash(atom/movable/O as obj|mob)
	if(!on) return

	if(isliving(O))
		var/mob/living/L = O
		L.ExtinguishMob()
		L.fire_stacks = -20 //Douse ourselves with water to avoid fire69ore easily

	if(iscarbon(O))
		var/mob/living/carbon/M = O
		if(M.r_hand)
			M.r_hand.clean_blood()
		if(M.l_hand)
			M.l_hand.clean_blood()
		if(M.back)
			if(M.back.clean_blood())
				M.update_inv_back(0)

		//flush away reagents on the skin
		if(M.touching)
			var/remove_amount =69.touching.maximum_volume *69.reagent_permeability() //take off your suit first
			M.touching.remove_any(remove_amount)

		if(ishuman(M))
			var/mob/living/carbon/human/H =69
			var/washgloves = 1
			var/washshoes = 1
			var/washmask = 1
			var/washears = 1
			var/washglasses = 1

			if(H.wear_suit)
				washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
				washshoes = !(H.wear_suit.flags_inv & HIDESHOES)

			if(H.head)
				washmask = !(H.head.flags_inv & HIDEMASK)
				washglasses = !(H.head.flags_inv & HIDEEYES)
				washears = !(H.head.flags_inv & HIDEEARS)

			if(H.wear_mask)
				if (washears)
					washears = !(H.wear_mask.flags_inv & HIDEEARS)
				if (washglasses)
					washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

			if(H.head)
				if(H.head.clean_blood())
					H.update_inv_head(0)
			if(H.wear_suit)
				if(H.wear_suit.clean_blood())
					H.update_inv_wear_suit(0)
			else if(H.w_uniform)
				if(H.w_uniform.clean_blood())
					H.update_inv_w_uniform(0)
			if(H.gloves && washgloves)
				if(H.gloves.clean_blood())
					H.update_inv_gloves(0)
			if(H.shoes && washshoes)
				if(H.shoes.clean_blood())
					H.update_inv_shoes(0)
			if(H.wear_mask && washmask)
				if(H.wear_mask.clean_blood())
					H.update_inv_wear_mask(0)
			if(H.glasses && washglasses)
				if(H.glasses.clean_blood())
					H.update_inv_glasses(0)
			if(H.l_ear && washears)
				if(H.l_ear.clean_blood())
					H.update_inv_ears(0)
			if(H.r_ear && washears)
				if(H.r_ear.clean_blood())
					H.update_inv_ears(0)
			if(H.belt)
				if(H.belt.clean_blood())
					H.update_inv_belt(0)
			H.clean_blood(washshoes)
			H.update_icons()
		else
			if(M.wear_mask)						//if the69ob is not human, it cleans the69ask without asking for bitflags
				if(M.wear_mask.clean_blood())
					M.update_inv_wear_mask(0)
			M.clean_blood()
	else
		O.clean_blood()

	if(isturf(loc))
		var/turf/tile = loc
		for(var/obj/effect/E in tile)
			if(istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
				69del(E)

	reagents.splash(O, 10)

/obj/machinery/shower/Process()
	if(!on) return

	for(var/thing in loc)
		var/atom/movable/AM = thing
		var/mob/living/L = thing
		if(istype(AM) && AM.simulated)
			wash(AM)
			if(istype(L))
				process_heat(L)
	wash_floor()
	reagents.add_reagent("water", reagents.get_free_space())

/obj/machinery/shower/proc/wash_floor()
	if(!ismist && is_washing)
		return
	is_washing = 1
	var/turf/T = get_turf(src)
	reagents.splash(T, reagents.total_volume)
	T.clean(src)
	spawn(100)
		is_washing = 0

/obj/machinery/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M)) return

	var/temperature = temperature_settings69watertemp69
	var/temp_adj = between(BODYTEMP_COOLING_MAX, temperature -69.bodytemperature, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj

	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		if(temperature >= H.species.heat_level_1)
			to_chat(H, SPAN_DANGER("The water is searing hot!"))
		else if(temperature <= H.species.cold_level_1)
			to_chat(H, SPAN_WARNING("The water is freezing cold!"))

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you69ake bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"



/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	reagent_flags = OPENCONTAINER
	var/busy = 0 	//Something's being washed at the69oment

/obj/structure/sink/MouseDrop_T(var/obj/item/thing,69ar/mob/user)
	. = ..()
	if(!istype(thing) || !thing.is_drainable())
		return
	if(!usr.Adjacent(src))
		return
	if(!thing.reagents || thing.reagents.total_volume == 0)
		to_chat(usr, SPAN_WARNING("\The 69thing69 is empty."))
		return FALSE
	// Clear the69essel.
	visible_message(SPAN_NOTICE("\The 69usr69 tips the contents of \the 69thing69 into \the 69src69."))
	thing.reagents.clear_reagents()

/obj/structure/sink/attack_hand(mob/user as69ob)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name69BP_R_ARM69
		if (user.hand)
			temp = H.organs_by_name69BP_L_ARM69
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to69ove your 69temp.name69, but cannot!"))
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	to_chat(usr, SPAN_NOTICE("You start washing your hands."))

	playsound(loc, 'sound/effects/watersplash.ogg', 100, 1)

	busy = 1
	sleep(40)
	busy = 0

	if(!Adjacent(user)) return		//Person has69oved away from the sink

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in69iewers(src, null))
		V.show_message(SPAN_NOTICE("69user69 washes their hands using \the 69src69."))


/obj/structure/sink/attackby(obj/item/O as obj,69ob/living/user as69ob)
	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	var/obj/item/reagent_containers/RG = O
	if (istype(RG) && RG.is_refillable())
		RG.reagents.add_reagent("water",69in(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message(SPAN_NOTICE("69user69 fills \the 69RG69 using \the 69src69."),SPAN_NOTICE("You fill \the 69RG69 using \the 69src69."))
		playsound(loc, 'sound/effects/watersplash.ogg', 100, 1)
		return 1

	else if (istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		if(B.cell)
			if(B.cell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.Stun(10)
				user.stuttering = 10
				user.Weaken(10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				user.visible_message(
					SPAN_DANGER("69user69 was stunned by \his wet 69O69!"),
					"<span class='userdanger'>69user69 was stunned by \his wet 69O69!</span>"
				)
				return 1
	else if(istype(O, /obj/item/mop))
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, SPAN_NOTICE("You start washing \the 69I69."))

	busy = 1
	sleep(40)
	busy = 0

	if(user.loc != location) return				//User has69oved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		SPAN_NOTICE("69user69 washes \a 69I69 using \the 69src69."), \
		SPAN_NOTICE("You wash \a 69I69 using \the 69src69."))

/obj/structure/sink/AltClick(var/mob/living/user)
	var/H = user.get_active_hand()
	if(istype(H,/obj/item/reagent_containers/glass) || istype(H,/obj/item/reagent_containers/food/drinks))
		var/obj/item/reagent_containers/O = user.get_active_hand()
		if(O.reagents && O.reagents.total_volume)
			O.reagents.clear_reagents()
			to_chat(user, SPAN_NOTICE("You empty the 69O69 into the 69src69."))


/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"

/obj/structure/sink/puddle/attack_hand(mob/M as69ob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/sink/puddle/attackby(obj/item/O as obj,69ob/user as69ob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"
