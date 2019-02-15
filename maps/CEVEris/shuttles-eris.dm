//Some helpers because so much copypasta for pods
/datum/shuttle/autodock/ferry/escape_pod/erispod
	category = /datum/shuttle/autodock/ferry/escape_pod/erispod
//	sound_takeoff = 'sound/effects/rocket.ogg'
//	sound_landing = 'sound/effects/rocket_backwards.ogg'
	var/number

/datum/shuttle/autodock/ferry/escape_pod/erispod/New()
	name = "Escape Pod [number]"
	default_docking_controller = "escape_pod_[number]"
	controller_master = "escape_pod_[number]_controller"
	//Todo: The controllers inside escape pods need to be swapped to the correct type of controller
	//One which has escape pod programs instead of normal docking programs
	dock_target = "escape_pod_[number]_berth"
	waypoint_station = "escape_pod_[number]_start"
	landmark_transition = "escape_pod_[number]_internim"
	waypoint_offsite = "escape_pod_[number]_out"
	..()

/obj/effect/shuttle_landmark/escape_pod/
	var/number

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"

/obj/effect/shuttle_landmark/escape_pod/start/New()
	landmark_tag = "escape_pod_[number]_start"
	dock_target = "escape_pod_[number]_berth"
	..()

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"

/obj/effect/shuttle_landmark/escape_pod/transit/New()
	landmark_tag = "escape_pod_[number]_internim"
	..()

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"

/obj/effect/shuttle_landmark/escape_pod/out/New()
	landmark_tag = "escape_pod_[number]_out"
	dock_target = "escape_pod_[number]_recovery"
	..()


//Pods

/datum/shuttle/autodock/ferry/escape_pod/erispod/escape_pod1
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod1/station
	number = 1
/obj/effect/shuttle_landmark/escape_pod/start/pod1
	number = 1
/obj/effect/shuttle_landmark/escape_pod/out/pod1
	number = 1
/obj/effect/shuttle_landmark/escape_pod/transit/pod1
	number = 1

/datum/shuttle/autodock/ferry/escape_pod/erispod/escape_pod2
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod2/station
	number = 2
/obj/effect/shuttle_landmark/escape_pod/start/pod2
	number = 2
/obj/effect/shuttle_landmark/escape_pod/out/pod2
	number = 2
/obj/effect/shuttle_landmark/escape_pod/transit/pod2
	number = 2


/datum/shuttle/autodock/overmap/exploration_shuttle
	name = "Vasiliy Dokuchaev"
	move_time = 50
	shuttle_area = /area/shuttle/research/station
	default_docking_controller = "vasiliy_dokuchaev_shuttle"
	current_location = "nav_dock_expl"
	landmark_transition = "nav_transit_expl"
	range = 4
	fuel_consumption = 3

/obj/effect/shuttle_landmark/eris/dock/exploration_shuttle
	name = "Vasiliy Dokuchaev Dock"
	landmark_tag = "nav_dock_expl"
	dock_target = "research_dock_airlock"
	docking_controller = "vasiliy_dokuchaev_shuttle"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/eris/transit/exploration_shuttle
	name = "In transit"
	landmark_tag = "nav_transit_expl"
	base_turf = /turf/space




/datum/shuttle/autodock/overmap/hulk
	name = "Hulk"
	move_time = 60
	shuttle_area = /area/shuttle/mining/station
	default_docking_controller = "hulk_shuttle"
	current_location = "nav_dock_hulk"
	landmark_transition = "nav_transit_hulk"
	range = 2
	fuel_consumption = 4

/obj/effect/shuttle_landmark/eris/dock/hulk
	name = "Hulk Dock"
	landmark_tag = "nav_dock_hulk"
	dock_target = "mining_dock_airlock"
	docking_controller = "hulk_shuttle"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/eris/transit/hulk
	name = "In transit"
	landmark_tag = "nav_transit_hulk"
	base_turf = /turf/space

