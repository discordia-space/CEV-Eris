/datum/perk/dreamer
	name = "Dreamer"
	desc = "Your dreams crystallize in the palms of your hands."
	icon_state = "dreamer" // https://game-icons.net/1x1/lorc/crystalize.html

/datum/perk/dreamer/assign(mob/living/carbon/human/H)
	. = ..()
	if(H)
		// Tweaked roach toxin boons
		H.stats.addTempStat(STAT_MEC, 10, INFINITY, "dreamer")
		H.stats.addTempStat(STAT_TGH, 5, INFINITY, "dreamer")
		H.stats.addTempStat(STAT_ROB, 5, INFINITY, "dreamer")
		H.stats.addTempStat(STAT_VIG, 5, INFINITY, "dreamer")

/datum/perk/dreamer/remove()
	if(holder)
		holder.stats.removeTempStat(STAT_MEC, "dreamer")
		holder.stats.removeTempStat(STAT_TGH, "dreamer")
		holder.stats.removeTempStat(STAT_ROB, "dreamer")
		holder.stats.removeTempStat(STAT_VIG, "dreamer")
		to_chat(holder, SPAN_NOTICE("<i>Your aspirations slip through your fingers.</i>"))
	..()

/datum/perk/eighth_eye
	name = "Eighth Eye"
	desc = "The color of Null Sector is burned into your mind."
	icon_state = "eighth_eye" // https://game-icons.net/1x1/lorc/sunken-eye.html

/datum/perk/eighth_eye/assign(mob/living/carbon/human/H)
	. = ..()
	if(H)
		// Tweaked spider venom boon + a BIO boon
		H.stats.addTempStat(STAT_COG, 10, INFINITY, "eighth_eye")
		H.stats.addTempStat(STAT_BIO, 5, INFINITY, "eighth_eye")

/datum/perk/eighth_eye/remove()
	if(holder)
		holder.stats.removeTempStat(STAT_COG, "eighth_eye")
		holder.stats.removeTempStat(STAT_BIO, "eighth_eye")
		to_chat(holder, SPAN_NOTICE("<i>The vessel that is your world becomes dull again.</i>"))
	..()
