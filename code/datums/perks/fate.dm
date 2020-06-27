/datum/perk/paper_worm
	name = "Paper Worm"
	desc = "You always look at the bright side of life but seems there's something you'd forgotten"
	icon_state = "paper"

/datum/perk/paper_worm/assign(mob/living/carbon/human/H)
	..()
	holder.sanity.positive_prob += 20

/datum/perk/paper_worm/remove()
	holder.sanity.positive_prob -= 20
	..()

/datum/perk/freelancer
	name = "Freelancer"
	icon_state = "skills"
	desc = "You're a jack of all trades but master of none"

/datum/perk/freelancer/assign(mob/living/carbon/human/H)
	..()
	var/maxstatindex
	for (var/i=1 to holder.stats.stat_list.len-1)
		if(holder.stats.getStat(holder.stats.stat_list[i]) > holder.stats.getStat(holder.stats.stat_list[i+1]))
			maxstatindex = i
		else
			maxstatindex = i+1
	for(var/name in holder.stats.stat_list)
		if(name != holder.stats.stat_list[maxstatindex])
			holder.stats.addTempStat(name, 4, INFINITY, "Fate Freelancer")
		else
			holder.stats.addTempStat(name, -10, INFINITY, "Fate Freelancer")

/datum/perk/freelancer/remove()
	holder.stats.removeTempStat(STAT_MEC, "Fate Freelancer")
	holder.stats.removeTempStat(STAT_COG, "Fate Freelancer")
	holder.stats.removeTempStat(STAT_BIO, "Fate Freelancer")
	holder.stats.removeTempStat(STAT_ROB, "Fate Freelancer")
	holder.stats.removeTempStat(STAT_TGH, "Fate Freelancer")
	holder.stats.removeTempStat(STAT_VIG, "Fate Freelancer")
	..()

/datum/perk/nihilist
	name = "Nihilist"
	desc= "You have lost faith in this world and in its people."
	icon_state = "eye" //https://game-icons.net/1x1/lorc/tear-tracks.html

/datum/perk/nihilist/assign(mob/living/carbon/human/H)
	..()
	holder.sanity.positive_prob += 10
	holder.sanity.negative_prob += 20

/datum/perk/nihilist/remove()
	holder.sanity.positive_prob -= 10
	holder.sanity.negative_prob -= 20
	holder.stats.removeTempStat(STAT_COG, "Fate Nihilist")
	..()

/datum/perk/moralist
	name = "Moralist"
	icon_state = "moralist" //https://game-icons.net/
	desc = "You are a good human being. Love life, and life will love you back. Love people, and they will love you back."

/datum/perk/drug_addict
	name = "Drug Addict"
	icon_state = "medicine" //https://game-icons.net/1x1/delapouite/medicines.html
	desc = "You have absolutely no pleasure in the stimulants you indulge. It's a desperate attempt to escape from the dread of some strange impending doom"

/datum/perk/drug_addict/assign(mob/living/carbon/human/H)
	..()
	spawn(1)
		var/turf/T = get_turf(holder)
		var/drugtype = pick(subtypesof(/datum/reagent/drug))
		if(!(drugtype in holder.metabolism_effects.addiction_list))
			var/datum/reagent/drug = new drugtype
			holder.metabolism_effects.addiction_list.Add(drug)
			for(var/j= 1 to 2)
				var/obj/item/weapon/storage/pill_bottle/PB = new /obj/item/weapon/storage/pill_bottle(T)
				PB.name = "bottle of happiness"
				for(var/i=1 to 7)
					var/obj/item/weapon/reagent_containers/pill/pill = new /obj/item/weapon/reagent_containers/pill(T)
					pill.reagents.add_reagent(drug.id, pill.volume)
					pill.name = "happy pill"
					PB.handle_item_insertion(pill)
				holder.equip_to_storage_or_drop(PB)

/datum/perk/alcoholic
	name = "Alcoholic"
	icon_state = "beer" //https://game-icons.net/1x1/delapouite/beer-bottle.html
	desc = "For you it's alcohol: the cause of, and solution to, all of life's problems."

/datum/perk/alcoholic/assign(mob/living/carbon/human/H)
	..()
	var/ethanoltype = pick(subtypesof(/datum/reagent/ethanol))
	if(!(ethanoltype in holder.metabolism_effects.addiction_list))
		var/datum/reagent/alcohol = new ethanoltype
		holder.metabolism_effects.addiction_list.Add(alcohol)

