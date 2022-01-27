/obj/item/device/assembly/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	icon_state = "mousetrap"
	origin_tech = list(TECH_COMBAT = 1)
	matter = list(MATERIAL_PLASTIC = 1,69ATERIAL_STEEL = 1)
	var/armed = FALSE
	var/prob_catch = 100


	examine(mob/user)
		..(user)
		if(armed)
			to_chat(user, "It looks like it's armed.")

	update_icon()
		if(armed)
			icon_state = "mousetraparmed"
		else
			icon_state = "mousetrap"
		if(holder)
			holder.update_icon()

/obj/item/device/assembly/mousetrap/proc/triggered(var/mob/living/target,69ar/type = "feet")
	if(!armed || !istype(target))
		return

	//var/types = target.get_classification()
	if(ismouse(target))
		var/mob/living/simple_animal/mouse/M = target
		visible_message("<span class='danger'>SPLAT!</span>")
		M.splat()
	else
		var/zone = "chest"
		if(ishuman(target) && target.mob_size)
			var/mob/living/carbon/human/H = target
			switch(type)
				if("feet")
					zone = pick(BP_L_LEG , BP_R_LEG)
					if(!H.shoes)
						H.adjustHalLoss(500/(target.mob_size))//Halloss instead of instant knockdown
						//Mainly for the benefit of giant69onsters like69aurca breeders
				if(BP_L_ARM , BP_R_ARM)
					zone = type
					if(!H.gloves)
						H.adjustHalLoss(250/(target.mob_size))
		if (!isrobot(target))
			target.damage_through_armor(rand(15,30), HALLOSS, zone, ARMOR_MELEE, used_weapon = src)
			target.damage_through_armor(rand(8,15), BRUTE, zone, ARMOR_MELEE, used_weapon = src)

	playsound(target.loc, 'sound/effects/snap.ogg', 50, 1)
	layer =69OB_LAYER - 0.2
	armed = FALSE
	update_icon()
	pulse(0)


/obj/item/device/assembly/mousetrap/attack_self(mob/living/user as69ob)
	if(!armed)
		to_chat(user, "<span class='notice'>You arm 69src69.</span>")
	else
		if((CLUMSY in user.mutations)&& prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>69user69 accidentally sets off 69src69, breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger 69src69!</span>")
			return
		to_chat(user, "<span class='notice'>You disarm 69src69.</span>")
	armed = !armed
	update_icon()
	playsound(user.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -3)


/obj/item/device/assembly/mousetrap/attack_hand(mob/living/user as69ob)
	if(armed)
		if((CLUMSY in user.mutations) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>69user69 accidentally sets off 69src69, breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger 69src69!</span>")
			return
	..()


/obj/item/device/assembly/mousetrap/Crossed(AM as69ob|obj)
	if(armed)
		if(ismouse(AM))
			triggered(AM)
		else if(istype(AM, /mob/living))
			var/mob/living/L = AM
			var/true_prob_catch = prob_catch - L.skill_to_evade_traps()
			if(!prob(true_prob_catch))
				return ..()
			triggered(L)
			L.visible_message("<span class='warning'>69L69 accidentally steps on 69src69.</span>", \
							  "<span class='warning'>You accidentally step on 69src69</span>")

	..()


/obj/item/device/assembly/mousetrap/on_found(mob/finder as69ob)
	if(armed)
		finder.visible_message("<span class='warning'>69finder69 accidentally sets off 69src69, breaking their fingers.</span>", \
							   "<span class='warning'>You accidentally trigger 69src69!</span>")
		triggered(finder, finder.hand ? "l_hand" : "r_hand")
		return TRUE	//end the search!
	return FALSE


/obj/item/device/assembly/mousetrap/hitby(A as69ob|obj)
	if(!armed)
		return ..()
	visible_message("<span class='warning'>69src69 is triggered by 69A69.</span>")
	triggered(null)


/obj/item/device/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = TRUE
	rarity_value = 12.5
	spawn_frequency = 10
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_TRAP_ARMED


/obj/item/device/assembly/mousetrap/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(usr.stat)
		return

	layer = TURF_LAYER+0.2
	to_chat(usr, "<span class='notice'>You hide 69src69.</span>")
