//////Kitchen Spike

/obj/structure/kitchenspike
	name = "meat spike"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals."
	description_antag = "You can also butcher people"
	density = TRUE
	anchored = TRUE
	var/mob/living/occupant
	var/meat = 0
	var/occupied = FALSE
	var/meat_type
	var/victim_name = "corpse"
	var/tearing

/obj/structure/kitchenspike/affect_grab(mob/user, mob/living/target, state)
	if(occupied)
		to_chat(user, SPAN_DANGER("\The [src] already has something on it, finish collecting its meat first!"))
		return FALSE
	if(state != GRAB_KILL)
		to_chat(user, SPAN_NOTICE("You need to grab \the [target] by the neck!"))
		return FALSE
	var/mob/living/carbon/human/H = target
	var/list/damaged = H.get_damaged_organs(TRUE, FALSE)
	for(var/obj/item/organ/external/chest/G in damaged)
		if(G.brute_dam > 200)
			to_chat(user, "[H] is too badly damaged to hold onto the meat spike.")
			return
	visible_message(SPAN_DANGER("[user] is trying to force \the [target] onto \the [src]!"))
	if(do_after(user, 80))
		if(spike(target))
			visible_message(SPAN_DANGER("[user] has forced [target] onto \the [src], killing them instantly!"))
			target.damage_through_armor(201, BRUTE, BP_CHEST)
			for(var/obj/item/thing in target)
				if(thing.is_equipped())
					target.drop_from_inventory(thing)
			return TRUE
	else
		return FALSE


/obj/structure/kitchenspike/proc/spike(mob/living/victim)

	if(!istype(victim))
		return

	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		meat_type = H.species.meat_type
		icon_state = "spike_[H.species.name]"
	else
		return FALSE
	victim.loc = src
	victim_name = victim.name
	occupant = victim
	occupied = TRUE
	meat = 5
	return TRUE

/obj/structure/kitchenspike/attack_hand(mob/living/carbon/human/user)
	if(..() || !occupied)
		return
	to_chat(user, "You start to remove [victim_name] from \the [src].")
	if(!do_after(user, 40))
		return 0
	occupant.loc = get_turf(src)
	occupied = FALSE
	meat = 0
	meat_type = initial(meat_type)
	to_chat(user, "You remove [victim_name] from \the [src].")
	icon_state = initial(icon_state)

/obj/structure/kitchenspike/attackby(obj/item/I, mob/living/carbon/human/user)
	var/list/usable_qualities = list(QUALITY_BOLT_TURNING, QUALITY_CUTTING)
	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	if(tearing)
		return

	if(tool_type == QUALITY_CUTTING)
		if(!occupied)
			return
		tearing = TRUE
		if(do_after(user, 20))
			tearing = FALSE
			var/organ_damaged = pickweight(list(BP_HEAD = 0.1, BP_GROIN = 0.2, BP_R_ARM = 0.2, BP_L_ARM = 0.2, BP_R_LEG = 0.2, BP_L_LEG = 0.2))
			var/cut_damage = rand(15, 25)
			occupant.apply_damage(cut_damage, BRUTE, organ_damaged)
			playsound(src, 'sound/weapons/bladeslice.ogg', 50, 1)
			if(meat < 1)
				to_chat(user, "There is no more meat on \the [victim_name].")
				return
			new meat_type(get_turf(src))
			if(meat > 1)
				to_chat(user, "You remove some meat from \the [victim_name].")
			else if(meat == 1)
				to_chat(user, "You remove the last piece of meat from \the [victim_name]!")
			meat--
			if(meat_type == user.species.meat_type)
				user.sanity.changeLevel(-(15*((user.nutrition ? user.nutrition : 1)/user.max_nutrition))) // The more hungry the less sanity damage.
				to_chat(user, SPAN_NOTICE("You feel your [user.species.name]ity shrivel as you cut a slab off \the [src]")) // Human-ity , Monkey-ity , Slime-Ity
		else
			tearing = FALSE

	else if (tool_type == QUALITY_BOLT_TURNING)
		if (!occupied)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."),SPAN_NOTICE("You dismantle \the [src]."))
				new /obj/item/stack/rods(loc, 3)
				qdel(src)
			return
		else
			to_chat(user, SPAN_DANGER(" \The [src] has something on it, remove it first!"))
			return

	else
		return ..()

/obj/structure/kitchenspike/examine(mob/user, distance, infix, suffix)
	if(distance < 4)
		to_chat(user, SPAN_NOTICE("\a [victim_name] is hooked onto \the [src]"))
	..()

