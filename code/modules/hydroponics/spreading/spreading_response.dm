/obj/effect/plant/HasProximity(var/atom/movable/AM)

	if(!is_mature() || seed.get_trait(TRAIT_SPREAD) != 2)
		return

	var/mob/living/M = AM
	if(!istype(M))
		return

	if(!buckled_mob && !M.buckled && !M.anchored && (issmall(M) || prob(round(seed.get_trait(TRAIT_POTENCY)/6))))
		//wait a tick for the Entered() proc that called HasProximity() to finish (and thus the moving animation),
		//so we don't appear to teleport from two tiles away when moving into a turf adjacent to vines.
		spawn(1)
			entangle(M)

/obj/effect/plant/attack_hand(var/mob/user)
	manual_unbuckle(user)

/obj/effect/plant/attack_generic(var/mob/user)
	if(istype(user))
		manual_unbuckle(user)

/obj/effect/plant/proc/trodden_on(var/mob/living/victim)
	if(!is_mature())
		return
	var/mob/living/carbon/human/H = victim
	if(istype(H) && H.shoes)
		return
	seed.do_thorns(victim,src)
	seed.do_sting(victim,src,pick(BP_LEGS))

/obj/effect/plant/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
		buckled_mob = null
	return

/obj/effect/plant/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(prob(seed ? min(max(0,100 - seed.get_trait(TRAIT_POTENCY)/2),100) : 50))
			if(buckled_mob.buckled == src)
				if(buckled_mob != user)
					buckled_mob.visible_message(\
						SPAN_NOTICE("[user.name] frees [buckled_mob.name] from \the [src]."),\
						SPAN_NOTICE("[user.name] frees you from \the [src]."),\
						SPAN_WARNING("You hear shredding and ripping."))
				else
					buckled_mob.visible_message(\
						SPAN_NOTICE("[buckled_mob.name] struggles free of \the [src]."),\
						SPAN_NOTICE("You untangle \the [src] from around yourself."),\
						SPAN_WARNING("You hear shredding and ripping."))
			unbuckle()
		else
			var/text = pick("rip","tear","pull")
			user.visible_message(\
				SPAN_NOTICE("[user.name] [text]s at \the [src]."),\
				SPAN_NOTICE("You [text] at \the [src]."),\
				SPAN_WARNING("You hear shredding and ripping."))
	return

/obj/effect/plant/proc/entangle(var/mob/living/victim)

	if(buckled_mob)
		return

	if(victim.buckled)
		return

	//grabbing people
	if(!victim.anchored && Adjacent(victim) && victim.loc != get_turf(src))
		var/can_grab = 1
		if(ishuman(victim))
			var/mob/living/carbon/human/H = victim
			if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & NOSLIP))
				can_grab = 0
		if(can_grab)
			src.visible_message(SPAN_DANGER("Tendrils lash out from \the [src] and drag \the [victim] in!"))
			victim.loc = src.loc

	//entangling people
	if(victim.loc == src.loc)
		buckle_mob(victim)
		victim.set_dir(pick(cardinal))
		victim << "<span class='danger'>Tendrils [pick("wind", "tangle", "tighten")] around you!</span>"
