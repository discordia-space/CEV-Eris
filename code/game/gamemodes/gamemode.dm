/datum/gamemode
	var/name = "Gamemode Parent"
	var/list/factions = list()
	var/list/factions_allowed = list()
	var/minimum_player_count
	var/admin_override //Overrides checks such as minimum_player_count to
	var/list/roles_allowed = list()
	var/probability = 50
	var/votable = TRUE
	var/list/orphaned_roles = list()
	var/dat = ""