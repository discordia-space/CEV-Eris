/obj/machinery/excelsior_redirector
	name = "excelsior ship-navigation redirector"
	desc = "An arcane mechanism used to hack the bluespace direction control of ships and inevitably lock their course towards excelsior-controlled space. Only works on navigation consoles made before 2502."
	description_antag = "The final objective of the revolution. Install this ontop of the main navigation console of the ship, located in the bridge and defend it while it does its job."
	density = TRUE
	anchored = FALSE
	icon = 'icons/obj/machines/excelsior/redirector.dmi'
	icon_state = "redirector_unanchored"
	use_power = IDLE_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	circuit = /obj/item/electronics/circuitboard/excelsior_navigation_cracker
	var/oldSecurityLevel = null
	var/timeStarted = null
	var/timeRebooted = null
	var/rebootTimer = null
	var/redirectTimer = null
	var/antennaBent = FALSE

/obj/machinery/excelsior_redirector/examine(mob/user, distance, infix, suffix)
	. = ..(user, afterDesc = is_excelsior(user) ? SPAN_DANGER("Do not build any walls around this as it will interfere with the mechanism and cause it to instantly fail.") : "")

/obj/machinery/excelsior_redirector/attackby(obj/item/I, mob/living/user)
	if(istool(I))
		if(rebootTimer)
			to_chat(user, SPAN_NOTICE("You can't unanchor \the [src] whilst it's running!"))
		if(I.get_tool_quality(QUALITY_BOLT_TURNING))
			if(!anchored)
				var/area/ar = get_area(src)
				if(!(ar.type == /area/eris/command/bridge))
					to_chat(user, SPAN_DANGER("\The [src] can only be anchored on the Bridge of the CEV Eris near the helm console."))
					return
				var/obj/machinery/computer/helm/consol = null
				for(var/turf/thing in RANGE_TURFS(1, src))
					if(!consol)
						consol = locate() in thing
					if(iswall(thing))
						to_chat(user, SPAN_DANGER("\The [src] needs to be kept away from walls in order to work properly!"))
						return
				if(!consol)
					to_chat(user, SPAN_NOTICE("\The [src] must be installed near a helm navigation console."))
					return
			to_chat(user, SPAN_NOTICE("You [anchored ? "unanchor" : "anchor"] \the [src] to the floor."))
			anchored = !anchored
			icon_state = "[anchored ? "redirector_anchored" : "redirector_unanchored"]"
	else ..()

/obj/machinery/excelsior_redirector/attack_hand(mob/user)
	if(is_excelsior(user))
		if(!anchored)
			to_chat(user, SPAN_NOTICE("\The [src] needs to be first anchored to begin its procedure."))
			return
		if(redirectTimer)
			if(rebootTimer)
				doReboot(user)
				return
			else
				to_chat(user, SPAN_DANGER("You can't cancel \the [src]'s mechanism!"))
				return
		else if(antennaBent)
			to_chat(user, SPAN_NOTICE("You bend back \the [src]'s antenna, it snaps right back into place!"))
			icon_state = "redirector_anchored"
			return
		else
			var/theCarnageBegins = input(user, "Are you sure you want to begin the bluespace navigation redirection override? This cannot be stopped once it begins and failure to complete it will result in the deaths of all excelsior agents onboard." , "Let the last stand begin?", "no") as anything in list("yes", "no")
			if(theCarnageBegins == "yes")
				beginRedirecting(user)
				return
			else
				return
	else
		if(redirectTimer)
			tryRuin(user)
		else
			to_chat(user, "You cluelessly look at \the [src].")

/obj/machinery/excelsior_redirector/Process()
	if(rebootTimer)
		for(var/turf/thing in RANGE_TURFS(1, src))
			if(iswall(thing))
				stopRedirecting()
				return

/obj/machinery/excelsior_redirector/proc/beginRedirecting(mob/living/carbon/human/starter)
	timeStarted = world.time
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
	oldSecurityLevel = security_state.current_security_level
	security_state.set_security_level(security_state.all_security_levels[5], force_change = TRUE)
	SSticker.excelsior_hijacking = 1
	var/datum/faction/excelsior/commies = get_faction_by_id(FACTION_EXCELSIOR)
	for (var/datum/antagonist/A in commies.members)
		to_chat(A.owner.current, SPAN_EXCEL_NOTIF("\The [src] has been booted in the Bridge by [starter]. Failure to defend it until it completes its mission will result in implant detonation! Ever upwards comrades."))
	redirectTimer = addtimer(CALLBACK(src, PROC_REF(finishRedirecting)), 15 MINUTES, TIMER_STOPPABLE)
	addtimer(CALLBACK(src, PROC_REF(requestReboot)), 3 MINUTES)
	icon_state = "redirector_running"

