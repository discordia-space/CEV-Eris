/datum/unarmed_attack/bite/sharp //eye teeth
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = 1
	edge = 1

/datum/unarmed_attack/claws
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = 1
	edge = 1

/datum/unarmed_attack/claws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	attack_damage = CLAMP(attack_damage, 1, 5)

	if(target == user)
		user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] \himself in the [affecting.name]!"))
		return 0

	switch(zone)
		if(BP_HEAD, BP_MOUTH, BP_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message(SPAN_DANGER("[user] scratched [target] across \his cheek!"))
				if(3 to 4)
					user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target]'s [pick(BP_HEAD, "neck")]!</span>") //'with spread claws' sounds a little bit odd, just enough that conciseness is better here I think
				if(5)
					user.visible_message(pick(
						SPAN_DANGER("[user] rakes \his [pick(attack_noun)] across [target]'s face!"),
						SPAN_DANGER("[user] tears \his [pick(attack_noun)] into [target]'s face!"),
						))
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message(SPAN_DANGER("[user] scratched [target]'s [affecting.name]!"))
				if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("", "", "the side of")] [target]'s [affecting.name]!</span>")
				if(5)		user.visible_message("<span class='danger'>[user] tears \his [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]!</span>")

/datum/unarmed_attack/claws/strong
	attack_verb = list("slashed")
	damage = 5
	shredding = 1

/datum/unarmed_attack/bite/strong
	attack_verb = list("mauled")
	damage = 8
	shredding = 1

/datum/unarmed_attack/slime_glomp
	attack_verb = list("glomped")
	attack_noun = list("body")
	damage = 2

/datum/unarmed_attack/slime_glomp/apply_effects()
	//Todo, maybe have a chance of causing an electrical shock?
	return

/datum/unarmed_attack/stomp/weak
	attack_verb = list("jumped on")

/datum/unarmed_attack/stomp/weak/get_unarmed_damage()
	return damage

/datum/unarmed_attack/stomp/weak/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message(SPAN_WARNING("[user] jumped up and down on \the [target]'s [affecting.name]!"))
	playsound(user.loc, attack_sound, 25, 1, -1)