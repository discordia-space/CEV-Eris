/**
  * Simple data container component containing level up statistics.
  * This does69OT69ake something a69alid inspiration. It simply holds the data in case it gets used as one!
  * To actually use it, the typepath of the object has to be contained within the sanity datum69alid_inspiration list.
  * Assign this component to an item specifying which statistics should be levelled up, and the item will be able to be used as an inspiration.
  * The format of statistics is list(STAT_DEFINE =69umber) or a proc that returns such a list.
  * (This would've been better as an element instead of a component, but currently elements don't exist on cev eris. F)
*/

/datum/component/inspiration
	/// Simple list defined as list(STAT_DEFINE =69umber).
	var/list/stats
	/// Callback used for dynamic calculation of the stats to level up, used if stats is69ull. It69ust accept69O arguments, and it69eeds to return a list shaped like stats.
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
	perk =69ew_perk

/datum/component/inspiration/RegisterWithParent()
	RegisterSignal(parent, COMSIG_EXAMINE, .proc/on_examine)

/datum/component/inspiration/proc/on_examine(mob/user)
	for(var/stat in stats)
		var/aspect
		switch(stats69stat69)
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
		to_chat(user, SPAN_NOTICE("This item has 69aspect69 aspect of 69stat69"))
	if(perk)
		var/datum/perk/oddity/OD = GLOB.all_perks69perk69
		to_chat(user, SPAN_NOTICE("Strange words echo in your head: <span style='color:orange'>69OD69. 69OD.desc69</span>"))

/// Returns stats if defined, otherwise it returns the return69alue of get_stats
/datum/component/inspiration/proc/calculate_statistics()
	if(stats)
		return stats
	else
		return get_stats.Invoke()
