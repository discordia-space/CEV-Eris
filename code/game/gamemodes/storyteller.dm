var/global/list/current_antags = list()
var/global/list/current_factions = list()

var/global/list/rolespawn_log = list()

/datum/storyteller
	var/config_tag = "normal"
	var/name = "Shitgenerator"
	var/welcome = "Prepare to fun!"
	var/description = "Try to survive as long as you can."

	var/role_spawn_timer = 0
	var/role_spawn_stage = 0

	var/min_role_spawn_delay = 20*60
	var/max_role_spawn_delay = 30*60

	var/min_start_role_spawn_delay = 10*60
	var/max_start_role_spawn_delay = 18*60
	var/first_role_spawn = TRUE

	var/list/disabled_antags = list()
	var/list/disabled_events = list()
	var/list/required_jobs = list("Captain" = 1,"Technomancer" = 1)

	var/list/pending_candidates = list()


/datum/storyteller/proc/can_start(var/announce = FALSE)
	for(var/role in required_jobs)
		var/check = 0
		for(var/mob/new_player/player in player_list)
			if(player.ready && player.mind && player.mind.assigned_role == role)
				check++
		if(check < required_jobs[role])
			world << "<b>Game won't start without the [role].</b>"
			world << print_required_roles()
			return FALSE

	return TRUE

/datum/storyteller/proc/announce()
	world << "<b><font size=3>Storyteller is [src.name]. [welcome]</font></b>"
	if(description)
		world << "[description]"

/datum/storyteller/proc/declare_completion()

/datum/storyteller/proc/set_up()
	fill_rolesets_list()
	set_role_timer(rand(min_start_role_spawn_delay, max_start_role_spawn_delay))

/datum/storyteller/proc/set_role_timer(var/time)
	role_spawn_timer = world.time + time

/datum/storyteller/proc/set_role_timer_default()
	set_role_timer(rand(min_role_spawn_delay, max_role_spawn_delay))

/datum/storyteller/proc/process()
	if(role_spawn_timer && role_spawn_timer <= world.time)
		set_role_timer_default()
		role_spawn_stage++
		spawn_antagonist()


/datum/storyteller/proc/get_round_weight()
	return 0

/datum/storyteller/proc/get_roleset_weight(var/datum/roleset/R)
	return R.roles_weight()+R.special_weight()

/datum/storyteller/proc/spawn_antagonist()
	var/weight = get_round_weight()

	//Shuffle roleset list to make rolesets with equal weight follow randomly
	var/list/shuffled_rolesets = list()
	for(var/datum/roleset/R in rolesets)
		shuffled_rolesets.Insert(random(1,shuffled_rolesets.len),R)

	//Now, sort possiblities by closeness to round weight
	var/list/possiblities = list()
	for(var/datum/roleset/R in shuffled_rolesets)
		if(R.can_spawn())
			var/added = FALSE
			var/rweight = get_roleset_weight(R)
			if(possiblities.len)
				for(var/i = 1; i<=possiblities.len; i++)
					var/list/M = possiblities[i]
					if(abs(rweight-weight) <= abs(M[1]-weight))
						added = TRUE
						possiblities.Insert(i,list(rweight,R))
						break
			if(!added)
				possiblities.Add(list(rweight,R))

	for(var/list/L in possiblities)
		var/datum/roleset/R = L[2]
		if(spawn_roleset(R))
			rolespawn_log.Add(L)
			break