/obj/machinery/excelsior_redirector/proc/requestReboot()
	rebootTimer = addtimer(CALLBACK(src , PROC_REF(stopRedirecting)), 2 MINUTES, TIMER_STOPPABLE)
	var/datum/faction/excelsior/commies = get_faction_by_id(FACTION_EXCELSIOR)
	icon_state = "redirector_reboot"
	for (var/datum/antagonist/A in commies.members)
		to_chat(A.owner.current, SPAN_EXCEL_NOTIF("\The [src] needs to be rebooted with new information! Head over to it and place your hands on it."))

/obj/machinery/excelsior_redirector/proc/doReboot(mob/living/carbon/human/user)
	if(user.stat || user.incapacitated() || !user.Adjacent(src))
		return
	to_chat(user, SPAN_NOTICE("You start rebooting \the [src] with new information. Your hands start moving by themselves like they're remotely guided to input new information."))
	if(do_after(user, 15 SECONDS, src))
		to_chat(user, SPAN_NOTICE("You succesfully reboot \the [src]. Your hands are no longer moving on their own."))
		deltimer(rebootTimer)
		var/datum/faction/excelsior/commies = get_faction_by_id(FACTION_EXCELSIOR)
		for (var/datum/antagonist/A in commies.members)
			to_chat(A.owner.current, SPAN_EXCEL_NOTIF("\The [src] has been rebooted by [user]. It will need another reboot in 3 minutes."))
		addtimer(CALLBACK(src, PROC_REF(requestReboot)),3 MINUTES)
		icon_state = "redirector_running"
	else
		to_chat(user, SPAN_DANGER("Your hands suddenly stop moving. \the [src] wasn't rebooted."))

/obj/machinery/excelsior_redirector/proc/tryRuin(mob/living/carbon/human/user)
	if(user.stat || user.incapacitated() || !user.Adjacent(src))
		return
	to_chat(user, SPAN_WARNING("You start bending \the [src]'s antenna! It's quite tough..."))
	var/datum/faction/excelsior/commies = get_faction_by_id(FACTION_EXCELSIOR)
	for (var/datum/antagonist/A in commies.members)
		to_chat(A.owner.current, SPAN_EXCEL_NOTIF("The [src]'s antenna is being bent by someone! Stop them."))
	if(do_after(user, 1 MINUTE, src))
		stopRedirecting()
		antennaBent = TRUE
		icon_state = "redirector_bent"
		/*
		var/datum/faction/excelsior/commies = get_faction_by_id(FACTION_EXCELSIOR)
		for (var/datum/antagonist/A in commies.members)
			to_chat(A.owner.current, SPAN_NOTICE("The [src]'s antenna has been bent! Progress has been reset and it needs to be fixed!"))
		*/
	else
		to_chat(user, SPAN_NOTICE("You stop bending the antenna, it snaps back to its original form."))

/obj/machinery/excelsior_redirector/proc/finishRedirecting()
	icon_state = "redirector_finished"
	flick(icon, "redirector_finishing")
	spawn(12 SECONDS)
		SSticker.excelsior_hijacking = 2

/obj/machinery/excelsior_redirector/proc/stopRedirecting()
	deltimer(redirectTimer)
	if(rebootTimer)
		deltimer(rebootTimer)
	SSticker.excelsior_hijacking = 0
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
	security_state.set_security_level(oldSecurityLevel, force_change = TRUE)
	var/datum/faction/excelsior/commies = get_faction_by_id(FACTION_EXCELSIOR)
	for (var/datum/antagonist/A in commies.members)
		to_chat(A.owner.current, SPAN_EXCEL_NOTIF("\The [src]'s redirect has been stopped! You have failed the commune!"))
		var/mob/living/carbon/human/unworthy = A.owner.current
		var/obj/item/implant/excelsior/implnt = locate(/obj/item/implant/excelsior/) in unworthy
		if(implnt)
			implnt.execute()
	icon_state = "redirector_anchored"
