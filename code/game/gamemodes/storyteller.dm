var/global/list/current_antags = list()
var/global/list/current_factions = list()

var/global/list/rolespawn_log = list()

/datum/storyteller
	var/config_tag = STORYTELLER_BASE
	var/name = "Shitgenerator"
	var/welcome = "Prepare to fun! Try to survive as long as you can."
	var/description = "Shitgenerator is most basic storyteller."

	var/role_spawn_timer = 0
	var/role_spawn_stage = 0

	var/min_role_spawn_delay = 20 MINUTE
	var/max_role_spawn_delay = 30 MINUTE

	var/min_start_role_spawn_delay = 10 MINUTE
	var/max_start_role_spawn_delay = 18 MINUTE
	var/first_role_spawn = TRUE

	var/list/disabled_antags = list()
	var/list/disabled_events = list()
	var/list/required_jobs = list("Captain" = 1,"Technomancer" = 1)

	var/list/pending_candidates = list()


/datum/storyteller/proc/can_start(var/announce = FALSE)
	if(required_jobs.len)
		for(var/role in required_jobs)
			var/check = 0
			for(var/mob/new_player/player in player_list)
				if(player.ready && player.mind && player.mind.assigned_role == role)
					check++
			if(check < required_jobs[role])
				world << "<b>Game can't start without the [role].</b>"
				world << print_required_roles()
				return FALSE

	return TRUE

/datum/storyteller/proc/announce()
	world << "<b><font size=3>Storyteller is [src.name].</font> <br>[welcome]</b>"
	if(description)
		world << "[description]"

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


/datum/storyteller/proc/get_player_weight(var/mob/M)
	var/weight = 0
	if(M.client && (M.mind && !M.mind.antagonist.len) && M.stat != DEAD && (ishuman(M) || isrobot(M) || isAI(M)))
		weight += 1
		if(isAI(M))
			weight += 5
		var/datum/job/job = job_master.GetJob(M.mind.assigned_role)
		if(job)
			if(job.flag == CAPTAIN)
				weight += 2
			if(job.head_position)
				weight += 2
			if(job.department_flag == ENGSEC)
				weight += 1
			if(job.department_flag == MEDSCI)
				weight += 0.5

	return weight

/datum/storyteller/proc/get_round_weight()
	var/weight = 0

	for(var/mob/M in player_list)
		weight += get_player_weight(M)

	weight += (role_spawn_stage) * 4

	return weight

/datum/storyteller/proc/get_roleset_weight(var/datum/roleset/R)
	return R.get_roles_weight()+R.get_special_weight()

/datum/storyteller/proc/spawn_antagonist()
	var/weight = get_round_weight()

	//Shuffle roleset list to make rolesets with equal weight follow randomly
	var/list/shuffled_rolesets = list()
	for(var/datum/roleset/R in rolesets)
		shuffled_rolesets.Insert(rand(1,shuffled_rolesets.len),R)

	//Now, sort possiblities by closeness to the round weight
	var/list/possiblities = list()
	var/list/weight_cache = list()
	for(var/datum/roleset/R in shuffled_rolesets)
		if(R.can_spawn())
			var/added = FALSE
			var/rweight = get_roleset_weight(R)
			weight_cache[R] = rweight
			if(possiblities.len)
				for(var/i = 1; i<=possiblities.len; i++)
					var/datum/roleset/R2 = possiblities[i]
					if(!istype(R2))
						log_debug("Wrong element in storyteller possiblities sort list! ([R2])")
						continue
					if(abs(rweight-weight) <= abs(weight_cache[R2]-weight))
						added = TRUE
						possiblities.Insert(i,R)
						break
			if(!added)
				possiblities.Add(R)

	for(var/datum/roleset/R in possiblities)
		if(R.spawn_roleset())
			rolespawn_log.Add(R)
			return TRUE

	log_admin("STORYTELLER: All rolesets failed. There's no antag in this time. [storyteller_button()]")
	return FALSE

/proc/storyteller_button()
	return "<a href='?src=\ref[ticker.storyteller];panel=1'>\[STORY\]</a>"


