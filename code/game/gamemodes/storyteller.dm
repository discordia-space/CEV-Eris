#define ROLESET_WEIGHT_RANDOMIZE_MOD 0.09

var/global/list/current_antags = list()
var/global/list/current_factions = list()

/datum/storyteller
	var/config_tag = ""
	var/name = "Storyteller"
	var/welcome = "Welcome"
	var/description = "You shouldn't see this"

	var/role_spawn_timer = 0
	var/role_spawn_stage = 0

	var/min_role_spawn_delay = 20 MINUTES
	var/max_role_spawn_delay = 30 MINUTES

	var/min_start_role_spawn_delay = 10 MINUTES
	var/max_start_role_spawn_delay = 18 MINUTES

	var/list/disabled_antags = list()
	var/list/disabled_events = list()

	var/one_role_per_player = TRUE

	var/force_spawn_now = FALSE

/datum/storyteller/proc/can_start(var/announce = FALSE)	//when TRUE, proc should output reason, by which it can't start, to world
	return TRUE

/datum/storyteller/proc/announce()
	world << "<b><font size=3>Storyteller is [src.name].</font> <br>[welcome]</b>"

/datum/storyteller/proc/set_up()
	fill_rolesets_list()
	set_role_timer(rand(min_start_role_spawn_delay, max_start_role_spawn_delay))

/datum/storyteller/proc/set_role_timer(var/time)
	role_spawn_timer = world.time + time

/datum/storyteller/proc/set_role_timer_default()
	set_role_timer(rand(min_role_spawn_delay, max_role_spawn_delay))

/datum/storyteller/proc/process()
	if(force_spawn_now || (role_spawn_timer && role_spawn_timer <= world.time))
		force_spawn_now = FALSE
		spawn_antagonist()

/datum/storyteller/proc/update_objectives()
	for(var/datum/antagonist/A in current_antags)
		if(!A.faction)
			for(var/datum/objective/O in A.objectives)
				O.update_completion()

	for(var/datum/faction/F in current_factions)
		for(var/datum/objective/O in F.objectives)
			O.update_completion()

/datum/storyteller/proc/get_roleset_weight(var/datum/roleset/R)
	ASSERT(istype(R))

	R.weight_cache = calculate_roleset_weight(R)
	R.weight_cache *= 1-rand()*ROLESET_WEIGHT_RANDOMIZE_MOD
	return R.weight_cache

/datum/storyteller/proc/calculate_roleset_weight(var/datum/roleset/R)
	var/weight = 1

	var/crew = 0
	var/heads = 0
	var/sec = 0
	var/eng = 0
	var/med = 0
	var/sci = 0

	for(var/mob/M in player_list)
		if(M.client && (M.mind && !M.mind.antagonist.len) && M.stat != DEAD && (ishuman(M) || isrobot(M) || isAI(M)))
			var/datum/job/job = job_master.GetJob(M.mind.assigned_role)
			if(job)
				crew++
				if(job.head_position)
					heads++
				if(job.department == "Engineering")
					eng++
				if(job.department == "Security")
					sec++
				if(job.department == "Medical")
					med++
				if(job.department == "Science")
					sci++

		weight *= crew_weight_mult(crew,R.req_crew,R.max_crew_diff)
		weight *= crew_weight_mult(heads,R.req_heads,R.max_crew_diff)
		weight *= crew_weight_mult(sec,R.req_sec,R.max_crew_diff)
		weight *= crew_weight_mult(eng,R.req_eng,R.max_crew_diff)
		weight *= crew_weight_mult(med,R.req_med,R.max_crew_diff)
		weight *= crew_weight_mult(sci,R.req_sci,R.max_crew_diff)

		if(R.req_stage >= 0)
			weight *= max(R.max_stage_diff**2-(abs(role_spawn_stage-R.req_stage)**2),0)/R.max_stage_diff**2

		if(R.spawn_times > 1 && weight > 0.30)
			weight = weight - 0.2*R.spawn_times

		R.weight_cache = R.get_special_weight(weight)
		return R.weight_cache

/datum/storyteller/proc/crew_weight_mult(var/val, var/req, var/maxdiff)
	if(req<0)
		return 1
	var/mod = maxdiff**2
	return max(mod-(abs(val-req)**2),0)/mod

/datum/storyteller/proc/spawn_antagonist()
	var/datum/roleset/role
	for(var/datum/roleset/R in rolesets)
		if(R.can_spawn())
			if(!role || get_roleset_weight(R) > role.weight_cache)
				role = R

	if(role.create())
		set_role_timer_default()
		role_spawn_stage++
		return TRUE
	else
		set_role_timer(rand(2 MINUTES,5 MINUTES))
		return FALSE


/proc/storyteller_button()
	if(ticker && ticker.storyteller)
		return "<a href='?src=\ref[ticker.storyteller];panel=1'>\[STORY\]</a>"
	else
		return "<s>\[STORY\]</s>"


