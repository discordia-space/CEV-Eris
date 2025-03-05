/*
	The spider infestation event is distinct from the normal infestation, in that spiders are spawned
	in a distributed state, possibly anywhere on the ship. Anyone can potentially find a spiderling in
	their workplace, and it might grow up and attack at any time.

	This is much scarier than the normal infestation which spawns mobs in closed rooms. Here, they come to
	you.
*/
/datum/storyevent/spider_infestation
	id = "spider_infestation"
	name = "spider infestation"

	weight = 0.6

	event_type = /datum/event/spider_infestation
	event_pools = list(EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE*1.1)
	tags = list(TAG_COMBAT, TAG_NEGATIVE, TAG_SCARY, TAG_COMMUNAL)

////////////////////////////////////////////////////////////////////////////
/datum/event/spider_infestation
	announceWhen	= 0
	var/spawncount = 1


/datum/event/spider_infestation/setup()

	//Randomised start times.
	startWhen = rand(5,40)

	spawncount = rand(12,24)	//spiderlings only have a 50% chance to grow big and strong


/datum/event/spider_infestation/announce()
	command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')


/datum/event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
		if(!temp_vent.welded && temp_vent.network && isOnStationLevel(temp_vent))
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling(vent.loc)
		vents -= vent
		spawncount--
