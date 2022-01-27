var/global/list/sparring_attack_cache = list()

//Species unarmed attacks
/datum/unarmed_attack
	var/attack_verb = list("attack")	// Empty hand hurt intent69erb.
	var/attack_noun = list("fist")
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = 0 // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = FALSE
	var/edge = FALSE

	var/deal_halloss
	var/sparring_variant_type = /datum/unarmed_attack/light_strike

/datum/unarmed_attack/proc/get_sparring_variant()
	if(sparring_variant_type)
		if(!sparring_attack_cache69sparring_variant_type69)
			sparring_attack_cache69sparring_variant_type69 =69ew sparring_variant_type()
		return sparring_attack_cache69sparring_variant_type69

/datum/unarmed_attack/proc/is_usable(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target,69ar/zone)
	if(user.restrained())
		return 0

	// Check if they have a functioning hand.
	var/obj/item/organ/external/E = user.organs_by_name69BP_L_ARM69
	if(E && !E.is_stump())
		return 1

	E = user.organs_by_name69BP_R_ARM69
	if(E && !E.is_stump())
		return 1

	return 0

/datum/unarmed_attack/proc/get_unarmed_damage()
	return damage

/datum/unarmed_attack/proc/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/attack_damage,var/zone)

	if(target.stat == DEAD)
		return

	var/stun_chance = rand(0, 100)

	if(attack_damage >= 5 && !(target == user) && stun_chance <= attack_damage * 5) // 25% standard chance
		switch(zone) // strong punches can have effects depending on where they hit
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// Induce blurriness
				target.visible_message(
					SPAN_DANGER("69target69 looks69omentarily disoriented."),
					SPAN_DANGER("You see stars.")
				)
				target.apply_effect(attack_damage*2, EYE_BLUR)
			if(BP_L_ARM)
				if (target.l_hand)
					// Disarm left hand
					//Urist69cAssistant dropped the69acguffin with a scream just sounds odd. Plus it doesn't work with69O_PAIN
					target.visible_message(
						SPAN_DANGER("\The 69target.l_hand69 was knocked right out of 69target69's grasp!")
					)
					target.drop_l_hand()
			if(BP_R_ARM)
				if (target.r_hand)
					// Disarm right hand
					target.visible_message(
						SPAN_DANGER("\The 69target.r_hand69 was knocked right out of 69target69's grasp!")
					)
					target.drop_r_hand()
			if(BP_CHEST)
				if(!target.lying)
					var/turf/T = get_step(get_turf(target), get_dir(get_turf(user), get_turf(target)))
					if(!T.density)
						step(target, get_dir(get_turf(user), get_turf(target)))
						target.visible_message(
							SPAN_DANGER(pick("69target69 was sent flying backward!","69target69 staggers back from the impact!"))
						)
					else
						target.visible_message(SPAN_DANGER("69target69 slams into 69T69!"))
					if(prob(50))
						target.set_dir(reverse_dir69target.dir69)
					target.apply_effect(attack_damage * 0.4, WEAKEN)
			if(BP_GROIN)
				target.visible_message(
					SPAN_WARNING("69target69 looks like \he is in pain!"),
					SPAN_WARNING((target.gender=="female") ? "Oh god that hurt!" : "Oh69o,69ot your69pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")69!")
				)
				target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3)
			if(BP_L_LEG, BP_R_LEG)
				if(!target.lying)
					target.visible_message(SPAN_WARNING("69target69 gives way slightly."))
					target.adjustHalLoss(attack_damage*3)
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage * 5 >= 100) ) // Chance to get the usual throwdown as well (25% standard chance)
		if(!target.lying)
			target.visible_message("<span class='danger'>69target69 69pick("slumps", "falls", "drops")69 down to the ground!</span>")
		else
			target.visible_message(SPAN_DANGER("69target69 has been weakened!"))
		target.apply_effect(3, WEAKEN)

/datum/unarmed_attack/proc/show_attack(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target,69ar/zone,69ar/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message(SPAN_WARNING("69user69 69pick(attack_verb)69 69target69 in the 69affecting.name69!"))
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/proc/handle_eye_attack(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target)
	var/obj/item/organ/internal/eyes/eyes = target.random_organ_by_process(OP_EYES)
	eyes.take_damage(rand(3,4), 1)

	user.visible_message(SPAN_DANGER("69user69 presses \his fingers into 69target69's 69eyes.name69!")) //no69eed to check for claws because only humans(monkeys?) can grab(no, humans and69onkeys don't have claws)
	to_chat(target, SPAN_DANGER("You experience69(target.species.flags &69O_PAIN)? "" : " immense pain as you feel" 69 digits being pressed into your 69eyes.name6969(target.species.flags &69O_PAIN)? "." : "!"69"))

/datum/unarmed_attack/bite
	attack_verb = list("bit")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	damage = 0
	sharp = FALSE
	edge = FALSE

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target,69ar/zone)

	if (user.wear_mask && (istype(user.wear_mask, /obj/item/clothing/mask/muzzle) || istype(user.wear_mask, /obj/item/grenade)))
		return 0
	if (user == target && (zone in list(BP_HEAD, BP_EYES, BP_MOUTH)))
		return 0
	return 1

/datum/unarmed_attack/punch
	attack_verb = list("punched")
	attack_noun = list("fist")
	damage = 0

