/**
  * Simple data container component containing level up statistics.
  * This does NOT make something a valid inspiration. It simply holds the data in case it gets used as one!
  * To actually use it, the typepath of the object has to be contained within the sanity datum valid_inspiration list.
  * Assign this component to an item specifying which statistics should be levelled up, and the item will be able to be used as an inspiration.
  * The format of statistics is list(STAT_DEFINE = number) or a proc that returns such a list.
  * (This would've been better as an element instead of a component, but currently elements don't exist on cev eris. F)
*/

/datum/component/inspiration
	/// Simple list defined as list(STAT_DEFINE = number).
	var/list/stats
	/// Callback used for dynamic calculation of the stats to level up, used if stats is null. It must accept NO arguments, and it needs to return a list shaped like stats.
	var/datum/callback/get_stats
	//perk
	var/datum/perk/perk

/// Statistics can be a list (static) or a callback to a proc that returns a list (of the same format)
/datum/component/inspiration/Initialize(statistics, datum/perk/new_perk)
	if(!istype(parent, /obj/item))
		return COMPONENT_INCOMPATIBLE
	if(islist(statistics))
		stats = statistics
	else if(istype(statistics, /datum/callback))
		get_stats = statistics
	else
		return COMPONENT_INCOMPATIBLE
	perk = new_perk

/datum/component/inspiration/RegisterWithParent()
	RegisterSignal(parent, COMSIG_EXAMINE, .proc/on_examine)

/datum/component/inspiration/proc/on_examine(mob/user)
	for(var/stat in stats)
		var/aspect
		var/stat_noun
		var/stat_adjective
		var/message
		var/list/nouns_overwhelming = list("<span style='color:#d0b050;'>overwhelming</span>", "<span style='color:#d0b050;'>extreme</span>", "<span style='color:#d0b050;'>incredible</span>", "<span style='color:#d0b050;'>unbelieavable</span>", "<span style='color:#d0b050;'>exceeding</span>")
		var/list/adjectives_overwhelming = list("<span style='color:#d0b050;'>overwhelmingly</span>", "<span style='color:#d0b050;'>extremely</span>", "<span style='color:#d0b050;'>incredibly</span>", "<span style='color:#d0b050;'>unbelievably</span>", "<span style='color:#d0b050;'>exceedingly</span>")
		var/list/nouns_strong = list("<span class='red'>strong</span>", "<span class='red'>heavy</span>", "<span class='red'>powerful</span>", "<span class='red'>nagging</span>")
		var/list/adjectives_strong = list("<span class='red'>strongly</span>", "<span class='red'>heavily</span>", "<span class='red'>highly</span>", "<span class='red'>naggingly</span>")
		var/list/nouns_medium = list("<span class='green'>medium</span>", "<span class='green'>moderate</span>", "<span class='green'>unremarkable</span>")
		var/list/adjectives_medium = list("<span class='green'>moderately</span>", "<span class='green'>relatively</span>", "<span class='green'>considerably</span>", "<span class='green'>somewhat</span>")
		var/list/nouns_weak = list("<span class='blue'>weak</span>", "<span class='blue'>slight</span>", "<span class='blue'>mild</span>", "<span class='blue'>light</span>", "<span class='blue'>subtle</span>"")
		var/list/adjectives_weak = list("<span class='blue'>weakly</span>", "<span class='blue'>slightly</span>", "<span class='blue'>mildly</span>", "<span class='blue'>lightly</span>", "<span class='blue'>subtly</span>")
		var/a_or_an = "a"
		switch(stats[stat])
			if("robustness")
				stat_noun = pick("robustness", "strength", "brawls", "fighting")
				stat_adjective = pick("robust", "strong")
			if("toughness")
				stat_noun = pick("toughness", "resilience", "endurance")
				stat_adjective = pick("tough", "resilient", "endurant", "stoic")
			if("vigilance")
				stat_noun = pick("vigilance", "watchfulness", "awareness")
				stat_adjective = pick("vigilant", "watchful", "aware", "wary")
			if("mechanical")
				stat_noun = pick("mechanical", "tools", "crafting", "machinery", )
				stat_adjective = pick("mechanics-affine", "skilled in reparation")
			if("biology")
				stat_noun = pick("biology", "medicine", "medical knowledge", "anatomy")
				stat_adjective = pick("skilled in surgery", "used to anatomy")				
			if("cognition")
				stat_noun = pick("cognition", "intelligence", "thinking", "knowledge", "observation")
				stat_adjective = pick("smart", "intelligent", "concentrated")		
		if(prob(50))
			switch(stats[stat])
				if(10 to INFINITY)
					a_or_an = "an"
					aspect = pick(nouns_overwhelming)
				if(6 to 10)
					aspect = pick(nouns_strong)
				if(3 to 6)
					aspect = pick(nouns_medium)
				if(1 to 3)
					aspect = pick(nouns_weak)
				else
					continue
			message = pick("This item has [a_or_an] [aspect] aspect of [stat_noun]", "[a_or_an] [aspect] Aura of [stat_noun] pertains to it")
		else
			switch(stats[stat])
				if(10 to INFINITY)
					aspect = pick(verbs_overwhelming)
				if(6 to 10)
					aspect = pick(verbs_strong)
				if(3 to 6)
					aspect = pick(verbs_medium)
				if(1 to 3)
					aspect = pick(verbs_weak)
				else
					continue
			message = pick("It feels [aspect] [stat_noun]", "It [aspect] smells of [stat_noun]", "It reminds you of [stat_noun] [aspect]", "It makes you feel [aspect] [stat_adjective]")	
/*		switch(stats[stat])
			if(10 to INFINITY)
				aspect = "an <span style='color:#d0b050;'>overwhelming</span>"
			if(6 to 10)
				aspect = "a <span class='red'>strong</span>"
			if(3 to 6)
				aspect = "a <span class='green'>medium</span>"
			if(1 to 3)
				aspect = "a <span class='blue'>weak</span>"
			else
				continue			
		"[a_or_an] [aspect] Aura of [stat] pertains to it"
		"It feels [aspect] [stat]"
		"It [aspect] smells of [stat]"
		"It reminds you of [stat] [aspect]"
		"It makes you feel [aspect] [stat]"
		"This item has [a_or_an] [aspect] aspect of [stat]"
*/
		to_chat(user, SPAN_NOTICE("This item has [aspect] aspect of [stat]"))
		to_chat(user, SPAN_NOTICE(message))
	if(perk)
		var/datum/perk/oddity/OD = GLOB.all_perks[perk]
		to_chat(user, SPAN_NOTICE("Strange words echo in your head: <span style='color:orange'>[OD]. [OD.desc]</span>"))

/// Returns stats if defined, otherwise it returns the return value of get_stats
/datum/component/inspiration/proc/calculate_statistics()
	if(stats)
		return stats
	else
		return get_stats.Invoke()