/datum/perk/alcoholic_active
	name = "Alcoholic (active)"
	icon_state = "drinking" //https://game-icons.net/1x1/delapouite/drinking.html

/datum/perk/alcoholic_active/assign(mob/living/carbon/human/H)
	..()
	holder.stats.addTempStat(STAT_ROB, 10, INFINITY, "Fate Alcoholic")

/datum/perk/alcoholic_active/remove()
	holder.stats.addTempStat(STAT_ROB, "Fate Alcoholic")
	..()

/datum/perk/noble
	name = "Noble"
	icon_state = "family" //https://game-icons.net
	desc = "You're a noble, a graceful ornament to the civil order. The jewel of society. Waiting to be stolen."

/datum/perk/noble/assign(mob/living/carbon/human/H)
	..()
	if(!holder.last_name)
		qdel(src)
		return
	holder.sanity.environment_cap_coeff -= 1
	var/turf/T = get_turf(holder)
	var/obj/item/W = pickweight(list(
				/obj/item/weapon/tool/knife/ritual = 0.5,
				/obj/item/weapon/tool/sword = 0.2,
				/obj/item/weapon/tool/sword/katana = 0.2,
				/obj/item/weapon/tool/knife/dagger/ceremonial = 0.8,
				/obj/item/weapon/gun/projectile/revolver = 0.4))
	W = new W(T)
	W.name = "[holder.last_name] family [W.name]"
	var/oddities = rand(2,4)
	var/list/stats = ALL_STATS
	var/list/final_oddity = list()
	for(var/i = 0 to oddities)
		var/stat = pick(stats)
		stats.Remove(stat)
		final_oddity += stat
		final_oddity[stat] = rand(1,7)
	W.AddComponent(/datum/component/inspiration, final_oddity)
	W.AddComponent(/datum/component/atom_sanity, 1, "")
	spawn(1)
		holder.equip_to_storage_or_drop(W)

/datum/perk/noble/remove()
	holder.sanity.environment_cap_coeff += 1
	..()

/datum/perk/rat
	name = "Rat"
	desc = "Early bird gets the worm, but the second rat gets the cheese."
	icon_state = "rat" //https://game-icons.net/

/datum/perk/rat/assign(mob/living/carbon/human/H)
	..()
	holder.sanity.max_level -= 10

/datum/perk/rat/remove()
	holder.sanity.max_level += 10
	..()

/datum/perk/rejected_genius
	name = "Rejected Genius"
	desc = "Your dreams are undisturbed by reality, your search for the impossible continues regardless of your peers."
	icon_state = "knowledge" //https://game-icons.net/

/datum/perk/rejected_genius/assign(mob/living/carbon/human/H)
	..()
	holder.sanity.environment_cap_coeff -= 1
	holder.sanity.positive_prob_multiplier -= 1
	holder.sanity.insight_passive_gain_multiplier *= 1.5
	holder.sanity.max_level -= 20

/datum/perk/rejected_genius/remove()
	holder.sanity.environment_cap_coeff += 1
	holder.sanity.positive_prob_multiplier += 1
	holder.sanity.insight_passive_gain_multiplier /= 1.5
	holder.sanity.max_level += 20
	..()

/datum/perk/oborin_syndrome
	name = "Oborin Syndrome"
	icon_state = "prism" //https://game-icons.net/1x1/delapouite/prism.html
	desc = "You're often told you see the world in black and whites. But they're wrong, you see the greys, you live in the greys. Not the 'colors' though, those are just venus traps for the dumb flies, you're smarter than that. Only grey."

/datum/perk/oborin_syndrome/assign(mob/living/carbon/human/H)
	..()
	holder.sanity.max_level += 20
	holder.species.taste_sensitivity = TASTE_NUMB
	spawn(1)
		holder.update_client_colour() //Handle the activation of the colourblindness on the mob.

/datum/perk/oborin_syndrome/remove()
	holder.sanity.max_level -= 20
	holder.species.taste_sensitivity = TASTE_NORMAL
	..()

/datum/perk/lowborn
	name = "Lowborn"
	icon_state = "ladder" //https://game-icons.net/1x1/delapouite/hole-ladder.html
	desc = "For them you are a pariah, trash — untouchable! That’s the word! You are an Untouchable!"

/datum/perk/lowborn/assign(mob/living/carbon/human/H)
	..()
	holder.sanity.max_level += 10

/datum/perk/lowborn/remove()
	holder.sanity.max_level -= 10
	..()
