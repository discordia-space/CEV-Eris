/datum/ritual/cruciform/base
	name = "cruciform"
	phrase = null
	implant_type = /obj/item/weapon/implant/core_implant/cruciform
	success_message = "On the verge of audibility you hear pleasant music, your mind clears up and the spirit grows stronger. Your prayer was heard."
	fail_message = "The Cruciform feels cold against your chest."
	category = "Common"


/datum/ritual/targeted/cruciform/base
	name = "cruciform targeted"
	phrase = null
	implant_type = /obj/item/weapon/implant/core_implant/cruciform
	category = "Common"


/datum/ritual/cruciform/base/relief
	name = "Relief"
	phrase = "Et si ambulavero in medio umbrae mortis non timebo mala"
	desc = "Short litany to relieve pain of the afflicted."
	power = 50
	chance = 33

/datum/ritual/cruciform/base/relief/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	H.add_chemical_effect(CE_PAINKILLER, 10)
	return TRUE


/datum/ritual/cruciform/base/soul_hunger
	name = "Soul Hunger"
	phrase = "Panem nostrum cotidianum da nobis hodie"
	desc = "Litany of piligrims, helps better withstand hunger."
	power = 50
	chance = 33

/datum/ritual/cruciform/base/soul_hunger/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	H.nutrition += 100
	H.adjustToxLoss(5)
	return TRUE


/datum/ritual/cruciform/base/entreaty
	name = "Entreaty"
	phrase = "Deus meus ut quid dereliquisti me"
	desc = "Call for help, that other cruciform bearers can hear."
	power = 50
	chance = 60

/datum/ritual/cruciform/base/entreaty/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	for(var/mob/living/carbon/human/target in disciples)
		if(target == H)
			continue

		var/obj/item/weapon/implant/core_implant/cruciform/CI = target.get_core_implant()

		if((istype(CI) && CI.get_module(CRUCIFORM_PRIEST)) || prob(50))
			to_chat(target, SPAN_DANGER("[H], faithful cruciform follower, cries for salvation!"))
	return TRUE

/datum/ritual/cruciform/base/reveal
	name = "Reveal Adversaries"
	phrase = "Et fumus tormentorum eorum ascendet in saecula saeculorum: nec habent requiem die ac nocte, qui adoraverunt bestiam, et imaginem ejus, et si quis acceperit caracterem nominis ejus."
	desc = "Gain knowledge of your surroundings, to reveal evil in people and places. Can tell you about hostile creatures around you, rarely can help you spot traps, and sometimes let you sense a changeling."
	power = 35

/datum/ritual/cruciform/base/reveal/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C)
	var/was_triggired = FALSE
	if(prob(20)) //Aditional fail chance that hidded from user
		to_chat(H, SPAN_NOTICE("There is nothing there. You feel safe."))
		return TRUE
	for (var/mob/living/carbon/superior_animal/S in range(14, H))
		if (S.stat != DEAD)
			to_chat(H, SPAN_WARNING("Adversaries are near. You can feel something nasty and hostile."))
			was_triggired = TRUE
			break

	if (!was_triggired)
		for (var/mob/living/simple_animal/hostile/S in range(14, H))
			if (S.stat != DEAD)
				to_chat(H, SPAN_WARNING("Adversaries are near. You can feel something nasty and hostile."))
				was_triggired = TRUE
				break
	if (prob(80) && (locate(/obj/structure/wire_splicing) in view(7, H))) //Add more traps later
		to_chat(H, SPAN_WARNING("Something wrong with this area. Tread carefully."))
		was_triggired = TRUE
	if (prob(20))
		for(var/mob/living/carbon/human/target in range(14, H))
			if(target.mind && target.mind.changeling)
				to_chat(H, SPAN_DANGER("Something's ire is upon you! Twisted and evil mind touches you for a moment, leaving you in cold sweat."))
				was_triggired = TRUE
	if (!was_triggired)
		to_chat(H, SPAN_NOTICE("There is nothing there. You feel safe."))
	return TRUE


