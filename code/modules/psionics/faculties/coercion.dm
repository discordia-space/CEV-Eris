/decl/psionic_faculty/coercion
	id = PSI_COERCION
	name = "Coercion"
	associated_intent = I_DISARM
	armour_types = list(PSY)

/decl/psionic_power/coercion
	faculty = PSI_COERCION
	abstract_type = /decl/psionic_power/coercion

/decl/psionic_power/coercion/invoke(mob/living/user, mob/living/target)
	if (!istype(target))
		to_chat(user, SPAN_WARNING("You cannot mentally attack \the [target]."))
		return FALSE

	. = ..()
	if(. && target.deflect_psionic_attack(user))
		return FALSE

/decl/psionic_power/coercion/blindstrike
	name =           "Blindstrike"
	cost =           8
	cooldown =       120
	use_ranged =     TRUE
	use_melee =      TRUE
	min_rank =       PSI_RANK_GRANDMASTER
	use_description = "Target the eyes or mouth on disarm intent and click anywhere to use a radial attack that blinds, deafens and disorients everyone near you."

/decl/psionic_power/coercion/blindstrike/invoke(mob/living/user, mob/living/target)
	if(user.targeted_organ != BP_MOUTH && user.targeted_organ != BP_EYES)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user] suddenly throws back their head, as though screaming silently!"))
		to_chat(user, SPAN_DANGER("You strike at all around you with a deafening psionic scream!"))
		for(var/mob/living/M in orange(user, user.psi.get_rank(PSI_COERCION)))
			if(M == user)
				continue
			/* TODO: implement resistance to these effects via stat + immunity (NT)
			var/blocked = 100 * M.get_blocked_ratio(null, PSI)
			if(prob(blocked))
				to_chat(M, SPAN_DANGER("A psionic onslaught strikes your mind, but you withstand it!"))
				continue
			*/
			if(prob(60) && iscarbon(M))
				var/mob/living/carbon/C = M
				if(!(C.species && (C.species.flags & NO_PAIN)))
					M.emote("scream")
			to_chat(M, SPAN_DANGER("Your senses are blasted into oblivion by a psionic scream!"))
			M.flash(3, FALSE , FALSE , FALSE , 10)
			M.eye_blind = max(M.eye_blind,3)
			M.ear_deaf = max(M.ear_deaf,6)
			M.confused = rand(3,8)
		return TRUE

/decl/psionic_power/coercion/mindread
	name =            "Read Mind"
	cost =            6
	cooldown =        80
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Target the head on disarm intent at melee range to attempt to read a victim's surface thoughts."

/decl/psionic_power/coercion/mindread/invoke(mob/living/user, mob/living/target)
	if(!isliving(target) || !istype(target) || user.targeted_organ != BP_HEAD)
		return FALSE
	. = ..()
	if(!.)
		return

	if(target.stat == DEAD || (target.status_flags & FAKEDEATH) || !target.client)
		to_chat(user, SPAN_WARNING("\The [target] is in no state for a mind-ream."))
		return TRUE

	user.visible_message(SPAN_WARNING("\The [user] touches \the [target]'s temple..."))
	var/question =  input(user, "Say something?", "Read Mind", "Penny for your thoughts?") as null|text
	if(!question || user.incapacitated() || !do_after(user, 2 SECONDS, target, TRUE, TRUE, INCAPACITATION_DEFAULT, TRUE))
		return TRUE

	var/started_mindread = world.time
	to_chat(user, SPAN_NOTICE("<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking an answer: <i>[question]</i></b>"))
	to_chat(target, SPAN_NOTICE("<b>Your mind is compelled to answer: <i>[question]</i></b>"))

	var/answer =  input(target, question, "Read Mind") as null|text
	if(!answer || world.time > started_mindread + 60 SECONDS || user.stat != CONSCIOUS || target.stat == DEAD)
		to_chat(user, SPAN_NOTICE("<b>You receive nothing useful from \the [target].</b>"))
	else
		to_chat(user, SPAN_NOTICE("<b>You skim thoughts from the surface of \the [target]'s mind: <i>[answer]</i></b>"))
	msg_admin_attack("[key_name(user)] read mind of [key_name(target)] with question \"[question]\" and [answer?"got answer \"[answer]\".":"got no answer."]")
	return TRUE

