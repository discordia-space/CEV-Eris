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
		var/a_or_an = "a"
		var/aspect_noun_or_adjective = "noun"
		var/stat_color
		var/list/nouns_overwhelming = list("overwhelming", "extreme", "incredible", "unbelieavable", "exceeding")
		var/list/adjectives_overwhelming = list("overwhelmingly", "extremely", "incredibly", "unbelievably", "exceedingly")
		var/list/nouns_strong = list("strong", "heavy", "powerful", "unusual")
		var/list/adjectives_strong = list("strongly", "heavily", "highly", "naggingly", "unusually")
		var/list/nouns_medium = list("medium", "moderate", "unremarkable")
		var/list/adjectives_medium = list("moderately", "relatively", "considerably", "somewhat")
		var/list/nouns_weak = list("weak", "slight", "mild", "light", "subtle")
		var/list/adjectives_weak = list("weakly", "slightly", "mildly", "lightly", "subtly")
		if(prob(75))
			aspect_noun_or_adjective = "adjective"		
		switch(stat)
			if("Robustness")
				stat_noun = pick("robustness", "strength", "brawls", "fighting")
				stat_adjective = pick("robust", "strong")
			if("Toughness")
				stat_noun = pick("toughness", "resilience", "endurance")
				stat_adjective = pick("tough", "resilient", "endurant", "stoic")
			if("Vigilance")
				stat_noun = pick("vigilance", "watchfulness", "awareness")
				stat_adjective = pick("vigilant", "watchful", "aware", "wary")
			if("Mechanical")
				stat_noun = pick("mechanical", "tools", "crafting", "machinery", "mechanical restoration")
				stat_adjective = pick("mechanically inclined", "accustomed to machinery", "proficient at mending machinery", "proficient at servicing machinery", "capable of restoring gadgets")
			if("Biology")
				stat_noun = pick("biology", "medicine", "medical knowledge", "anatomy", "physiology")
				stat_adjective = pick("skilled at surgery", "accustomed to anatomy", "knowledgeable in physiology")				
			if("Cognition")
				stat_noun = pick("cognition", "intelligence", "knowledge")
				stat_adjective = pick("smart", "intelligent", "concentrated", "knowledgable")		
		switch(stats[stat])
			if(10 to INFINITY)
				a_or_an = "an"
				stat_color = "<span style='color:#d0b050;'>"
				if(aspect_noun_or_adjective == "noun")
					aspect = pick(nouns_overwhelming)
				else
					aspect = pick(adjectives_overwhelming)
			if(6 to 10)
				stat_color = "<span class='red'>"
				if(aspect_noun_or_adjective == "noun")
					aspect = pick(nouns_strong)
				else
					aspect = pick(adjectives_strong)
			if(3 to 6)
				stat_color = "<span class='green'>"
				if(aspect_noun_or_adjective == "noun")
					aspect = pick(nouns_medium)
				else
					aspect = pick(adjectives_medium)
			if(1 to 3)
				stat_color = "<span class='blue'>"
				if(aspect_noun_or_adjective == "noun")
					aspect = pick(nouns_weak)
				else
					aspect = pick(adjectives_weak)
			else
				continue
		if(aspect_noun_or_adjective == "noun")
			message = pick("This item has [a_or_an] [stat_color][aspect]</span> aspect of [stat_noun]", "[a_or_an] [stat_color][aspect]</span> Aura of [stat_noun] pertains to it")
		else if(aspect_noun_or_adjective == "adjective")
			message = pick("It feels [stat_color][aspect]</span> like [stat_noun]", "It [stat_color][aspect]</span> smells of [stat_noun]", "It [stat_color][aspect]</span> reminds you of [stat_noun]", "It makes you feel [stat_color][aspect]</span> [stat_adjective]", "This feels like it might make you [stat_color][aspect]</span> [stat_adjective]", "[stat_color][aspect]</span> [stat_adjective].")			
		if(message)
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
