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
	RegisterSignal(parent, COMSIG_EXTRA_EXAMINE, PROC_REF(on_examine))

/datum/component/inspiration/proc/on_examine(mob/user ,list/reference)
	SIGNAL_HANDLER
	for(var/stat in stats)
		var/aspect
		switch(stats[stat])
			if(10 to INFINITY)
				aspect = "an <span style='color:#d0b050;'>overwhelming</span>"
			if(6 to 10)
				aspect = "a <span class='green'>strong</span>"
			if(3 to 6)
				aspect = "a <span class='yellow'>medium</span>"
			if(1 to 3)
				aspect = "a <span class='red'>weak</span>"
			else
				continue
		reference.Add(SPAN_NOTICE("This item has [aspect] aspect of [stat]"))
	if(perk)
		var/datum/perk/oddity/OD = GLOB.all_perks[perk]
		reference.Add(SPAN_NOTICE("Strange words echo in your head: <span style='color:orange'>[OD]. [OD.desc]</span>"))

/// Returns stats if defined, otherwise it returns the return value of get_stats
/datum/component/inspiration/proc/calculate_statistics()
	if(stats)
		return stats
	else
		return get_stats.Invoke()
