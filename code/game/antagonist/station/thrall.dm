/datum/antagonist/thrall
	role_text = "Thrall"
	role_text_plural = "Thralls"
	welcome_text = "Your mind is no longer solely your own..."
	id = ROLE_THRALL
	flags = ANTAG_IMPLANT_IMMUNE
	antaghud_indicator = "hudmalai"

	var/list/thrall_controllers = list()

/datum/antagonist/thrall/create_objectives()
	var/mob/living/controller = thrall_controllers["\ref[owner]"]
	if(!controller)
		return // Someone is playing with buttons they shouldn't be.
	var/datum/objective/obey = new
	obey.owner = owner
	obey.explanation_text = "Obey your master, [controller.real_name], in all things."
	owner.individual_objectives |= obey

/datum/antagonist/thrall/create_antagonist(datum/mind/owner, ignore_role, do_not_equip, move_to_spawn, do_not_announce, preserve_appearance, mob/new_controller)
	if(!new_controller)
		return 0
	. = ..()
	if(.) thrall_controllers["\ref[owner]"] = new_controller

/datum/antagonist/thrall/greet()
	. = ..()
	var/mob/living/controller = thrall_controllers["\ref[owner]"]
	if(controller)
		to_chat(owner, SPAN_DANGER("Your will has been subjugated by that of [controller.real_name]. Obey them in all things."))
