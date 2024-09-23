// File contains:
// - statverbs subsystem
// - statverb datum defenation
// - statverb related atom code

SUBSYSTEM_DEF(statverbs)
	name = "statverbs"
	flags = SS_NO_INIT|SS_NO_FIRE

	var/list/all_verbs = list()

/datum/controller/subsystem/statverbs/proc/call_verb(user, target, path, tmp_name)
	var/datum/statverb/SV
	if(isnull(all_verbs[path]))
		all_verbs[path]= new path
	SV = all_verbs[path]
	SV.try_action(user, target, tmp_name)


// Statverb datum //
/datum/statverb
	var/name
	var/required_stat = STAT_MEC
	var/base_range = RANGE_ADJACENT	//maximum distance or RANGE_ADJACENT
	var/minimal_stat = 0


/datum/statverb/proc/try_action(mob/living/user, atom/target, saved_name = "target")
	if(!istype(user))
		return
	if(!(target in view(user)))
		to_chat(user, SPAN_WARNING("You're too far from [saved_name]"))
		return FALSE

	if(base_range == RANGE_ADJACENT)
		if(!target.Adjacent(user))
			to_chat(user, SPAN_WARNING("You should be adjacent to [target]"))
			return FALSE
	else
		if(get_dist(user, target) > base_range)
			to_chat(user, SPAN_WARNING("You're too far from [target]"))
			return FALSE

	if(user.stats.getStat(required_stat) < minimal_stat)
		switch(required_stat)
			if(STAT_MEC)
				to_chat(user, SPAN_WARNING("You don't know enough about engineering to do that!"))
			if(STAT_BIO)
				to_chat(user, SPAN_WARNING("You don't know enough about medicine to do that!"))
			if(STAT_TGH)
				to_chat(user, SPAN_WARNING("You're not tough enough to do that!"))
			if(STAT_ROB)
				to_chat(user, SPAN_WARNING("You're not strong enough to do that!"))
			if(STAT_COG)
				to_chat(user, SPAN_WARNING("You're not smart enough to do that!"))
			if(STAT_VIG)
				to_chat(user, SPAN_WARNING("You're not perceptive enough to do that!"))
		return FALSE

	action(user, target)

/datum/statverb/proc/action(mob/user, atom/target)

/atom/proc/add_statverb(path)
	if(!statverbs)
		statverbs = new
	var/datum/statverb/SV = path
	statverbs[initial(SV.required_stat)] = path

/atom/proc/remove_statverb(path)
	statverbs -= path

/atom/proc/show_stat_verbs()
	if(statverbs && statverbs.len)
		. = "Apply: "
		for(var/stat in statverbs)
			. += " <a href='?src=\ref[src];statverb=[stat];obj_name=[src]'>[stat]</a>"

/atom/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["statverb"])
		SSstatverbs.call_verb(usr, src, src.statverbs[href_list["statverb"]], href_list["obj_name"])

/datum/statverb/remove_plating
	name = "Remove plating"
	required_stat = STAT_ROB
	minimal_stat  = STAT_LEVEL_ADEPT

/datum/statverb/remove_plating/action(mob/user, turf/floor/target)
	if(target.flooring && target.flooring.flags & TURF_REMOVE_CROWBAR)
		user.visible_message(
			SPAN_DANGER("[user] grabbed the edges of [target] with their hands!"),
			"You grab the edges of [target] with your hands"
		)
		if(do_mob(user, target, target.flooring.removal_time * 3))
			user.visible_message(
				SPAN_DANGER("[user] roughly tore plating off from [target]!"),
				"You tore the plating off from [target]"
			)
			target.make_plating(FALSE)
		else
			var/target_name = target ? "[target]" : "the floor"
			user.visible_message(
				SPAN_DANGER("[user] stopped tearing the plating off from [target_name]!"),
				"You stop tearing plating off from [target_name]"
			)

/datum/statverb/hack_console
	name = "Hack console"
	required_stat = STAT_COG
	minimal_stat  = STAT_LEVEL_ADEPT

/datum/statverb/hack_console/action(mob/user, obj/machinery/target)
	if(target.hacked)
		user.visible_message(
			SPAN_WARNING("[target] is already hacked!")
		)
		return
	if(!target.hacked)
		var/timer = 220 - (user.stats.getStat(STAT_COG) * 2)
		var/datum/repeating_sound/keyboardsound = new(30, timer, 0.15, target, "keyboard", 80, 1)
		user.visible_message(
			SPAN_DANGER("[user] begins hacking into [target]!"),
			"You start hacking the access requirement on [target]"
		)
		if(do_mob(user, target, timer))
			keyboardsound.stop()
			keyboardsound = null
			target.req_access.Cut()
			target.hacked = TRUE
			user.visible_message(
				SPAN_DANGER("[user] breaks the access encryption on [target]!"),
				"You break the access encryption on [target]"
			)
			if(istype(target, /obj/machinery/dna))
				var/obj/machinery/dna/D = target
				D.hacked = FALSE
				D.on_hacked()
		else
			keyboardsound.stop()
			keyboardsound = null
			var/target_name = target ? "[target]" : "the research console"
			user.visible_message(
				SPAN_DANGER("[user] stopped hacking into [target_name]!"),
				"You stop hacking into [target_name]."
			)

