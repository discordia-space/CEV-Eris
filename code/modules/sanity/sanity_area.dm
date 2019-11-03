/area
	var/datum/area_sanity/sanity

/datum/area_sanity
	var/area/owner
	var/affect_raw = 0
	var/affect = 0
	var/list/positive_flavors = new
	var/list/negative_flavors = new

/datum/area_sanity/New(area/A)
	owner = A
	..()

/datum/area_sanity/proc/update()
	var/leng = 0
	for(var/turf/T in owner.contents)
		++leng
	affect = affect_raw / leng

/datum/area_sanity/proc/register(datum/component/atom_sanity/AS)
	affect_raw += AS.affect
	var/list/flavors
	if(AS.affect < 0)
		flavors = negative_flavors
	else
		flavors = positive_flavors
	if(AS.desc in flavors)
		flavors[AS.desc] += 1
	else
		flavors[AS.desc] = 1
	update()

/datum/area_sanity/proc/unregister(datum/component/atom_sanity/AS)
	affect_raw -= AS.affect
	var/list/flavors
	if(AS.affect < 0)
		flavors = negative_flavors
	else
		flavors = positive_flavors
	if(flavors[AS.desc] == 1)
		flavors -= AS.desc
	else
		flavors[AS.desc] -= 1
	update()


