/area
	var/datum/area_sanity/sanity

/datum/area_sanity
	var/affect = 0
	var/list/positive_flavors
	var/list/negative_flavors


/datum/area_sanity/proc/register(datum/component/atom_sanity/AS)
	affect += AS.affect
	var/list/flavors
	if(AS.affect < 0)
		flavors = negative_flavors
	else
		flavors = positive_flavors
	if(AS.desc in flavors)
		flavors[AS.desc] += 1
	else
		flavors[AS.desc] = 1

/datum/area_sanity/proc/unregister(datum/component/atom_sanity/AS)
	affect -= AS.affect
	var/list/flavors
	if(AS.affect < 0)
		flavors = negative_flavors
	else
		flavors = positive_flavors
	if(flavors[AS.desc] == 1)
		flavors -= AS.desc
	else
		flavors[AS.desc] -= 1


