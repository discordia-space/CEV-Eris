/datum/perk/iriski/freelancerplus
	name = "Freelancer Plus"
	icon_state = "skills"
	desc = "Whatever was your job, you never stayed in one place for too long or had lasting contracts. \
            And you're good at it! \
			This perk checks your highest stat, lowers it by 8 and improves all others by 5."
	conflicting_perks_types = list(/datum/perk/fate/freelancer)
	var/maxstat = -INFINITY
	var/maxstatname

/datum/perk/iriski/freelancerplus/assign(mob/living/carbon/human/H)
	if(!..())
		return
	spawn(1)
		if(!istype(holder))
			return
		for(var/name in ALL_STATS)
			if(holder.stats.getStat(name, TRUE) > maxstat)
				maxstat = holder.stats.getStat(name, TRUE)
				maxstatname = name
		for(var/name in ALL_STATS)
			if(name != maxstatname)
				holder.stats.changeStat(name, 5)
			else
				holder.stats.changeStat(name, -8)

/datum/perk/iriski/freelancerplus/remove()
	for(var/name in ALL_STATS)
		if(name != maxstatname)
			holder.stats.changeStat(name, -5)
		else
			holder.stats.changeStat(name, 8)
	return ..()
