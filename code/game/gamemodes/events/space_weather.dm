/datum/storyevent/bluespace_storm
	id = "bluespace storm"
	name = "Bluespace storm"
	weight = 0.8
	event_type = /datum/event/bluespace_storm
	parallel = FALSE
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE, EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)
	tags = list(TAG_SCARY, TAG_NEGATIVE)

/datum/event/bluespace_storm
	startWhen = 1
	announceWhen = 5
	endWhen = 350 //these 350 are failsafes in case setup() SOMEHOW fucks up

/datum/event/bluespace_storm/setup()
	endWhen = rand(300, 600)

/datum/event/bluespace_storm/announce()
	command_announcement.Announce("The scanners have detected a bluespace storm near the ship. Bluespace distortions are likely to happen while it lasts.", "Bluespace Storm")

/datum/event/bluespace_storm/end()
	command_announcement.Announce("The bluespace storm has ended.", "Bluespace Storm")

/datum/event/bluespace_storm/tick()
	if(prob(2))
		var/area/A = random_ship_area(filter_maintenance = TRUE, filter_critical = TRUE)
		bluespace_distorsion(A.random_space())

/datum/storyevent/ion_blizzard
	id = "ion blizzard"
	name = "Ion blizzard"
	weight = 0.9
	event_type = /datum/event/ion_blizzard
	parallel = FALSE
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE, EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)
	tags = list(TAG_SCARY, TAG_NEGATIVE)

/datum/event/ion_blizzard
	startWhen = 1
	announceWhen = 1
	endWhen = 350

/datum/event/ion_blizzard/setup()
	endWhen = rand(300, 600)

/datum/event/ion_blizzard/announce()
	command_announcement.Announce("A severe ion storm has been detected near the ship. Lighting subsystems are currently overloaded and may not work properly.", "Ion Blizzard")

/datum/event/ion_blizzard/end()
	command_announcement.Announce("The ion blizzard has ended.", "Ion Blizzard")

/datum/event/ion_blizzard/tick()
	if(prob(2)) //don't check every single light every single tick jesus christ
		for(var/obj/machinery/light/L in random_ship_area())
			L.broken()
			return
	else if(prob(80))
		for(var/obj/machinery/light/L in random_ship_area())
			L.flick_light(rand(2,5))
			return

/datum/storyevent/photon_vortex
	id = "photon vortex"
	name = "Photon vortex"
	weight = 0.9
	event_type = /datum/event/photon_vortex
	parallel = FALSE
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE, EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)
	tags = list(TAG_SCARY, TAG_NEGATIVE)

/datum/event/photon_vortex
	startWhen = 2
	announceWhen = 1
	endWhen = 350

/datum/event/photon_vortex/setup()
	endWhen = rand(300, 600)

/datum/event/photon_vortex/start()
	for(var/obj/item/device/lighting/L in world)
		L.brightness_on = L.brightness_on / 3
		L.update_icon()
	for(var/obj/machinery/light/l in world)
		l.brightness_range = l.brightness_range / 3
		l.brightness_power = l.brightness_power / 2
		l.update()

/datum/event/photon_vortex/announce()
	command_announcement.Announce("A photon vortex anomaly has been detected near the ship. All photon-emitting machinery gives much less light.", "Photon Vortex Anomaly")

/datum/event/photon_vortex/end()
	command_announcement.Announce("The photon vortex anomaly has moved away from the ship.", "Photon Vortex Anomaly")

	for(var/obj/item/device/lighting/L in world)
		L.brightness_on = initial(L.brightness_on)
		L.update_icon()
	for(var/obj/machinery/light/l in world)
		l.brightness_range = initial(l.brightness_range)
		l.brightness_power = initial(l.brightness_power)
		l.update()

/datum/storyevent/harmonic_feedback
	id = "harmonic feedback surge"
	name = "Harmonic feedback surge anomaly"
	weight = 0.5
	event_type = /datum/event/harmonic_feedback
	parallel = FALSE
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE, EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)
	tags = list(TAG_DESTRUCTIVE, TAG_NEGATIVE)

/datum/event/harmonic_feedback
	startWhen = 5
	announceWhen = 1
	endWhen = 350

/datum/event/harmonic_feedback/setup()
	endWhen = rand(300, 450)

/datum/event/harmonic_feedback/announce()
	command_announcement.Announce("The ship is currently passing through intense gravitational wavefronts. They will heavily disrupt hull shields for a short duration.", "Harmonic Feedback Surge Anomaly")

/datum/event/harmonic_feedback/end()
	command_announcement.Announce("The gravitational wavefronts have passed.", "Harmonic Feedback Surge Anomaly")

/datum/event/harmonic_feedback/tick() //around two seconds
	for(var/obj/machinery/power/shield_generator/G in world)
		G.take_damage(10, SHIELD_DAMTYPE_EM)

/datum/storyevent/micro_debris
	id = "micro debris"
	name = "micro debris field"
	weight = 0.9
	event_type =/datum/event/dust
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE, EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)
	tags = list(TAG_DESTRUCTIVE, TAG_NEGATIVE)

/datum/event/micro_debris
	startWhen	= 2
	announceWhen = 1
	endWhen		= 60
	var/list/debris_types = list(
		/obj/effect/meteor/dust/glass=40,\
		/obj/effect/meteor/dust/rods=30,\
		/obj/effect/meteor/dust/metal=20,\
		/obj/effect/meteor/dust/ice=10
	)

/datum/event/micro_debris/announce()
	command_announcement.Announce("The ship is now passing through a micro debris field.", "Micro Debris Field Alert")

/datum/event/micro_debris/end()
	command_announcement.Announce("The ship has now passed through the micro debris field.", "Micro Debris Field Notice")

/datum/event/micro_debris/tick()
//i have no idea
	if(prob(60))
		var/debris = pickweight(debris_types)
		var/start_side = pick(EAST, NORTH, WEST, SOUTH)
		var/amount = rand(1,3)
		var/target_zlevel = pick(GLOB.maps_data.station_levels)
		for(var/i in 0 to amount)
			spawn_debris(debris, start_side, target_zlevel)
			return

/proc/spawn_debris(var/obj/effect/meteor/dust/debris, var/start_side, var/zlevel)
	var/turf/start_turf = spaceDebrisStartLoc(start_side, zlevel)
	var/turf/destination = spaceDebrisFinishLoc(start_side, zlevel)
	var/obj/effect/meteor/M = new debris(start_turf)
	M.dest = destination
	spawn(0)
		walk_towards(M, M.dest, 1)
	return
