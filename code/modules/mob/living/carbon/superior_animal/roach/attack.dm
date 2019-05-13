/mob/living/carbon/superior_animal/roach/UnarmedAttack(var/atom/A, var/proximity)
	if(isliving(A))
		var/mob/living/L = A
		if(ishuman(A))
			var/mob/living/carbon/human/H = L
			var/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris/howdoitameahorseinminecraft = H.get_active_hand()
			if(istype(howdoitameahorseinminecraft))
				if(try_tame(H, howdoitameahorseinminecraft))
					return FALSE //If they manage to tame the roach, stop the attack
		if(istype(L) && !L.weakened && prob(5))
			L.Weaken(3)
			L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))

	. = ..()


