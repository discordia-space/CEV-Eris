#define STAT_VALUE_DEFAULT 0

/datum/stats
	var/list/stats = list()

/datum/stats/proc/get_value(stat_name)
	if(stat_name in stats)
		return stats[stat_name]
	else
		return STAT_VALUE_DEFAULT
