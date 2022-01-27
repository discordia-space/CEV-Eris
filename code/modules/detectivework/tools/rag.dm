/mob
	var/bloody_hands = 0
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0
	var/list/feet_blood_DNA
	var/track_blood_type
	var/feet_blood_color

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes
	var/track_blood = 0

/obj/item/reagent_containers/glass/rag
	name = "rag"
	desc = "For cleaning up69esses, you suppose."
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 10
	can_be_placed_into = null
	flags = NOBLUDGEON
	reagent_flags = REFILLABLE | DRAINABLE | AMOUNT_VISIBLE
	unacidable = 0
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 20
	var/on_fire = 0
	var/burn_time = 20 //if the rag burns for too long it turns to ashes

/obj/item/reagent_containers/glass/rag/New()
	..()
	update_name()

/obj/item/reagent_containers/glass/rag/Destroy()
	STOP_PROCESSING(SSobj, src) //so we don't continue turning to ash while gc'd
	. = ..()

/obj/item/reagent_containers/glass/rag/attack_self(mob/user)
	if(on_fire)
		user.visible_message(SPAN_WARNING("\The 69user69 stamps out 69src69."), SPAN_WARNING("You stamp out 69src69."))
		user.unEquip(src)
		extinguish()
	else
		remove_contents(user)

/obj/item/reagent_containers/glass/rag/attackby(obj/item/W,69ob/user)
	if(!on_fire && istype(W, /obj/item/flame))
		var/obj/item/flame/F = W
		if(F.lit)
			ignite()
			if(on_fire)
				visible_message(SPAN_WARNING("\The 69user69 lights 69src69 with 69W69."))
			else
				to_chat(user, SPAN_WARNING("You69anage to singe 69src69, but fail to light it."))

	. = ..()
	update_name()

/obj/item/reagent_containers/glass/rag/proc/update_name()
	if(on_fire)
		name = "burning 69initial(name)69"
	else if(reagents.total_volume)
		name = "damp 69initial(name)69"
	else
		name = "dry 69initial(name)69"

/obj/item/reagent_containers/glass/rag/update_icon()
	if(on_fire)
		icon_state = "raglit"
	else
		icon_state = "rag"

	var/obj/item/reagent_containers/food/drinks/bottle/B = loc
	if(istype(B))
		B.update_icon()

/obj/item/reagent_containers/glass/rag/proc/remove_contents(mob/user, atom/trans_dest = null)
	if(!trans_dest && !user.loc)
		return

	if(reagents.total_volume)
		var/target_text = trans_dest? "\the 69trans_dest69" : "\the 69user.loc69"
		user.visible_message(SPAN_DANGER("\The 69user69 begins to wring out 69src69 over 69target_text69."), SPAN_NOTICE("You begin to wring out 69src69 over 69target_text69."))

		if(do_after(user, reagents.total_volume*5, progress = 0)) //50 for a fully soaked rag
			if(trans_dest)
				reagents.trans_to(trans_dest, reagents.total_volume)
			else
				reagents.splash(user.loc, reagents.total_volume)
			user.visible_message(SPAN_DANGER("\The 69user69 wrings out 69src69 over 69target_text69."), SPAN_NOTICE("You finish to wringing out 69src69."))
			update_name()

/obj/item/reagent_containers/glass/rag/proc/wipe_down(atom/A,69ob/user)
	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("The 69initial(name)69 is dry!"))
	else
		user.visible_message("\The 69user69 starts to wipe down 69A69 with 69src69!")
		reagents.splash(A, 1) //get a small amount of liquid on the thing we're wiping.
		update_name()
		if(do_after(user,30, progress = 0))
			user.visible_message("\The 69user69 finishes wiping off the 69A69!")
			A.clean_blood()

/obj/item/reagent_containers/glass/rag/attack(atom/target as obj|turf|area,69ob/user, flag)
	if(isliving(target))
		var/mob/living/M = target
		if(on_fire)
			user.visible_message(SPAN_DANGER("\The 69user69 hits 69target69 with 69src69!"),)
			user.do_attack_animation(src)
			M.IgniteMob()
		else if(reagents.total_volume)
			if(user.targeted_organ == BP_MOUTH && ishuman(target))
				var/mob/living/carbon/human/H = target
				user.visible_message(SPAN_DANGER("\The 69user69 starts smothering 69H69 with 69src69!"), SPAN_DANGER("You start smothering 69H69 with 69src69!"))
				if(!H.check_mouth_coverage())
					if(do_after(user, 20, H))
						user.do_attack_animation(src)
						user.visible_message(SPAN_DANGER("\The 69user69 smothers 69H69 with 69src69!"), SPAN_DANGER("You smother 69H69 with 69src69!"))
						reagents.trans_to_mob(H, amount_per_transfer_from_this, CHEM_BLOOD)
						update_name()
						return

				user.do_attack_animation(src)
				user.visible_message(SPAN_DANGER("\The 69user69 tries to smother 69H69 with 69src69, but fails because the69outh is covered!"), SPAN_DANGER("You try to smother 69H69 with 69src69, but their69outh is covered!"))
			else
				wipe_down(target, user)
		return

	return ..()

/obj/item/reagent_containers/glass/rag/afterattack(atom/A as obj|turf|area,69ob/user, proximity)
	if(!proximity)
		return

	if(istype(A, /obj/structure/reagent_dispensers))
		if(!reagents.get_free_space())
			to_chat(user, SPAN_WARNING("\The 69src69 is already soaked."))
			return

		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			user.visible_message(SPAN_NOTICE("\The 69user69 soaks 69src69 using 69A69."), SPAN_NOTICE("You soak 69src69 using 69A69."))
			update_name()
		return

	if(!on_fire && istype(A) && (src in user))
		if(A.is_open_container() && !(A in user))
			remove_contents(user, A)
		else if(!ismob(A)) //mobs are handled in attack() - this prevents us from wiping down people while smothering them.
			wipe_down(A, user)
		return

/obj/item/reagent_containers/glass/rag/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 50 + T0C)
		ignite()
	if(exposed_temperature >= 900 + T0C)
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)

//rag69ust have a69inimum of 2 units welder fuel and at least 80% of the reagents69ust be welder fuel.
//maybe generalize flammable reagents someday
/obj/item/reagent_containers/glass/rag/proc/can_ignite()
	var/fuel = reagents.get_reagent_amount("fuel")
	return (fuel >= 2 && fuel >= reagents.total_volume*0.8)

/obj/item/reagent_containers/glass/rag/proc/ignite()
	if(on_fire)
		return
	if(!can_ignite())
		return

	//also copied from69atches
	if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
		visible_message(SPAN_DANGER("\The 69src69 conflagrates69iolently!"))
		var/datum/effect/effect/system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
		e.start()
		qdel(src)
		return

	START_PROCESSING(SSobj, src)
	set_light(2, null, "#E38F46")
	on_fire = 1
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/proc/extinguish()
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	on_fire = 0

	//rags sitting around with 1 second of burn time left is dumb.
	//ensures players always have a few seconds of burn time left when they light their rag
	if(burn_time <= 5)
		visible_message(SPAN_WARNING("\The 69src69 falls apart!"))
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/Process()
	if(!can_ignite())
		visible_message(SPAN_WARNING("\The 69src69 burns out."))
		extinguish()

	//copied from69atches
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

	if(burn_time <= 0)
		STOP_PROCESSING(SSobj, src)
		new /obj/effect/decal/cleanable/ash(location)
		qdel(src)
		return

	reagents.remove_reagent("fuel", reagents.maximum_volume/25)
	update_name()
	burn_time--
