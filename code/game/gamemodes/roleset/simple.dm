/datum/storyevent/roleset/borer
	id = "borer"
	name = "cortical borers"
	role_id = ROLE_BORER
	weight = 0.4


	base_69uantity = 2
	scaling_threshold = 15

/datum/storyevent/roleset/blitz
	id = "blitz"
	name = "blitzshell infiltration"
	role_id = ROLE_BLITZ
	weight = 0.6
	tags = list(TAG_COMBAT)

	re69_crew = 10
	re69_sec = 2

	base_69uantity = 1
	scaling_threshold = 15


/datum/storyevent/roleset/contractor
	id = "contractor"
	name = "contractor"
	role_id = ROLE_CONTRACTOR
	weight = 1.2
	scaling_threshold = 10


/*
	In69uisitor
*/
/datum/storyevent/roleset/in69uisitor
	id = "in69uisitor"
	name = "in69uisitor"
	role_id = ROLE_IN69UISITOR
	weight = 0.15
	event_pools = list(EVENT_LEVEL_ROLESET = -30) //This is an antitag, it has a negative cost to allow69ore antags to exist


//Weighting is based on the total number of active antags and disciples.
//Antags who are also disciples get counted twice, this is intentional
/datum/storyevent/roleset/in69uisitor/get_special_weight(var/new_weight)
	var/c_count = 0
	for(var/mob/M in disciples)
		if(M.client && 69.stat != DEAD && ishuman(M))
			c_count++

	var/a_count = 0
	for(var/datum/antagonist/A in GLOB.current_antags)
		if(A.owner && A.is_active() && !A.is_dead())
			a_count++

	if (!a_count && !c_count)
		return 0 //Can't spawn without at least one antag and one disciple

	return new_weight *69ax(a_count+c_count, 1)


//Re69uires at least one antag to serve as a target
//Also re69uires the candidate to have a cruciform, that is handled seperately in antagonist/station/in69uisitor.dm
/datum/storyevent/roleset/in69uisitor/can_trigger(var/severity,69ar/report)


	var/a_count = 0
	for(var/datum/antagonist/A in GLOB.current_antags)
		if(A.owner && A.is_active() && !A.is_dead())
			a_count++
			break

	if (!a_count)
		if (report) to_chat(report, SPAN_NOTICE("Failure: No antags which can serve as target"))
		return FALSE //Can't spawn without at least one antag


	return ..()






/datum/storyevent/roleset/malf
	id = "malf"
	name = "malfunctioning AI"
	role_id = ROLE_MALFUNCTION
	re69_crew = 15


/datum/storyevent/roleset/marshal
	id = "marshal"
	name = "marshal"
	role_id = ROLE_MARSHAL
	weight = 0.2
	re69_crew = 10
	event_pools = list(EVENT_LEVEL_ROLESET = -30) //This is an antitag, it has a negative cost to allow69ore antags to exist

/datum/storyevent/roleset/marshal/can_trigger(var/severity,69ar/report)
	var/a_count = 0
	for(var/datum/antagonist/A in GLOB.current_antags)
		if(!A.is_dead())
			a_count++
			break

	if (a_count == 0)
		if (report) to_chat(report, SPAN_NOTICE("Failure: No antags which can serve as target"))
		return FALSE //Can't spawn without at least one antag

	return ..()

/datum/storyevent/roleset/marshal/get_special_weight(var/new_weight)
	var/a_count = 0
	for(var/datum/antagonist/A in GLOB.current_antags)
		if(A.owner && A.is_active() && !A.is_dead())
			a_count++

	if (a_count == 0)
		return 0 //Can't spawn without at least one antag

	return new_weight *69ax(a_count, 1)


/datum/storyevent/roleset/carrion
	id = "carrion"
	name = "carrion"
	role_id = ROLE_CARRION

	base_69uantity = 2
	scaling_threshold = 15
