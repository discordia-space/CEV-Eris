// Foam
// Similar to smoke, but spreads out69ore
//69etal foams leave behind a foamed69etal wall

/obj/effect/effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = 0
	anchored = TRUE
	density = FALSE
	layer = EDGED_TURF_LAYER
	mouse_opacity = 0
	animate_movement = 0
	var/amount = 3
	var/expand = 1
	var/metal = 0

/obj/effect/effect/foam/New(var/loc,69ar/ismetal = 0)
	..(loc)
	icon_state = "69ismetal? "m" : ""69foam"
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, 1, -3)
	spawn(3 +69etal * 3)
		Process()
		checkReagents()
	spawn(120)
		STOP_PROCESSING(SSobj, src)
		sleep(30)
		if(metal)
			var/obj/structure/foamedmetal/M = new(src.loc)
			M.metal =69etal
			M.updateicon()
		flick("69icon_state69-disolve", src)
		sleep(5)
		69del(src)
	return

/obj/effect/effect/foam/proc/checkReagents() // transfer any reagents to the floor
	if(!metal && reagents)
		var/turf/T = get_turf(src)
		reagents.touch_turf(T)
		for(var/obj/O in T)
			reagents.touch_obj(O)

/obj/effect/effect/foam/Process()
	if(--amount < 0)
		return

	for(var/direction in cardinal)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T,69etal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if(reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					//added safety check since reagents in the foam have already had a chance to react
					F.reagents.add_reagent(R.id, 1, safety = 1)

// foam disolves when heated, except69etal foams
/obj/effect/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("69icon_state69-disolve", src)

		spawn(5)
			69del(src)

/obj/effect/effect/foam/Crossed(var/atom/movable/AM)
	if(metal)
		return
	if(isliving(AM))
		var/mob/living/M = AM
		M.slip("the foam", 3)

/datum/effect/effect/system/foam_spread
	var/amount = 5				// the size of the foam spread.
	var/list/carried_reagents	// the IDs of reagents present when the foam was69ixed
	var/metal = 0				// 0 = foam, 1 =69etalfoam, 2 = ironfoam

/datum/effect/effect/system/foam_spread/set_up(amt=5, loca,69ar/datum/reagents/carry = null,69ar/metalfoam = 0)
	amount = round(s69rt(amt / 3), 1)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal =69etalfoam

	// bit of a hack here.
	// Foam carries along any reagent also present in the glass it is69ixed with
	// (defaults to water if none is present).
	// Rather than actually transfer the reagents, this69akes a list of the reagent ids
	// and spawns 1 unit of that reagent when the foam disolves.

	if(carry && !metal)
		for(var/datum/reagent/R in carry.reagent_list)
			carried_reagents += R.id

/datum/effect/effect/system/foam_spread/start()
	spawn(0)
		var/obj/effect/effect/foam/F = locate() in location
		if(F)
			F.amount += amount
			return

		F = new(location,69etal)
		F.amount = amount

		if(!metal) // don't carry other chemicals if a69etal foam
			F.create_reagents(10)

			if(carried_reagents)
				for(var/id in carried_reagents)
					//makes a safety call because all reagents should have already reacted anyway
					F.reagents.add_reagent(id, 1, safety = 1)
			else
				F.reagents.add_reagent("water", 1, safety = 1)

// wall formed by69etal foams, dense and opa69ue, but easy to break

/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = TRUE
	opacity = 1 // changed in New()
	anchored = TRUE
	layer = EDGED_TURF_LAYER
	name = "foamed69etal"
	desc = "A lightweight foamed69etal wall."
	var/metal = 1 // 1 = aluminum, 2 = iron

/obj/structure/foamedmetal/New()
	..()
	update_nearby_tiles(1)

/obj/structure/foamedmetal/Destroy()
	density = FALSE
	update_nearby_tiles(1)
	. = ..()

/obj/structure/foamedmetal/proc/updateicon()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"

/obj/structure/foamedmetal/ex_act(severity)
	69del(src)

/obj/structure/foamedmetal/bullet_act()
	if(metal == 1 || prob(50))
		69del(src)

/obj/structure/foamedmetal/attack_hand(var/mob/user)
	if ((HULK in user.mutations) || (prob(75 -69etal * 25)))
		user.visible_message(
			SPAN_WARNING("69user69 smashes through the foamed69etal."),
			SPAN_NOTICE("You smash through the69etal foam wall.")
		)
		69del(src)
	else
		to_chat(user, SPAN_NOTICE("You hit the69etal foam but bounce off it."))
	return

/obj/structure/foamedmetal/affect_grab(var/mob/living/user,69ar/mob/living/target)
	target.forceMove(src.loc)
	visible_message(SPAN_WARNING("69user69 smashes 69target69 through the foamed69etal wall."))
	target.Weaken(5)
	69del(src)
	return TRUE

/obj/structure/foamedmetal/attackby(var/obj/item/I,69ar/mob/user)
	if(!istype(I))
		return
	if(prob(I.force * 20 -69etal * 25))
		user.visible_message(
			SPAN_WARNING("69user69 smashes through the foamed69etal."),
			SPAN_NOTICE("You smash through the foamed69etal with \the 69I69.")
		)
		69del(src)
	else
		to_chat(user, SPAN_NOTICE("You hit the69etal foam to no effect."))

/obj/structure/foamedmetal/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	if(air_group)
		return 0
	return !density
