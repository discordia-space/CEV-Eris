//////////////////////////////////
// /vg/ MODULARIZED DELAYS - by N3X15
//////////////////////////////////

// This number's kinda arbitrary but whatever.
#define DELAY_CONTROLLER_DEFAULT_MAX 10000
#define DELAY_CONTROLLER_DEFAULT_MIN 0.3

// Reduces duplicated code by quite a bit.
/datum/delay_controller
	// Delay clamps (for adminbus, effects)
	var/min_delay = DELAY_CONTROLLER_DEFAULT_MIN
	var/max_delay = DELAY_CONTROLLER_DEFAULT_MAX

	var/next_allowed = 0

/datum/delay_controller/New(var/min=DELAY_CONTROLLER_DEFAULT_MIN, var/max=DELAY_CONTROLLER_DEFAULT_MAX)
	min_delay = min
	max_delay = max

/datum/delay_controller/proc/setDelay(var/delay)
	next_allowed = world.time + CLAMP(delay, min_delay, max_delay)

/datum/delay_controller/proc/setDelayMin(var/delay)
    next_allowed = max(world.time + CLAMP(delay, min_delay, max_delay), next_allowed)

/datum/delay_controller/proc/addDelay(var/delay)
	var/current_delay = max(0, next_allowed - world.time)
	setDelay(current_delay + delay)

/datum/delay_controller/proc/isBlocked()
	return next_allowed > world.time
