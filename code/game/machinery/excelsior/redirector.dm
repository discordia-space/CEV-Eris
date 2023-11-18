/obj/machinery/excelsior_redirector
	name = "excelsior ship-navigation redirector"
	desc = "A arcane mechanism used to hack the bluespace direction control of ships and inevitably lock their course towards excelsior-controlled space. Only works on navigation consoles made before 2502"
	description_antag = "The final objective of the revolution. Install this ontop of the main navigation console of the ship, located in the bridge and defend it while it does its job"
	density = TRUE
	anchored = FALSE
	icon = 'icons/obj/machines/excelsior/redirector.dmi'
	icon_state = "redirector"
	use_power = IDLE_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	circuit = /obj/item/electronics/circuitboard/excelsior_navigation_cracker
	var/oldSecurityLevel = null
	var/timeStarted = null

/obj/machinery/excelsior_redirector/proc/beginRedirecting()
	timeStarted = world.time
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
	oldSecurityLevel = security_state.current_security_level
	security_state.set_security_level(/decl/security_level/default/code_jumping, force_change = TRUE)



/obj/machinery/excelsior_redirector/proc/finishRedirecting()

/obj/machinery/excelsior_redirector/proc/stopRedirecting()
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
	security_state.set_security_level(oldSecurityLevel, force_change = TRUE)
