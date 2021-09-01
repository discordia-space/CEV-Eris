//////Kitchen Spike

/obj/structure/kitchenspike
	name = "meat spike"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals."
	density = TRUE
	anchored = TRUE
	var/meat = 0
	var/occupied
	var/meat_type
	var/victim_name = "corpse"

/obj/structure/kitchenspike/affect_grab(var/mob/user, var/mob/living/target)
	if(occupied)
		to_chat(user, SPAN_DANGER("The spike already has something on it, finish collecting its meat first!"))
	else
		if(spike(target))
			visible_message(SPAN_DANGER("[user] has forced [target] onto the spike, killing them instantly!"))
			qdel(target)
			return TRUE
		else
			to_chat(user, SPAN_DANGER("They are too big for the spike, try something smaller!"))

/obj/structure/kitchenspike/proc/spike(var/mob/living/victim)

	if(!istype(victim))
		return

	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		meat_type = H.species.meat_type
		icon_state = "spike_[H.species.name]"
	else
		return 0

	victim_name = victim.name
	occupied = 1
	meat = 5
	return 1

/obj/structure/kitchenspike/attack_hand(mob/living/carbon/user)
	if(..() || !occupied)
		return
	meat--
	new meat_type(get_turf(src))
	if(meat > 1)
		to_chat(user, "You remove some meat from \the [victim_name].")
	else if(meat == 1)
		to_chat(user, "You remove the last piece of meat from \the [victim_name]!")
		icon_state = "spike"
		occupied = 0
	if(meat_type == user.species.meat_type)
		user.sanity_damage += 5*((user.nutrition ? user.nutrition : 1)/user.max_nutrition) // The more hungry the less sanity damage.
		to_chat(user, SPAN_NOTICE("You feel your [user.species.name]ity dismantling as you cut a slab off \the [src]")) // Human-ity , Monkey-ity , Slime-Ity


/obj/structure/kitchenspike/attackby(obj/item/I, mob/user)
	var/list/usable_qualities = list(QUALITY_BOLT_TURNING)
	var/tool_type = I.get_tool_type(user, usable_qualities, src)

	if (tool_type == QUALITY_BOLT_TURNING)
		if (!occupied)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."),SPAN_NOTICE("You dismantle \the [src]."))
				new /obj/item/stack/rods(loc, 3)
				qdel(src)
			return
		else
			to_chat(user, SPAN_DANGER("The spike has something on it, finish collecting its meat first!"))
			return

	return ..()
