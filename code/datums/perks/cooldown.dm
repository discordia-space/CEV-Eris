/datum/perk/cooldown
	var/perk_lifetime = 3 MINUTES
	var/timestamp_start
	gain_text = "You feel tired. Your body needs some time to recover from all this training."

/datum/perk/cooldown/assign(mob/living/carbon/human/H)
	if(..())
		timestamp_start = world.time

/datum/perk/cooldown/on_process()
	if(!..() || ((timestamp_start + perk_lifetime) < world.time))
		holder.stats.removePerk(type)

/datum/perk/cooldown/exertion
	name = "Overexertion"
	desc = "Your muscles hurt after an intense workout. \
			Your TGH stat is reduced for some time. \
			A protein shake might help with recovery."
	icon_state = "exertion" //https://game-icons.net/1x1/delapouite/weight-lifting-up.html

/datum/perk/cooldown/exertion/on_process()
	if(holder.reagents.has_reagent("protein_shake"))
		perk_lifetime -= 3 SECONDS
	else if(holder.reagents.has_reagent("protein_shake_commercial"))
		perk_lifetime -= 2 SECONDS
	..()

/datum/perk/cooldown/exertion/assign(mob/living/carbon/human/H)
	if(..())
		holder.stats.addTempStat(STAT_TGH, -15, INFINITY, "Overexertion")

/datum/perk/cooldown/exertion/remove()
	if(holder)
		holder.stats.removeTempStat(STAT_TGH, "Overexertion")
	..()

/datum/perk/cooldown/reason
	name = "Dimmed reason"
	desc = "Your mind had soaked up a lot of knowledge. \
			Your COG stat is reduced for some time."
	icon_state = "reason" //https://game-icons.net/1x1/lorc/brainstorm.html

/datum/perk/cooldown/reason/on_process()
	if(holder.reagents.has_reagent("energy"))
		perk_lifetime -= 3 SECONDS
	..()

/datum/perk/cooldown/reason/assign(mob/living/carbon/human/H)
	if(..())
		holder.stats.addTempStat(STAT_COG, -15, INFINITY, "Dimmed reason")

/datum/perk/cooldown/reason/remove()
	if(holder)
		holder.stats.removeTempStat(STAT_COG, "Dimmed reason")
	..()
