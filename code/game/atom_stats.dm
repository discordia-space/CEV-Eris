/atom
	var/list/statverbs

/datum/statverb
	var/name
	var/reqired_stat = STAT_MEC
	var/base_range = RANGE_ADJACTENT	//maximum distance or RANGE_ADJACENT

/datum/statverb/action(mob/user, atom/target, distance)

/atom/examine()
	if(statverbs && staverbs.len)
		var/verb_text = "Apply: "
		for(var/dautm/statverb/SV in statverbs)
			vert_text += " <a href=''>[SV.required_stat]</a>"


