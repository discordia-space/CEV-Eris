/datum/individual_objetive/upgrade
	name = "Upgrade"
	desc =  "It’s time to improve your meat with shiny chrome. Gain new bionics, implant, or any mutation."
	allow_cruciform = FALSE

/datum/individual_objetive/upgrade/assign()
	..()
	RegisterSignal(owner.current, COMSIG_HUMAN_ROBOTIC_MODIFICATION, .proc/completed)

/datum/individual_objetive/upgrade/completed()
	if(completed) return
	UnregisterSignal(owner.current, COMSIG_HUMAN_ROBOTIC_MODIFICATION)
	..()
