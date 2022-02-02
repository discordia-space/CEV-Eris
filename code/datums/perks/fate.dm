/datum/perk/fate/paper_worm
	name = "Paper Worm"
	desc = "You were a clerk and bureaucrat for all your life. Cramped offices with angry people is where your personality was forged. \
			Coffee is your blood, your mind is corporate slogans, and personal life is nonexistent. \
			And here you are, on a spaceship flying to hell. Yet, there is something more to you; when they fall into despair, you'll stand up and fight."
	icon_state = "paper"

/datum/perk/fate/paper_worm/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity.positive_prob += 40

/datum/perk/fate/paper_worm/remove()
	if(holder)
		holder.sanity.positive_prob -= 40
	..()

/datum/perk/fate/freelancer
	name = "Freelancer"
	icon_state = "freelancer"
	desc = "Whatever was your job, you never stayed in one place for too long or had lasting contracts. \
			This perk checks your highest stat, lowers it by 10 and improves all others by 4."

/datum/perk/fate/freelancer/assign(mob/living/carbon/human/H)
	..()
	var/maxstat = -INFINITY
	var/maxstatname
	spawn(1)
		for(var/name in ALL_STATS)
			if(holder.stats.getStat(name, TRUE) > maxstat)
				maxstat = holder.stats.getStat(name, TRUE)
				maxstatname = name
		for(var/name in ALL_STATS)
			if(name != maxstatname)
				holder.stats.changeStat(name, 4)
			else
				holder.stats.changeStat(name, -10)

/datum/perk/fate/nihilist
	name = "Nihilist"
	desc = 	"You simply ran out of fucks to give at some point in your life. \
			This perk increases chance of positive breakdowns by 10% and negative breakdowns by 20%. Seeing someone die has a random effect on you: \
			sometimes you won’t take any sanity loss and you can even gain back sanity, or get a boost to your cognition."
	icon_state = "nihilist" //https://game-icons.net/1x1/lorc/tear-tracks.html

/datum/perk/fate/nihilist/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity.positive_prob += 10
		holder.sanity.negative_prob += 20

/datum/perk/fate/nihilist/remove()
	if(holder)
		holder.sanity.positive_prob -= 10
		holder.sanity.negative_prob -= 20
		holder.stats.removeTempStat(STAT_COG, "Fate Nihilist")
	..()

/datum/perk/fate/moralist
	name = "Moralist"
	icon_state = "moralist" //https://game-icons.net/
	desc = "A day may come when the courage of men fails, when we forsake our friends and break all bonds of fellowship. \
			But it is not this day. This day you fight! \
			Carry this fire with you - light the way for others."

/datum/perk/fate/drug_addict
	name = "Drug Addict"
	icon_state = "addict" //https://game-icons.net/1x1/delapouite/medicines.html
	desc = "For reasons you cannot remember, you decided to resort to major drug use. You have lost the battle, and now you suffer the consequences. \
			You start with a permanent addiction to a random stimulator, as well as a bottle of pills containing the drug. \
			Beware, if you get addicted to another stim, you will not get rid of the addiction."

/datum/perk/fate/drug_addict/assign(mob/living/carbon/human/H)
	..()
	spawn(1)
		var/turf/T = get_turf(holder)
		var/drugtype = pick(subtypesof(/datum/reagent/stim))
		if(!(drugtype in holder.metabolism_effects.addiction_list))
			var/datum/reagent/drug = new drugtype
			holder.metabolism_effects.addiction_list.Add(drug)
			var/obj/item/storage/pill_bottle/PB = new /obj/item/storage/pill_bottle(T)
			PB.name = "[drug] (15 units)"
			for(var/i=1 to 12)
				var/obj/item/reagent_containers/pill/pill = new /obj/item/reagent_containers/pill(T)
				pill.reagents.add_reagent(drug.id, 15)
				pill.name = "[drug]"
				PB.handle_item_insertion(pill)
			holder.equip_to_storage_or_drop(PB)

/datum/perk/fate/alcoholic
	name = "Alcoholic"
	icon_state = "alcoholic" //https://game-icons.net/1x1/delapouite/beer-bottle.html
	desc = "You imagined the egress from all your trouble and pain at the bottom of the bottle, but the way only led to a labyrinth. \
			You never stopped from coming back to it, trying again and again, poisoning your mind until you lost control. Now your face bears witness to your self-destruction. \
			There is only one key to survival, and it is the liquid that has shown you the way down. \
			You have a permanent alcohol addiction, which gives you a boost to combat stats while under the influence and lowers your cognition permanently."

/datum/perk/fate/alcoholic/assign(mob/living/carbon/human/H)
	..()
	if(!(/datum/reagent/alcohol in holder.metabolism_effects.addiction_list))
		holder.metabolism_effects.addiction_list.Add(/datum/reagent/ethanol) //yes, it is called ethanol but is actually alcohol(alco metabolizes into etha in the stomach)

/datum/perk/fate/alcoholic_active
	name = "Alcoholic - active"
	icon_state = "alcoholic_active" //https://game-icons.net
	desc = "Combat stats increased."

