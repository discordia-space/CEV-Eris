

/decl/move_intent
	var/name
	var/flags = 0
	var/move_delay = 1
	var/hud_icon_state

/decl/move_intent/proc/can_enter(var/mob/living/L, var/warnings = FALSE)
	return TRUE

/decl/move_intent/walk
	name = "Walk"
	flags = MOVE_INTENT_DELIBERATE
	hud_icon_state = "walking"

/decl/move_intent/walk/Initialize()
	. = ..()
	move_delay = 5 //Placeholder. TODO: Movespeed in species datums


/decl/move_intent/run
	name = "Run"
	flags = MOVE_INTENT_EXERTIVE | MOVE_INTENT_QUICK
	hud_icon_state = "running"

/decl/move_intent/run/Initialize()
	. = ..()
	move_delay = 3.5
