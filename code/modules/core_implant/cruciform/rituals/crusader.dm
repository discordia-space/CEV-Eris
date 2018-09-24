/datum/ritual/cruciform/crusader
	name = "crusader"
	phrase = null
	desc = ""
	category = "Crusader"

/datum/ritual/cruciform/crusader/battle_call
	name = "Call to Battle"
	phrase = "Si exieritis ad bellum de terra vestra contra hostes qui dimicant adversum vos clangetis ululantibus tubis et erit recordatio vestri coram Domino Deo vestro ut eruamini de manibus inimicorum vestrorum."
	desc = "Inspires the prayer and gives him strength to protect the other cyberchristians. True strength in unity."
	cooldown = TRUE
	cooldown_time = 10 MINUTES
	cooldown_category = "battle call"
	effect_time = 10 MINUTES

/datum/ritual/cruciform/crusader/battle_call/pre_check(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, targets)
	if(cooldown && is_on_cooldown(H))
		fail("This type of litany can't be spoken too often.", H, C)
		return FALSE
	return TRUE

/datum/ritual/cruciform/crusader/battle_call/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)
	var/count = 0
	for(var/mob/living/carbon/human/brother in view(user))
		if(brother.get_cruciform())
			count += 2

	user.stats.changeStat(STAT_TGH, count)
	user.stats.changeStat(STAT_ROB, count)
	user << SPAN_NOTICE("You feel an extraordinary burst of energy.")
	set_personal_cooldown(user)
	addtimer(CALLBACK(src, .proc/discard_effect, user, count), src.cooldown_time)
	return TRUE

/datum/ritual/cruciform/crusader/battle_call/proc/discard_effect(mob/living/carbon/human/user, amount)
	user.stats.changeStat(STAT_TGH, -amount)
	user.stats.changeStat(STAT_ROB, -amount)


/datum/ritual/cruciform/crusader/flash
	name = "Searing Revelation"
	phrase = "Per Christum Dominum nostrum."
	desc = "Knocks over everybody without cruciform in the view range. Psy-wave is too powerful, speaker can be knocked too."
	cooldown = TRUE
	cooldown_time = 2 MINUTES
	cooldown_category = "flash"

/datum/ritual/cruciform/crusader/flash/pre_check(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, targets)
	if(cooldown && is_on_cooldown(H))
		fail("This type of litany can't be spoken too often.", H, C)
		return FALSE
	return TRUE

/datum/ritual/cruciform/crusader/flash/perform(mob/living/carbon/human/user, obj/item/weapon/implant/core_implant/C)
	user.Weaken(10)
	user << SPAN_WARNING("The flux of psy-energy knocks over you!")
	playsound(user.loc, 'sound/effects/cascade.ogg', 65, 1)
	for(var/mob/living/carbon/human/victim in view(user))
		if(!victim.get_cruciform())
			victim << SPAN_WARNING("You feel that your knees bends!")
			victim.Weaken(5)
	set_personal_cooldown(user)
	return TRUE