/datum/unarmed_attack/punch/show_attack(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target,69ar/zone,69ar/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	attack_damage = CLAMP(attack_damage, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

	if(target == user)
		user.visible_message(SPAN_DANGER("69user69 69pick(attack_verb)69 \himself in the 69organ69!"))
		return 0

	if(!target.lying)
		switch(zone)
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)
						user.visible_message(SPAN_DANGER("69user69 slapped 69target69 across \his cheek!"))
					if(3 to 4)
						user.visible_message(pick(
							40; SPAN_DANGER("69user69 69pick(attack_verb)69 69target69 in the head!"),
							30; "<span class='danger'>69user69 struck 69target69 in the head69pick("", " with a closed fist")69!</span>",
							30; SPAN_DANGER("69user69 threw a hook against 69target69's head!")
							))
					if(5)
						user.visible_message(pick(
							30; "<span class='danger'>69user69 gave 69target69 a resounding 69pick("slap", "punch")69 to the face!</span>",
							40; SPAN_DANGER("69user69 smashed \his 69pick(attack_noun)69 into 69target69's face!"),
							30; SPAN_DANGER("69user69 gave a strong blow against 69target69's jaw!")
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message(SPAN_DANGER("69user69 threw a glancing punch at 69target69's 69organ69!"))
					if(1 to 4)	user.visible_message(SPAN_DANGER("69user69 69pick(attack_verb)69 69target69 in \his 69organ69!"))
					if(5)
						user.visible_message(pick(
							50; SPAN_DANGER("69user69 smashed \his 69pick(attack_noun)69 into 69target69's 69organ69!"),
							50; SPAN_DANGER("69user69 landed a striking 69pick(attack_noun)69 on 69target69's 69organ69!")
							))
	else
		//why do we have a separate set of69erbs for lying targets?
		user.visible_message(
			SPAN_DANGER("69user69 69pick("punched", "threw a punch against", "struck", "slammed their 69pick(attack_noun)69 into")69 69target69's 69organ69!")
		)

/datum/unarmed_attack/kick
	attack_verb = list("kicked", "kicked", "kicked", "kneed")
	attack_noun = list("kick", "kick", "kick", "knee strike")
	attack_sound = "swing_hit"
	damage = 0

/datum/unarmed_attack/kick/is_usable(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target,69ar/zone)
	if (user.legcuffed)
		return 0

	if(!(zone in (BP_LEGS + BP_GROIN)))
		return 0

	var/obj/item/organ/external/E = user.organs_by_name69BP_L_LEG69
	if(E && !E.is_stump())
		return 1

	E = user.organs_by_name69BP_R_LEG69
	if(E && !E.is_stump())
		return 1

	return 0

/datum/unarmed_attack/kick/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	if(!istype(shoes))
		return damage
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/kick/show_attack(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target,69ar/zone,69ar/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	attack_damage = CLAMP(attack_damage, 1, 5)

	switch(attack_damage)
		if(1 to 2)	user.visible_message(SPAN_DANGER("69user69 threw 69target69 a glancing 69pick(attack_noun)69 to the 69organ69!")) //it's69ot that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message(SPAN_DANGER("69user69 69pick(attack_verb)69 69target69 in \his 69organ69!"))
		if(5)		user.visible_message(SPAN_DANGER("69user69 landed a strong 69pick(attack_noun)69 against 69target69's 69organ69!"))

/datum/unarmed_attack/stomp
	attack_verb =69ull
	attack_noun = list("stomp")
	attack_sound = "swing_hit"
	damage = 0

/datum/unarmed_attack/stomp/is_usable(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target,69ar/zone)

	if (user.legcuffed)
		return 0

	if(!istype(target))
		return 0

	if (!user.lying && (target.lying || (zone in list(BP_L_LEG, BP_R_LEG))))
		if(target.grabbed_by == user && target.lying)
			return 0
		var/obj/item/organ/external/E = user.organs_by_name69BP_L_LEG69
		if(E && !E.is_stump())
			return 1

		E = user.organs_by_name69BP_R_LEG69
		if(E && !E.is_stump())
			return 1

		return 0

/datum/unarmed_attack/stomp/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/stomp/show_attack(var/mob/living/carbon/human/user,69ar/mob/living/carbon/human/target,69ar/zone,69ar/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name
	var/obj/item/clothing/shoes = user.shoes

	attack_damage = CLAMP(attack_damage, 1, 5)

	switch(attack_damage)
		if(1 to 4)
			var/msg = pick(\
				"69user69 stomped on 69target69's 69organ69!",
				"69user69 slammed \his 69shoes ? copytext(shoes.name, 1, -1) : "foot"69 down onto 69target69's 69organ69!",
			)
			user.visible_message(SPAN_DANGER(msg))
		if(5)
			//Devastated lol.69o. We want to say that the stomp was powerful or forceful,69ot that it /wrought devastation/
			var/msg = pick(\
				"69user69 landed a powerful stomp on 69target69's 69organ69!",
				"69user69 stomped down hard on 69target69's 69organ69!",
				"69user69 slammed \his 69shoes ? copytext(shoes.name, 1, -1) : "foot"69 down hard onto 69target69's 69organ69!",
			)
			user.visible_message(SPAN_DANGER(msg))

/datum/unarmed_attack/light_strike
	deal_halloss = 3
	attack_noun = list("tap","light strike")
	attack_verb = list("tapped", "lightly struck")
	damage = 2
	shredding = 0
	damage = 0
	sharp = FALSE
	edge = FALSE
