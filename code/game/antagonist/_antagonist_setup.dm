/*
 MODULAR ANTAGONIST SYSTEM

 Attempts to move all the bullshit snowflake antag tracking code into its own system, which
 has the added bonus of making the display procs consistent. Still needs work/adjustment/cleanup
 but should be fairly self-explanatory with a review of the procs. Will supply a few examples
 of common tasks that the system will be expected to perform below. ~Z

 To use:
   - Get the appropriate datum via get_antag_data("antagonist id")
     using the id var of the desired /datum/antagonist ie. var/datum/antagonist/A = get_antag_data("traitor")
   - Call add_antagonist() on the desired target mind ie. A.add_antagonist(mob.mind)
   - To ignore protected roles, supply a positive second argument.
   - To skip equipping with appropriate gear, supply a positive third argument.
*/

// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB        1 // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB        2 // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT     4 // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME         8 // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE     16 // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS         32 // Shows up on roundstart report.
#define ANTAG_HAS_LEADER         64 // Generates a leader antagonist.
#define ANTAG_HAS_NUKE          128 // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN         256 // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE           512 // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE   1024 // Causes antagonists to use an appearance modifier on spawn.
#define ANTAG_RANDOM_EXCEPTED  2048 // If a game mode randomly selects antag types, antag types with this flag should be excluded.

// Globals.
var/global/list/antag_types = list()
var/global/list/antag_names = list()
var/global/list/station_antag_types = list()
var/global/list/outer_antag_types = list()
var/global/list/group_antag_types = list()
var/global/list/antag_starting_locations = list()
var/global/list/selectable_antag_types = list()
var/global/list/antag_bantypes = list()

var/global/list/faction_types = list()

// Global procs.
/proc/clear_antagonist(var/datum/mind/player)
	for(var/datum/antagonist/A in player.antagonist)
		A.remove_antagonist()

/proc/clear_antagonist_type(var/datum/mind/player, var/a_id)
	for(var/datum/antagonist/A in player.antagonist)
		if(A.id == a_id)
			A.remove_antagonist()

/proc/get_antag_instance(var/a_id)
	if(antag_types[a_id])
		var/atype = antag_types[a_id]
		return new atype

/proc/make_antagonist_ghost(var/mob/M, var/a_id)
	if(antag_types[a_id])
		var/a_type = antag_types[a_id]
		var/datum/antagonist/A = new a_type
		if(A.create_from_ghost(M))
			return A

/proc/make_antagonist(var/datum/mind/M, var/a_id)
	if(antag_types[a_id])
		var/a_type = antag_types[a_id]
		var/datum/antagonist/A = new a_type
		if(istype(M) && A.create_antagonist(M))
			return A

/proc/make_antagonist_faction(var/datum/mind/M, var/a_id, var/datum/faction/F)
	if(antag_types[a_id])
		var/a_type = antag_types[a_id]
		var/datum/antagonist/A = new a_type
		A.create_antagonist(M, F)

		return A

/proc/update_antag_icons(var/datum/mind/player)
	for(var/datum/antagonist/antag in player.antagonist)
		if(antag.faction)
			antag.faction.update_icons(antag)

/proc/populate_antag_type_list()
	for(var/antag_type in typesof(/datum/antagonist)-/datum/antagonist)
		var/datum/antagonist/A = antag_type
		var/id = initial(A.id)

		if(!id)
			continue

		antag_types[id] = antag_type
		if(initial(A.outer))
			outer_antag_types[id] = antag_type
			var/list/start_locs = list()
			var/landmark_id = initial(A.landmark_id)
			for(var/obj/landmark/L in landmarks_list)
				if(L.name == landmark_id)
					start_locs |= get_turf(L)
			antag_starting_locations[id] = start_locs
		else
			station_antag_types[id] = antag_type

		var/role_type = initial(A.role_type)
		if(!role_type)
			role_type = initial(A.role_text)

		if(initial(A.selectable))
			selectable_antag_types |= role_type
		if(initial(A.faction_id))
			group_antag_types[id] = antag_type
		antag_names[id] = initial(A.role_text)

		var/bantype = initial(A.bantype)
		if(!bantype)
			bantype = role_type

		antag_bantypes[id] = bantype

	for(var/faction_type in typesof(/datum/faction)-/datum/faction)
		var/datum/faction/F = faction_type
		faction_types[initial(F.id)] = faction_type

/proc/get_antags(var/id)
	var/list/L = list()
	for(var/datum/antagonist/A in current_antags)
		if(A.id == id)
			L.Add(A)
	return L

/proc/get_player_antag_name(var/datum/mind/player)
	if(!istype(player))
		return "ERROR"
	var/names
	for(var/datum/antagonist/A in player.antagonist)
		if(names)
			names += ", "+A.role_text
		else
			names = A.role_text
	return names

/proc/player_is_antag(var/datum/mind/player, var/only_offstation_roles = FALSE)
	for(var/datum/antagonist/antag in player.antagonist)
		if((antag.outer && only_offstation_roles) || !only_offstation_roles)
			return TRUE
	return FALSE

/proc/player_is_ship_antag(var/datum/mind/player)
	for(var/datum/antagonist/antag in player.antagonist)
		if(!antag.outer)
			return TRUE
	return FALSE

/proc/player_is_antag_id(var/datum/mind/player, var/a_id)
	for(var/datum/antagonist/antag in player.antagonist)
		if(!a_id || antag.id == a_id)
			return TRUE
	return FALSE

/proc/get_antags_list(var/a_type)
	if(!a_type)
		return current_antags

	var/list/L = list()
	for(var/datum/antagonist/antag in current_antags)
		if(antag.id == a_type)
			L.Add(antag)
	return L

/proc/get_player_antags(var/datum/mind/player, var/a_type)
	if(!a_type)
		return player.antagonist

	var/list/L = list()
	for(var/datum/antagonist/antag in player.antagonist)
		if(antag.id == a_type)
			L.Add(antag)
	return L

/proc/get_dead_antags_count(var/a_type)
	var/count = 0
	for(var/datum/antagonist/antag in current_antags)
		if((!a_type || antag.id == a_type) && antag.is_dead())
			count++
	return count

/proc/get_antags_count(var/a_type)
	if(!a_type)
		return current_antags.len

	var/count = 0
	for(var/datum/antagonist/antag in current_antags)
		if(!a_type || antag.id == a_type)
			count++
	return count

/proc/get_active_antag_count(var/a_type)
	var/active_antags = 0
	for(var/datum/antagonist/antag in current_antags)
		if((!a_type || antag.id == a_type) && antag.is_active())
			active_antags++
	return active_antags

/proc/get_faction_by_id(var/f_id)
	for(var/datum/faction/F in current_factions)
		if(F.id == f_id)
			return F

/proc/get_factions_by_id(var/f_id)
	var/list/L = list()
	for(var/datum/faction/F in current_factions)
		if(F.id == f_id)
			L.Add(F)
	return L

/proc/player_is_antag_faction(var/datum/mind/player, var/a_id, var/datum/faction/F)
	for(var/datum/antagonist/antag in player.antagonist)
		if((!a_id || antag.id == a_id) && antag.faction == F)
			return TRUE
	return FALSE

/proc/create_or_get_faction(var/f_id)
	var/list/factions = list()
	for(var/datum/faction/F in current_factions)
		if(F.id == f_id)
			factions.Add(F)

	if(!factions.len)
		return new f_id
	else
		return factions[1]
