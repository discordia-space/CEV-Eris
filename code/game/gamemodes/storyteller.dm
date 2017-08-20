var/global/list/current_antagonists = list()

/datum/storyteller
	var/config_tag = "base"
	var/name = "Storyteller"
	var/description = "Storyteller tells the story of the round. It spawns antagonists and calls events."

	var/chaos_level = 0
	var/chaos_level_cap = 1000

	var/chaos_increment = 10
	var/chaos_increment_delay = 10		//Every this period in seconds, chaos level will be incremented by chaos_increment
	var/chaos_acceleration = 1			//Every chaos level increment, this value will be added to the chaos_increment

	var/role_spawn_timer = 0
	var/event_spawn_timer = 0

	var/min_role_spawn_delay = 20*60
	var/max_role_spawn_delay = 30*60

	var/min_start_role_spawn_delay = 10*60
	var/max_start_role_spawn_delay = 15*60
	var/first_role_spawn = TRUE

	var/min_event_spawn_delay = 10*60
	var/max_event_spawn_delay = 20*60

	var/difficult_multiplier = 1	//The larger this multiplier, the more difficult roles will spawn

	var/list/disabled_antags = list()
	var/list/disabled_events = list()


/datum/storyteller/proc/can_start()
	return TRUE

/datum/storyteller/proc/announce()
	world << "<b>Game storyteller is [src.name]</b>"
	if(description)
		world << "[description]"

/datum/storyteller/proc/declare_completion()

/datum/storyteller/proc/set_up()
	set_role_timer(rand(min_start_role_spawn_delay, max_start_role_spawn_delay))
	set_event_timer_default()


/datum/storyteller/proc/set_role_timer(var/time)
	role_spawn_timer = world.time + time

/datum/storyteller/proc/set_role_timer_default()
	set_role_timer(rand(min_role_spawn_delay, max_role_spawn_delay))

/datum/storyteller/proc/set_event_timer(var/time)
	event_spawn_timer = world.time + time

/datum/storyteller/proc/set_event_timer_default()
	set_event_timer(rand(min_event_spawn_delay, max_event_spawn_delay))


/datum/storyteller/proc/chaos_increment()
		chaos_level += chaos_increment / 10
		chaos_increment += chaos_acceleration / 10

/datum/storyteller/proc/process()
	chaos_increment()
	if(role_spawn_timer <= world.time)
		set_role_timer_default()
		spawn_antagonist()

/datum/storyteller/proc/spawn_antagonist()
	var/list/role_candidates = list()
	var/list/outside_candidates = list()
	for(var/mob/M in player_list)
		if(isliving(M))
			if(!M.stat)
				role_candidates.Add(M)
		else
			outside_candidates.Add(M)

	first_role_spawn = FALSE


//Announces objectives/generic antag text.
/proc/show_generic_antag_text(var/datum/mind/player)
	if(player.current)
		player.current << \
		"You are an antagonist! <font color=blue>Within the rules,</font> \
		try to act as an opposing force to the crew. Further RP and try to make sure \
		other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"

/proc/show_objectives(var/datum/mind/player)

	if(!player || !player.current)
		return

	if(config.objectives_disabled)
		show_generic_antag_text(player)
		return

	var/obj_count = 1
	player.current << "<span class='notice'>Your current objectives:</span>"
	for(var/datum/objective/objective in player.objectives)
		player.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++

/mob/verb/check_round_info()
	set name = "Check Storyteller"
	set category = "OOC"

	if(!ticker || !ticker.storyteller)
		usr << "Something is terribly wrong; there is no gametype."
		return

	usr << "<b>The round storyteller is [capitalize(ticker.storyteller.name)]</b>"
	if(ticker.storyteller.description)
		usr << "<i>[ticker.mode.round_description]</i>"