/datum/perk/fate/alcoholic_active/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.stats.addTempStat(STAT_ROB, 15, INFINITY, "Fate Alcoholic")
		holder.stats.addTempStat(STAT_TGH, 15, INFINITY, "Fate Alcoholic")
		holder.stats.addTempStat(STAT_VIG, 15, INFINITY, "Fate Alcoholic")

/datum/perk/fate/alcoholic_active/remove()
	if(holder)
		holder.stats.removeTempStat(STAT_ROB, "Fate Alcoholic")
		holder.stats.removeTempStat(STAT_TGH, "Fate Alcoholic")
		holder.stats.removeTempStat(STAT_VIG, "Fate Alcoholic")
	..()

/datum/perk/fate/noble
	name = "Noble"
	icon_state = "noble" //https://game-icons.net
	desc = "You are a descendant of a long-lasting family, bearing a name of high status that can be traced back to the early civilization of your domain. \
			Start with an heirloom weapon, higher chance to be on contractor contracts and removed sanity cap. Stay clear of filth and danger."

/datum/perk/fate/noble/assign(mob/living/carbon/human/H)
	..()
	if(!holder)
		return
	holder.sanity.environment_cap_coeff -= 1
	if(!holder.last_name)
		holder.stats.removePerk(src.type)
		return
	var/turf/T = get_turf(holder)
	var/obj/item/W = pickweight(list(
				/obj/item/tool/knife/ritual = 0.5,
				/obj/item/tool/sword = 0.2,
				/obj/item/tool/sword/katana = 0.2,
				/obj/item/tool/knife/dagger/ceremonial = 0.8,
				/obj/item/gun/projectile/revolver = 0.4))
	holder.sanity.valid_inspirations += W
	W = new W(T)
	W.desc += " It has been inscribed with the \"[holder.last_name]\" family name."
	var/oddities = rand(2,4)
	var/list/stats = ALL_STATS
	var/list/final_oddity = list()
	for(var/i = 0 to oddities)
		var/stat = pick(stats)
		stats.Remove(stat)
		final_oddity += stat
		final_oddity[stat] = rand(1,7)
	W.AddComponent(/datum/component/inspiration, final_oddity, get_oddity_perk())
	W.AddComponent(/datum/component/atom_sanity, 1, "") //sanity gain by area
	W.sanity_damage -= 1 //damage by view
	spawn(1)
		holder.equip_to_storage_or_drop(W)

/datum/perk/fate/noble/remove()
	if(holder)
		holder.sanity.environment_cap_coeff += 1
	..()

/datum/perk/fate/rat
	name = "Rat"
	desc = "For all you know, taking what isn't yours is what you were best at. Be that information, items or life. It’s all the same to you. \
			You start with a +10 to Mechanical stat and -10 to Vigilance. You will have a -10 to overall sanity health, meaning you will incur a breakdown faster than most. \
			Additionally you have more quiet footsteps and a chance to not trigger traps on the ground. You also have further listening range, but flashbangs stun you for double the time."
	icon_state = "rat" //https://game-icons.net/

/datum/perk/fate/rat/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity.max_level -= 10

/datum/perk/fate/rat/remove()
	if(holder)
		holder.sanity.max_level += 10
	..()

/datum/perk/fate/rejected_genius
	name = "Rejected Genius"
	desc = "You see the world in different shapes and colors. \
			Your sanity loss cap is removed, so stay clear of corpses or filth. You have less maximum sanity and no chance to have positive breakdowns. \
			As tradeoff, you have 50% faster insight gain."
	icon_state = "genius" //https://game-icons.net/

/datum/perk/fate/rejected_genius/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity.environment_cap_coeff -= 1
		holder.sanity.positive_prob_multiplier -= 1
		holder.sanity.insight_passive_gain_multiplier *= 1.5
		holder.sanity.max_level -= 20

/datum/perk/fate/rejected_genius/remove()
	if(holder)
		holder.sanity.environment_cap_coeff += 1
		holder.sanity.positive_prob_multiplier += 1
		holder.sanity.insight_passive_gain_multiplier /= 1.5
		holder.sanity.max_level += 20
	..()

/datum/perk/fate/oborin_syndrome
	name = "Oborin Syndrome"
	icon_state = "oborin" //https://game-icons.net/1x1/delapouite/prism.html
	desc = "A condition manifested at some recent point in human history. \
			It’s origin and prevalence are unknown, but it is speculated to be a psionic phenomenom.\
			Your sanity pool is higher than that of others at the cost of the colors of the world."

/datum/perk/fate/oborin_syndrome/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity.max_level += 20
		spawn(1)
			holder.update_client_colour() //Handle the activation of the colourblindness on the mob.

/datum/perk/fate/oborin_syndrome/remove()
	if(holder)
		holder.sanity.max_level -= 20
	..()

/datum/perk/fate/lowborn
	name = "Lowborn"
	icon_state = "lowborn" //https://game-icons.net/1x1/delapouite/hole-ladder.html
	desc = "You are the bottom of society. The dirt and grime on the heel of a boot. You had one chance. You took it. \
			You cannot be a person of authority. Additionally, you have the ability to have a name without a last name and have an increased sanity pool."

/datum/perk/fate/lowborn/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity.max_level += 10

/datum/perk/fate/lowborn/remove()
	if(holder)
		holder.sanity.max_level -= 10
	..()
