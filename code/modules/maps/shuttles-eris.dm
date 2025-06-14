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

/obj/effect/shuttle_landmark/escape_pod
	is_valid_destination = FALSE
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
	range = INFINITY  // Can go anywhere on overmap to avoidance depending on the jobs with bridge access to direct the ship
	fuel_consumption = 3
	can_do_exploration = TRUE

/obj/effect/shuttle_landmark/eris/dock/exploration_shuttle
	name = "Vasiliy Dokuchaev Dock"
	landmark_tag = "nav_dock_expl"
	dock_target = "research_dock_airlock"
	docking_controller = "vasiliy_dokuchaev_shuttle"
	base_turf = /turf/space
	shuttle_restricted = "Vasiliy Dokuchaev"

/obj/effect/shuttle_landmark/eris/transit/exploration_shuttle
	name = "In transit"
	landmark_tag = "nav_transit_expl"
	base_turf = /turf/space
	shuttle_restricted = "Vasiliy Dokuchaev"
	is_valid_destination = FALSE


/datum/shuttle/autodock/overmap/hulk
	name = "Hulk"
	move_time = 60
	shuttle_area = /area/shuttle/mining/station
	default_docking_controller = "hulk_shuttle"
	current_location = "nav_dock_hulk"
	landmark_transition = "nav_transit_hulk"
	range = INFINITY  // Can go anywhere on overmap to avoidance depending on the jobs with bridge access to direct the ship
	fuel_consumption = 4
	can_do_exploration = TRUE

/obj/effect/shuttle_landmark/eris/dock/hulk
	name = "Hulk Dock"
	landmark_tag = "nav_dock_hulk"
	dock_target = "mining_dock_airlock"
	docking_controller = "hulk_shuttle"
	base_turf = /turf/space
	shuttle_restricted = "Hulk"

/obj/effect/shuttle_landmark/eris/transit/hulk
	name = "In transit"
	landmark_tag = "nav_transit_hulk"
	base_turf = /turf/space
	is_valid_destination = FALSE


/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	warmup_time = 0
	move_time = 180
	cloaked = 0
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
	if(MO)
		MO.end_mission()

//This fires, and the mission timer starts ticking, as soon as they leave base
/datum/shuttle/autodock/multi/antag/mercenary/announce_arrival()
	.=..()
	var/datum/faction/F = get_faction_by_id(FACTION_SERBS)
	var/datum/objective/timed/merc/MO = (locate(/datum/objective/timed/merc) in F.objectives)
	if(MO)
		MO.start_mission()

//Docking controller chooses which of our airlocks should open onto the target location.
//Merc ship has only one airlock, so set that here
/obj/effect/shuttle_landmark/merc
	docking_controller = "merc_shuttle"
	shuttle_restricted = "Mercenary"

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_start"
	dock_target = "merc_base"

/obj/effect/shuttle_landmark/merc/internim
	name = "In transit"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_transition"
	is_valid_destination = FALSE

/obj/effect/shuttle_landmark/merc/dock
	name = "Docking Port Deck 5"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_dock"
	dock_target = "second_sec_1_access_console"

/obj/effect/shuttle_landmark/merc/northeast
	name = "Northeast of the Vessel Deck 5"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_northeast"

/obj/effect/shuttle_landmark/merc/southwest
	name = "Southwest of the Vessel Deck 5"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_southwest"

/obj/effect/shuttle_landmark/merc/atmos
	name = "Atmospherics Deck 1"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_atmos"

/obj/effect/shuttle_landmark/merc/sec2west
	name = "Section II Deck 1 West"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_sec2west"

/obj/effect/shuttle_landmark/merc/sec2east
	name = "Section II Deck 1 East"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_sec2east"

/obj/effect/shuttle_landmark/merc/junk
	name = "Junk Beacon Deck 1"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_junk"

/obj/effect/shuttle_landmark/merc/armory
	name = "Armory Deck 1"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_armory"

/obj/effect/shuttle_landmark/merc/engieva
	name = "Engineering EVA Deck 3"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_engieva"

/obj/effect/shuttle_landmark/merc/mining
	name = "Mining Dock Deck 3"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_mining"

/obj/effect/shuttle_landmark/merc/medbay
	name = "Medbay Deck 4"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_medbay"

/obj/effect/shuttle_landmark/merc/engine
	name = "Engine Deck 4"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_engine"

/obj/effect/shuttle_landmark/merc/sec3east4
	name = "Section III Deck 4 East"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_sec3east4"

/obj/effect/shuttle_landmark/merc/sec3east5
	name = "Section III Deck 5 East"
	icon_state = "shuttle-red"
	landmark_tag = "nav_merc_sec3east5"

/obj/effect/shuttle_landmark/supply/centcom
	name = "Centcom"
	landmark_tag = "nav_cargo_start"
	is_valid_destination = FALSE

