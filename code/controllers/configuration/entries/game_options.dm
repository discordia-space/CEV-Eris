/datum/config_entry/string/start_location
	default = "asteroid"

/datum/config_entry/string/start_location/ValidateAndSet(str_val)
	var/list/startlist = list(
		"asteroid",
		"abandoned fortress",
		"space ruins")
	if (str_val in startlist)
		. = ..()
	else
		if (str_val == "random")
			config_entry_value = pick(startlist)
			return TRUE


/datum/config_entry/flag/allow_random_events

/datum/config_entry/flag/generate_asteroid

/datum/config_entry/flag/generate_loot_data

/datum/config_entry/flag/z_level_shooting

/datum/config_entry/flag/organs_can_decay

/datum/config_entry/flag/limbs_can_break


// lets ghosts spin chairs (very important)
/datum/config_entry/flag/ghost_interaction

/datum/config_entry/number/revival_brain_life
	default = -1
	integer = TRUE

/datum/config_entry/flag/welder_vision

// If security and such can be contractor/cult/other
/datum/config_entry/flag/protect_roles_from_antagonist


// level of health at which a mob goes into continual shock (soft crit)
/datum/config_entry/number/health_threshold_softcrit
	default = 0
	integer = TRUE

// level of health at which a mob becomes unconscious (crit)
/datum/config_entry/number/health_threshold_crit
	default = -50
	integer = TRUE

// level of health at which a mob becomes dead
/datum/config_entry/number/health_threshold_dead
	default = -100
	integer = TRUE

/datum/config_entry/string/law_zero
	default = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"