/datum/statverb/fix_computer
	name = "Fix computer"
	required_stat = STAT_COG
	minimal_stat  = STAT_LEVEL_ADEPT

/datum/statverb/fix_computer/action(mob/user, obj/item/modular_computer/target)
	if(target.hard_drive.damage < 100)
		user.visible_message(
			SPAN_WARNING("[target] doesn't need repairs!")
		)
		return
	var/timer = 160 - (user.stats.getStat(STAT_COG) * 2)
	if(target.hard_drive.damage == 100)
		var/datum/repeating_sound/keyboardsound = new(30, timer, 0.15, target, "keyboard", 80, 1)
		user.visible_message(
			SPAN_NOTICE("You begin repairing [target]."),
		)
		if(do_mob(user, target, timer))
			keyboardsound.stop()
			keyboardsound = null
			target.hard_drive.damage = 0
			target.hard_drive.install_default_files()
			target.update_icon()
			user.visible_message(
				SPAN_NOTICE("You manage to repair [target], but the harddrive was corrupted! Only default programs were restored."),
			)
		else
			keyboardsound.stop()
			keyboardsound = null
			var/target_name = target ? "[target]" : "the computer"
			user.visible_message(
				SPAN_NOTICE("You stop repairing [target_name]."),
			)

/datum/statverb/connect_conduit //Connects or disconnects conduits of a shield generator or long range scanner
	name = "Connect conduit"
	required_stat = STAT_MEC
	minimal_stat  = STAT_LEVEL_ADEPT

/datum/statverb/connect_conduit/action(mob/user, obj/machinery/power/conduit/conduit)
	var/timer = 30 * (1 - user.stats.getStat(STAT_MEC) / 100) SECONDS
	if(!conduit.base) //we try to connect it
		var/turf/T = get_step(conduit, conduit.dir)
		var/obj/machinery/power/shipside/target = locate(/obj/machinery/power/shipside/) in T
		if(!target)
			user.visible_message(self_message = SPAN_NOTICE("There is nothing to [conduit] to."))
			return FALSE
		else
			if(!target.tendrils_deployed && target.tendrils.len > 0)
				if(!target.toggle_tendrils(TRUE)) //fail if conduits are not deployed and can not be deployed
					return
			if(target.tendrils.len < 1) //no conduits?
				target.tendrils_deployed = TRUE
			var/datum/repeating_sound/wrenchsound = new(30, timer, 0.15, conduit, 'sound/items/Ratchet.ogg', 80, 1)
			user.visible_message(SPAN_NOTICE("[user] starts to connect various pipes and wires between [conduit] and [target]."), 
			"You start to connect various pipes and wires between [conduit] and [target].")
			if(do_mob(user, conduit, timer))
				wrenchsound.stop()
				qdel(wrenchsound)
				conduit.connect(target)
				user.visible_message(SPAN_NOTICE("[user] successfully connected [conduit] to the [target]!"), 
				"You successfully conneced [conduit] to the [target]!")
			else
				wrenchsound.stop()
				qdel(wrenchsound)
				user.visible_message(SPAN_NOTICE("[user] stopped connecting [conduit] and [target]."), 
				"You stopped connecting [conduit] and [target].")
	else //disconnection
		var/datum/repeating_sound/wrenchsound = new(30, timer, 0.15, conduit, 'sound/items/Ratchet.ogg', 80, 1)
		user.visible_message(SPAN_NOTICE("[user] attempts to disconnect [conduit] from the [conduit.base]."), 
		"You attempt to disconnect [conduit] from the [conduit.base].")
		if(do_mob(user, conduit, timer))
			wrenchsound.stop()
			qdel(wrenchsound)
			user.visible_message(SPAN_NOTICE("[user] successfully disconnected [conduit] from the [conduit.base]!"), 
			"You successfully disconneced [conduit] from the [conduit.base]!")
			if(conduit.base.tendrils_deployed == TRUE)
				conduit.disconnect()
		else
			wrenchsound.stop()
			qdel(wrenchsound)
			user.visible_message(SPAN_NOTICE("[user] stopped connecting [conduit] and [conduit.base]."), 
			"You stopped connecting [conduit] and [conduit.base].")