var/global/list/current_antags = list()
var/global/list/current_factions = list()

/datum/storyteller
	var/config_tag = "normal"
	var/name = "Shitgenerator"
	var/welcome = "Prepare to fun!"
	var/description = "Try to survive as long as you can."

	var/chaos_level = 0
	var/chaos_level_cap = 1000

	var/chaos_increment = 10

	var/role_spawn_timer = 0
	var/event_spawn_timer = 0

	var/min_role_spawn_delay = 20*60
	var/max_role_spawn_delay = 30*60

	var/min_start_role_spawn_delay = 10*60
	var/max_start_role_spawn_delay = 15*60
	var/first_role_spawn = TRUE

	var/min_event_spawn_delay = 10*60
	var/max_event_spawn_delay = 20*60

	var/difficult_multiplier = 1	//The larger this multiplier, the more difficult roles will be spawned

	var/list/disabled_antags = list()
	var/list/disabled_events = list()
	var/list/required_jobs = list("Captain","Technomancer")

	var/list/pending_candidates = list()


/datum/storyteller/proc/can_start(var/announce = FALSE)
	for(var/role in required_jobs)
		var/check = FALSE
		for(var/mob/new_player/player in player_list)
			if(player.ready && player.mind && player.mind.assigned_role == role)
				check = TRUE
				break
		if(!check)
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
		chaos_level += chaos_increment

/datum/storyteller/proc/process()
	chaos_increment()
	if(role_spawn_timer <= world.time)
		set_role_timer_default()
		spawn_antagonist()

	if(event_spawn_timer <= world.time)
		set_event_timer_default()
		create_event()

/datum/storyteller/proc/print_required_roles()
	var/text = "[name]'s required roles:"
	for(var/reqrole in required_jobs)
		text += "<br> - [reqrole]"
	return text

/datum/storyteller/proc/choose_antagonist_type()
	return

/datum/storyteller/proc/spawn_antagonist()


/datum/storyteller/proc/choose_event()
	return

/datum/storyteller/proc/create_event()