//Skipjack
//antag Shuttles disabled by nanako, 2018-09-15
//These shuttles are created with a subtypesof loop at runtime. Starting points for the skipjack and merc shuttle are not currentl mapped in
/*
/datum/shuttle/autodock/multi/antag/skipjack
	name = "Skipjack"
	warmup_time = 0
	destination_tags = list(
		"nav_skipjack_northwest",
		"nav_skipjack_southeast",
//		"nav_skipjack_dock",
		"nav_skipjack_start",
		)
	shuttle_area =  /area/skipjack_station/start
	dock_target = "skipjack_shuttle"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_transition"
	announcer = "CEV Eris Sensor Array"
	home_waypoint = "nav_skipjack_start"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."
*/
/obj/effect/shuttle_landmark/skipjack/start
	name = "Raider Outpost"
	icon_state = "shuttle-red"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "skipjack_base"

/obj/effect/shuttle_landmark/skipjack/internim
	name = "In transit"
	icon_state = "shuttle-red"
	landmark_tag = "nav_skipjack_transition"
/*
/obj/effect/shuttle_landmark/skipjack/dock
	name = "Docking Port"
	icon_state = "shuttle-red"
	landmark_tag = "nav_skipjack_dock"
	docking_controller = "skipjack_shuttle_dock_airlock"
*/
/obj/effect/shuttle_landmark/skipjack/northwest
	name = "Northwest of the Vessel"
	icon_state = "shuttle-red"
	landmark_tag = "nav_skipjack_northwest"

/obj/effect/shuttle_landmark/skipjack/southeast
	name = "Southeast of the Vessel"
	icon_state = "shuttle-red"
	landmark_tag = "nav_skipjack_southeast"


//Merc

/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	warmup_time = 0
	cloaked = 0
	destination_tags = list(
		"nav_merc_northeast",
		"nav_merc_southwest",
		"nav_merc_dock",
		"nav_merc_start",
		)
	shuttle_area = /area/shuttle/mercenary
	default_docking_controller = "merc_shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_transition"
	announcer = "CEV Eris Sensor Array"
	home_waypoint = "nav_merc_start"
	arrival_message = "Attention, unidentified vessel detected on long range sensors. \nVessel is approaching on an intercept course. \nHailing frequencies open."
	departure_message = "Attention, unknown vessel has departed"

//This fires, and the mission timer starts ticking, as soon as they leave Eris on course to the mercenary base
/datum/shuttle/autodock/multi/antag/mercenary/announce_departure()
	.=..()
	var/datum/faction/F = get_faction_by_id(FACTION_SERBS)
	var/datum/objective/timed/merc/MO = (locate(/datum/objective/timed/merc) in F.objectives)
	if (MO)
		MO.end_mission()

//This fires, and the mission timer starts ticking, as soon as they leave base
/datum/shuttle/autodock/multi/antag/mercenary/announce_arrival()
	.=..()
	var/datum/faction/F = get_faction_by_id(FACTION_SERBS)
	var/datum/objective/timed/merc/MO = (locate(/datum/objective/timed/merc) in F.objectives)
	if (MO)
		MO.start_mission()

//Docking controller chooses which of our airlocks should open onto the target location.
//Merc ship has only one airlock, so set that here
/obj/effect/shuttle_landmark/merc
	docking_controller = "merc_shuttle"

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_start"
	dock_target = "merc_base"

/obj/effect/shuttle_landmark/merc/internim
	name = "In transit"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_transition"

/obj/effect/shuttle_landmark/merc/dock
	name = "Docking Port"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_dock"
	dock_target = "second_sec_1_access_console"

/obj/effect/shuttle_landmark/merc/northeast
	name = "Northeast of the Vessel"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_northeast"

/obj/effect/shuttle_landmark/merc/southwest
	name = "Southwest of the Vessel"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_southwest"


//Cargo shuttle

/datum/shuttle/autodock/ferry/supply/drone
	name = "Supply Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_vessel"
	default_docking_controller = "supply_shuttle"

/obj/effect/shuttle_landmark/supply/centcom
	name = "Centcom"
	landmark_tag = "nav_cargo_start"

/obj/effect/shuttle_landmark/supply/station
	name = "Dock"
	landmark_tag = "nav_cargo_vessel"
	dock_target = "cargo_bay"