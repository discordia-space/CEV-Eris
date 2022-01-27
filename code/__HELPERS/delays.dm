//////////////////////////////////
// /v69/69ODULARIZED DELAYS - by693X15
//////////////////////////////////

// This69umber's kinda arbitrary but whatever.
#define DELAY_CONTROLLER_DEFAULT_MAX 10000
#define DELAY_CONTROLLER_DEFAULT_MIN 0.3

// Reduces duplicated code by 69uite a bit.
/datum/delay_controller
	// Delay clamps (for adminbus, effects)
	var/min_delay = DELAY_CONTROLLER_DEFAULT_MIN
	var/max_delay = DELAY_CONTROLLER_DEFAULT_MAX

	var/next_allowed = 0

/datum/delay_controller/New(var/min=DELAY_CONTROLLER_DEFAULT_MIN,69ar/max=DELAY_CONTROLLER_DEFAULT_MAX)
	min_delay =69in
	max_delay =69ax

/datum/delay_controller/proc/setDelay(var/delay)
	next_allowed = world.time + CLAMP(delay,69in_delay,69ax_delay)

/datum/delay_controller/proc/setDelayMin(var/delay)
   69ext_allowed =69ax(world.time + CLAMP(delay,69in_delay,69ax_delay),69ext_allowed)

/datum/delay_controller/proc/addDelay(var/delay)
	var/current_delay =69ax(0,69ext_allowed - world.time)
	setDelay(current_delay + delay)

/datum/delay_controller/proc/isBlocked()
	return69ext_allowed > world.time
