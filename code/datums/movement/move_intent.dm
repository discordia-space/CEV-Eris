

/decl/move_intent
	var/name
	var/flags = 0
	var/move_delay = 1
	var/hud_icon_state

/decl/move_intent/proc/can_enter(var/mob/living/L,69ar/warnings = FALSE)
	return TRUE

/decl/move_intent/walk
	name = "Walk"
	flags =69OVE_INTENT_DELIBERATE
	hud_icon_state = "walking"

/decl/move_intent/walk/Initialize()
	. = ..()
	move_delay = 5 //Placeholder. TODO:69ovespeed in species datums


/decl/move_intent/run
	name = "Run"
	flags =69OVE_INTENT_EXERTIVE |69OVE_INTENT_QUICK
	hud_icon_state = "running"

/decl/move_intent/run/Initialize()
	. = ..()
	move_delay = 3.5
