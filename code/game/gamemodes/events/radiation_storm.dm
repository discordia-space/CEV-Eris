/*
	Radiation storm is a really severe event that forces everyone to flee into maintenance or a similar
	shielded area. Anyone caught outside a shielded area will recieve lethal doses of radiation,
	and will die without medical attention
*/
/datum/storyevent/radiation_storm
	id = "radiation_storm"
	name = "radiation_storm"


	event_type = /datum/event/radiation_storm
	event_pools = list(EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)

	tags = list(TAG_SCARY, TAG_COMMUNAL)



/datum/event/radiation_storm
	var/const/enterBelt		= 55
	var/const/radIntervall 	= 5
	var/const/leaveBelt		= 165
	var/const/revokeAccess	= 220
	startWhen				= 2
	announceWhen			= 1
	endWhen					= revokeAccess
	var/postStartTicks 		= 0
	//two_part = 1
	//ic_name = "radiation"

/datum/event/radiation_storm/announce()
	command_announcement.Announce("High levels of radiation detected near the station. Please evacuate into one of the shielded maintenance tunnels.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')

/datum/event/radiation_storm/start()
	make_maint_all_access()
	SSweather.run_weather(/datum/weather/rad_storm)

/datum/event/radiation_storm/tick()
	if(activeFor == enterBelt)
		command_announcement.Announce("The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt.", "Anomaly Alert")
		radiate()

	if(activeFor >= enterBelt && activeFor <= leaveBelt)
		postStartTicks++

	if(postStartTicks == radIntervall)
		postStartTicks = 0
		radiate()

	else if(activeFor == leaveBelt)
		command_announcement.Announce("The station has passed the radiation belt. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all access again shortly.", "Anomaly Alert")

/datum/event/radiation_storm/proc/radiate()
	for(var/mob/living/carbon/C in GLOB.living_mob_list)
		var/area/A = get_area(C)
		if(!A)
			continue
		if(!(A.z in maps_data.station_levels))
			continue
		if(A.flags & AREA_FLAG_RAD_SHIELDED)
			continue

		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			H.apply_effect((rand(15,30)),IRRADIATE)
			if(prob(4))
				H.apply_effect((rand(20,60)),IRRADIATE)
				if (prob(max(0, 100 - H.getarmor(null, ARMOR_RAD))))
					if (prob(75))
						randmutb(H) // Applies bad mutation
					else
						randmutg(H) // Applies good mutation
					domutcheck(H,null,MUTCHK_FORCED)

/datum/event/radiation_storm/end()
	revoke_maint_all_access()

/datum/event/radiation_storm/syndicate/radiate()
	return