/mob/living/carbon/superior_animal/roach/UnarmedAttack(var/atom/A,69ar/proximity)
	if(isliving(A))
		var/mob/living/L = A
		var/mob/living/carbon/human/H
		if(ishuman(L))
			H = L
		if(H)
			var/obj/item/reagent_containers/food/snacks/grown/howdoitameahorseinminecraft = H.get_active_hand()
			if(istype(howdoitameahorseinminecraft))
				if(try_tame(H, howdoitameahorseinminecraft))
					return FALSE //If they69anage to tame the roach, stop the attack
		if(istype(L) && !L.weakened && prob(5))
			if(H && H.has_shield())
				L.visible_message(SPAN_DANGER("\the 69src69 tried to knocks down \the 69L69! But 69L69 blocks \the 69src69 attack!"))
			else
				L.Weaken(3)
				L.visible_message(SPAN_DANGER("\the 69src69 knocks down \the 69L69!"))

	. = ..()