/decl/psionic_power/coercion/agony
	name =          "Agony"
	cost =          8
	cooldown =      50
	use_melee =     TRUE
	min_rank =      PSI_RANK_OPERANT
	use_description = "Target the chest or groin on disarm intent to use a melee attack equivalent to a strike from a stun baton."

/decl/psionic_power/coercion/agony/invoke(mob/living/user, mob/living/target)
	if(!istype(target))
		return FALSE
	if(user.targeted_organ != BP_CHEST && user.targeted_organ != BP_GROIN)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [target] has been struck by \the [user]!"))
		message_admins("\The [target] has been struck by \the [user]!")
		playsound(user.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		target.stun_effect_act(0, 20 * user.psi.get_rank(PSI_COERCION), user.targeted_organ) // 40 agony damage by default - same as stunbaton. +20 for each rank above operant.
		return TRUE

/decl/psionic_power/coercion/psiblast
	name =             "Psiblast"
	cost =             20
	cooldown =         20
	use_ranged =       TRUE
	min_rank =         PSI_RANK_MASTER
	use_description = "Use this ranged psi attack while on disarm intent, targeting the chest or groin. Your mastery of Coercion will determine how powerful the laser is. Be wary of overuse, and try not to fry your own brain."

/decl/psionic_power/coercion/psiblast/invoke(mob/living/user, mob/living/target)
	if(!istype(target))
		return FALSE
	if(user.targeted_organ != BP_CHEST && user.targeted_organ != BP_GROIN)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user]'s eyes flare with light!"))

		var/user_rank = user.psi.get_rank(faculty)
		var/obj/item/projectile/pew
		var/pew_sound

		switch(user_rank)
			if(PSI_RANK_PARAMOUNT)
				pew = new /obj/item/projectile/beam/psychic/heavy(get_turf(user))
				pew_sound = 'sound/effects/psiblast.ogg'
			if(PSI_RANK_GRANDMASTER)
				pew = new /obj/item/projectile/beam/psychic(get_turf(user))
				pew_sound = 'sound/effects/psiblast.ogg'
			if(PSI_RANK_MASTER)
				pew = new /obj/item/projectile/beam/psychic/light(get_turf(user))
				pew_sound = 'sound/effects/psiblast.ogg'

		if(istype(pew))
			playsound(pew.loc, pew_sound, 25, 1)
			pew.original = target
			pew.current = target
			pew.starting = get_turf(user)
			pew.shot_from = user
			pew.launch(target, user.targeted_organ, (target.x-user.x), (target.y-user.y))
			return TRUE

/decl/psionic_power/coercion/spasm
	name =           "Spasm"
	cost =           15
	cooldown =       100
	use_melee =      TRUE
	use_ranged =     TRUE
	min_rank =       PSI_RANK_MASTER
	use_description = "Target the arms or hands on disarm intent to use a ranged attack that may rip the weapons away from the target."

/decl/psionic_power/coercion/spasm/invoke(mob/living/user, mob/living/carbon/human/target)
	if(!istype(target))
		return FALSE

	if(!(user.targeted_organ in list(BP_L_ARM, BP_R_ARM)))
		return FALSE

	. = ..()

	if(.)
		to_chat(user, SPAN_DANGER("You lash out, stabbing into \the [target] with a lance of psi-power."))
		to_chat(target, SPAN_DANGER("The muscles in your arms cramp horrendously!"))
		if(prob(75))
			target.emote("scream")

		for(var/obj/item/I in list(target.get_active_hand(), target.get_inactive_hand()))
			if(istype(I, /obj/item/grab)) //did they grab someone?
				target.break_all_grabs(user) //See about breaking grips or pulls
			else
				target.unEquip(I)
				target.visible_message(SPAN_DANGER("\The [target] drops \the [I] as their hand spasms!"))
				return
		return TRUE

/decl/psionic_power/coercion/mindslave
	name =          "Mindslave"
	cost =          28
	cooldown =      200
	use_grab =      TRUE
	min_rank =      PSI_RANK_PARAMOUNT
	use_description = "Grab a victim, target the eyes, then use the grab on them while on disarm intent, in order to convert them into a loyal mind-slave. The process takes some time, and failure is punished harshly."

