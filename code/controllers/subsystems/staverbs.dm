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
	if(isnull(all_verbs69path69))
		all_verbs69path69= new path
	SV = all_verbs69path69
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
	if(!(target in69iew(user)))
		to_chat(user, SPAN_WARNING("You're too far from 69saved_name69"))
		return FALSE

	if(base_range == RANGE_ADJACENT)
		if(!target.Adjacent(user))
			to_chat(user, SPAN_WARNING("You should be adjacent to 69target69"))
			return FALSE
	else
		if(get_dist(user, target) > base_range)
			to_chat(user, SPAN_WARNING("You're too far from 69target69"))
			return FALSE

	if(user.stats.getStat(required_stat) <69inimal_stat)
		switch(required_stat)
			if(STAT_MEC)
				to_chat(user, SPAN_WARNING("You don't know enough about engineering to do that!"))
			if(STAT_BIO)
				to_chat(user, SPAN_WARNING("You don't know enough about69edicine to do that!"))
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



// Atom part //
/atom
	var/list/statverbs

/atom/Initialize()
	. = ..()
	initalize_statverbs()

/atom/Destroy()
	. = ..()
	if(statverbs)
		statverbs.Cut()

/atom/proc/initalize_statverbs()
	var/list/paths = statverbs
	statverbs = new
	for(var/path in paths)
		add_statverb(path)

/atom/proc/add_statverb(path)
	if(!statverbs)
		statverbs = new
	var/datum/statverb/SV = path
	statverbs69initial(SV.required_stat)69 = path

/atom/proc/remove_statverb(path)
	statverbs -= path



/atom/proc/show_stat_verbs()
	if(statverbs && statverbs.len)
		. = "Apply: "
		for(var/stat in statverbs)
			. += " <a href='?src=\ref69src69;statverb=69stat69;obj_name=69src69'>69stat69</a>"

/atom/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list69"statverb"69)
		SSstatverbs.call_verb(usr, src, src.statverbs69href_list69"statverb"6969, href_list69"obj_name"69)


// Example

/turf/simulated/floor/initalize_statverbs()
	if(flooring && (flooring.flags & TURF_REMOVE_CROWBAR))
		add_statverb(/datum/statverb/remove_plating)

/datum/statverb/remove_plating
	name = "Remove plating"
	required_stat = STAT_ROB
	minimal_stat  = STAT_LEVEL_ADEPT

/datum/statverb/remove_plating/action(mob/user, turf/simulated/floor/target)
	if(target.flooring && target.flooring.flags & TURF_REMOVE_CROWBAR)
		user.visible_message(
			SPAN_DANGER("69user69 grabbed the edges of 69target69 with their hands!"),
			"You grab the edges of 69target69 with your hands"
		)
		if(do_mob(user, target, target.flooring.removal_time * 3))
			user.visible_message(
				SPAN_DANGER("69user69 roughly tore plating off from 69target69!"),
				"You tore the plating off from 69target69"
			)
			target.make_plating(FALSE)
		else
			var/target_name = target ? "69target69" : "the floor"
			user.visible_message(
				SPAN_DANGER("69user69 stopped tearing the plating off from 69target_name69!"),
				"You stop tearing plating off from 69target_name69"
			)

/obj/machinery/computer/rdconsole/initalize_statverbs()
	if(access_research_equipment in req_access)
		add_statverb(/datum/statverb/hack_console)

/datum/statverb/hack_console
	name = "Hack console"
	required_stat = STAT_COG
	minimal_stat  = STAT_LEVEL_ADEPT

/datum/statverb/hack_console/action(mob/user, obj/machinery/computer/rdconsole/target)
	if(target.hacked == 1)
		user.visible_message(
			SPAN_WARNING("69target69 is already hacked!")
		)
		return
	if(target.hacked == 0)
		var/timer = 220 - (user.stats.getStat(STAT_COG) * 2)
		var/datum/repeating_sound/keyboardsound = new(30, timer, 0.15, target, "keyboard", 80, 1)
		user.visible_message(
			SPAN_DANGER("69user69 begins hacking into 69target69!"),
			"You start hacking the access requirement on 69target69"
		)
		if(do_mob(user, target, timer))
			keyboardsound.stop()
			keyboardsound = null
			target.req_access.Cut()
			target.hacked = 1
			user.visible_message(
				SPAN_DANGER("69user69 breaks the access encryption on 69target69!"),
				"You break the access encryption on 69target69"
			)
		else
			keyboardsound.stop()
			keyboardsound = null
			var/target_name = target ? "69target69" : "the research console"
			user.visible_message(
				SPAN_DANGER("69user69 stopped hacking into 69target_name69!"),
				"You stop hacking into 69target_name69."
			)

/obj/item/modular_computer/initalize_statverbs()
	if(enabled == 0)
		add_statverb(/datum/statverb/fix_computer)

/datum/statverb/fix_computer
	name = "Fix computer"
	required_stat = STAT_COG
	minimal_stat  = STAT_LEVEL_ADEPT

/datum/statverb/fix_computer/action(mob/user, obj/item/modular_computer/target)
	if(target.hard_drive.damage < 100)
		user.visible_message(
			SPAN_WARNING("69target69 doesn't need repairs!")
		)
		return
	var/timer = 160 - (user.stats.getStat(STAT_COG) * 2)
	if(target.hard_drive.damage == 100)
		var/datum/repeating_sound/keyboardsound = new(30, timer, 0.15, target, "keyboard", 80, 1)
		user.visible_message(
			SPAN_NOTICE("You begin repairing 69target69."),
		)
		if(do_mob(user, target, timer))
			keyboardsound.stop()
			keyboardsound = null
			target.hard_drive.damage = 0
			target.hard_drive.install_default_files()
			target.update_icon()
			user.visible_message(
				SPAN_NOTICE("You69anage to repair 69target69, but the harddrive was corrupted! Only default programs were restored."),
			)
		else
			keyboardsound.stop()
			keyboardsound = null
			var/target_name = target ? "69target69" : "the computer"
			user.visible_message(
				SPAN_NOTICE("You stop repairing 69target_name69."),
			)