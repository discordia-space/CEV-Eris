/mob/living
	see_in_dark = 2
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	var/hud_updateflag = 0

	var/life_cycles_before_sleep = 30
	var/life_cycles_before_scan = 360

	var/stasis = FALSE
	var/AI_inactive = FALSE

	var/inventory_shown = 1

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	var/bruteloss = 0	//Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/oxyloss = 0	//Oxygen depravation damage (no air in lungs)
	var/toxloss = 0	//Toxic damage caused by being poisoned or radiated
	var/fireloss = 0	//Burn damage caused by being way too hot, too cold or burnt.
	var/cloneloss = 0	//Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims
	var/brainloss = 0	//'Retardation' damage caused by someone hitting you in the head with a bible or being infected with brainrot.
	var/halloss = 0		//Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.

	var/injury_type = INJURY_TYPE_LIVING //Humanmob uses species instead
	var/armor_divisor = 1 //Used for generic attacks

	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.

	var/t_plasma
	var/t_oxygen
	var/t_sl_gas
	var/t_n2

	var/now_pushing
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0
	var/mob_always_swap = 0
	var/livmomentum = 0 //Used for advanced movement options.
	var/move_to_delay = 4 //Delay for the automated movement.
	var/can_burrow = FALSE //If true, this mob can travel around using the burrow network.
	//When this mob spawns at roundstart, a burrow will be created near it if it can't find one

	var/mob/living/cameraFollow
	var/list/datum/action/actions = list()
	var/step_count = 0

	var/update_slimes = 1
	var/is_busy = FALSE // Prevents stacking of certain actions, like resting and diving
	var/silent 		// Can't talk. Value goes down every life proc.
	var/on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/possession_candidate // Can be possessed by ghosts if unplayed.

	var/eye_blind	//Carbon
	var/eye_blurry	//Carbon
	var/ear_damage	//Carbon
	var/stuttering	//Carbon
	var/slurring		//Carbon
	var/slowdown = 0

	var/job //Living

	var/image/static_overlay // For static overlays on living mobs
	mob_classification = CLASSIFICATION_ORGANIC

	var/list/chem_effects = list()

	//Used in living/recoil.dm
	var/recoil = 0 //What our current recoil level is
	var/recoil_reduction_timer
	var/falls_mod = 1
	var/mob_bomb_defense = 0	// protection from explosives
	var/mod_climb_delay = 1 // delay for climb
	var/noise_coeff = 1 //noise coefficient

	var/can_multiz_pb = FALSE
	var/is_watching = FALSE

	spawn_frequency = 10
	bad_type = /mob/living