/decl/psionic_power/coercion/mindslave/invoke(mob/living/user, mob/living/target)
	if(!istype(target) || user.targeted_organ != BP_EYES)
		return FALSE
	. = ..()
	if(.)
		if(target.stat == DEAD || (target.status_flags & FAKEDEATH))
			to_chat(user, SPAN_WARNING("\The [target] is dead!"))
			return TRUE
		if(!target.mind || !target.key)
			to_chat(user, SPAN_WARNING("\The [target] is mindless!"))
			return TRUE
		for(var/datum/antagonist/A in target.mind.antagonist)
			if(A.id == ROLE_THRALL)
				to_chat(user, SPAN_WARNING("\The [target] is already in thrall to someone!"))
				return TRUE
		user.visible_message(SPAN_DANGER("<i>\The [user] seizes the head of \the [target] in both hands...</i>"))
		to_chat(user, SPAN_WARNING("You plunge your mentality into that of \the [target]..."))
		to_chat(target, SPAN_DANGER("Your mind is invaded by the presence of \the [user]! They are trying to make you a slave!"))
		if(!do_after(user, (target.stat == CONSCIOUS ? 8 : 4) SECONDS, target, TRUE, TRUE, INCAPACITATION_DEFAULT, TRUE))
			user.psi.backblast(rand(10,25))
			return TRUE
		to_chat(user, SPAN_DANGER("You sear through \the [target]'s neurons, reshaping as you see fit and leaving them subservient to your will!"))
		to_chat(target, SPAN_DANGER("Your defenses have eroded away and \the [user] has made you their mindslave."))
		make_antagonist(target.mind, ROLE_THRALL)
		return TRUE

/decl/psionic_power/coercion/assay
	name =            "Assay"
	cost =            15
	cooldown =        100
	use_grab =        TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Grab a patient, target the head, then use the grab on them while on disarm intent, in order to perform a deep coercive-redactive probe of their psionic potential."

/decl/psionic_power/coercion/assay/invoke(mob/living/user, mob/living/target)
	if(user.targeted_organ != BP_HEAD)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_WARNING("\The [user] holds the head of \the [target] in both hands..."))
		to_chat(user, SPAN_NOTICE("You insinuate your mentality into that of \the [target]..."))
		to_chat(target, SPAN_WARNING("Your persona is being probed by the psychic lens of \the [user]."))
		if(!do_after(user, (target.stat == CONSCIOUS ? 5 : 2.5) SECONDS, target, TRUE, TRUE, INCAPACITATION_DEFAULT, TRUE))
			user.psi.backblast(rand(5,10))
			return TRUE
		to_chat(user, SPAN_NOTICE("You retreat from \the [target], holding your new knowledge close."))
		to_chat(target, SPAN_DANGER("Your mental complexus is laid bare to judgement of \the [user]."))
		target.show_psi_assay(user)
		return TRUE

/decl/psionic_power/coercion/focus
	name =          "Focus"
	cost =          10
	cooldown =      80
	use_grab =     TRUE
	min_rank =      PSI_RANK_OPERANT
	use_description = "Grab a patient, target the mouth, then use the grab on them while on disarm intent, in order to cure ailments of the mind."

/decl/psionic_power/coercion/focus/invoke(mob/living/user, mob/living/target)
	if(user.targeted_organ != BP_MOUTH)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_WARNING("\The [user] holds the head of \the [target] in both hands..."))
		to_chat(user, SPAN_NOTICE("You probe \the [target]'s mind for various ailments.."))
		to_chat(target, SPAN_WARNING("Your mind is being cleansed of ailments by \the [user]."))
		if(!do_after(user, (target.stat == CONSCIOUS ? 5 : 2.5) SECONDS, target, TRUE, TRUE, INCAPACITATION_DEFAULT, TRUE))
			user.psi.backblast(rand(5,10))
			return TRUE
		to_chat(user, SPAN_WARNING("You clear \the [target]'s mind of ailments."))
		to_chat(target, SPAN_WARNING("Your mind is cleared of ailments."))

		var/coercion_rank = user.psi.get_rank(PSI_COERCION)

		if(coercion_rank >= PSI_RANK_GRANDMASTER)
			target.AdjustParalysis(-1)

		target.drowsyness = 0

		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/C = target
			C.adjust_hallucination(-30)

			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = target
				var/datum/sanity/S = H.sanity

				if(coercion_rank >= PSI_RANK_MASTER)
					S.restoreLevel(coercion_rank * 15 - 35) // 10 for master, 40 for paramount
				if(coercion_rank >= PSI_RANK_GRANDMASTER && S.breakdowns.len)
					S.fix_breakdowns()

		return TRUE