/obj/effect/shuttle_landmark/supply/station
	name = "Dock"
	landmark_tag = "nav_cargo_vessel"
	dock_target = "cargo_bay"
	is_valid_destination = FALSE

// Pirate shuttle
// Docking controller chooses which of our airlocks should open onto the target location.
// Pirate ship has two airlock but let's not bother having them automatically controlled

/datum/shuttle/autodock/multi/antag/pirate
	name = "Pirate"
	warmup_time = 0
	move_time = 100
	cloaked = 0
	shuttle_area = /area/shuttle/pirate
	// default_docking_controller = "pirate_shuttle"  // No need for docking controller (no two-stages airlock)
	current_location = "nav_pirate_start"
	landmark_transition = "nav_pirate_transition"
	announcer = "CEV Eris Sensor Array"
	home_waypoint = "nav_pirate_start"
	arrival_message = "Attention, unidentified vessel detected on long range sensors. \nVessel is approaching on an intercept course. \nHailing frequencies open."
	departure_message = "Attention, unknown vessel has departed."

	var/locked_shuttle = FALSE

//This fires, and the mission timer starts ticking, as soon as they leave Eris on course to the pirate base
/datum/shuttle/autodock/multi/antag/pirate/announce_departure()
	.=..()
	var/datum/faction/F = get_faction_by_id(FACTION_PIRATES)
	var/datum/objective/timed/pirate/MO = (locate(/datum/objective/timed/pirate) in F.objectives)
	if(MO)
		MO.end_mission()

//This fires, and the mission timer starts ticking, as soon as they leave base
/datum/shuttle/autodock/multi/antag/pirate/announce_arrival()
	.=..()
	var/datum/faction/F = get_faction_by_id(FACTION_PIRATES)
	var/datum/objective/timed/pirate/MO = (locate(/datum/objective/timed/pirate) in F.objectives)
	if(MO)
		MO.start_mission()

// Cannot go back to the base with an alive outsider
/datum/shuttle/autodock/multi/antag/pirate/proc/check_back_to_base()
	if(next_location == home_waypoint)
		var/datum/faction/F = get_faction_by_id(FACTION_PIRATES)
		for(var/mob/living/carbon/human/H in get_area_contents(/area/shuttle/pirate))
			if(!(H.stat == DEAD) && !F.is_member(H))
				return TRUE
	return FALSE

// Once the mission is over you cannot go back to Eris
/datum/shuttle/autodock/multi/antag/pirate/proc/lock_shuttle()
	locked_shuttle = TRUE

/datum/shuttle/autodock/multi/antag/pirate/can_launch()
	if(locked_shuttle || check_back_to_base())
		return FALSE
	else
		return ..()

/datum/shuttle/autodock/multi/antag/pirate/can_force()
	if(locked_shuttle || check_back_to_base())
		return FALSE
	else
		return ..()

// Navigation landmarks
/obj/effect/shuttle_landmark/pirate
	icon_state = "shuttle-green"
	shuttle_restricted = "Pirate"

/obj/effect/shuttle_landmark/pirate/start
	name = "Pirate Base"
	landmark_tag = "nav_pirate_start"

/obj/effect/shuttle_landmark/pirate/internim
	name = "In transit"
	landmark_tag = "nav_pirate_transition"
	is_valid_destination = FALSE

/obj/effect/shuttle_landmark/pirate/deck5_brig
	name = "Section I of the Vessel Deck 5"
	landmark_tag = "nav_pirate_deck5_brig"

/obj/effect/shuttle_landmark/pirate/deck5_dorms
	name = "Section I of the Vessel Deck 5"
	landmark_tag = "nav_pirate_deck5_dorms"

/obj/effect/shuttle_landmark/pirate/deck5_moebius
	name = "Section II of the Vessel Deck 5"
	landmark_tag = "nav_pirate_deck5_moebius"

/obj/effect/shuttle_landmark/pirate/deck5_cargo
	name = "Section III of the Vessel Deck 5"
	landmark_tag = "nav_pirate_deck5_cargo"

/obj/effect/shuttle_landmark/pirate/deck5_engine
	name = "Section IV of the Vessel Deck 5"
	landmark_tag = "nav_pirate_deck5_engine"

/obj/effect/shuttle_landmark/pirate/deck3_cargo
	name = "Section III of the Vessel Deck 3"
	landmark_tag = "nav_pirate_deck3_cargo"

/obj/effect/shuttle_landmark/pirate/deck3_engine
	name = "Section IV of the Vessel Deck 3"
	landmark_tag = "nav_pirate_deck3_engine"

/obj/effect/shuttle_landmark/pirate/deck2_medical
	name = "Section II of the Vessel Deck 2"
	landmark_tag = "nav_pirate_deck2_medical"

/obj/effect/shuttle_landmark/pirate/deck2_bar
	name = "Section III of the Vessel Deck 2"
	landmark_tag = "nav_pirate_deck2_bar"
