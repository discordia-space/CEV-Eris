/mob/living/silicon/ai/proc/show_laws_verb()
	set category = "Silicon Commands"
	set name = "Show Laws"
	src.show_laws()

/mob/living/silicon/proc/deadchat_lawchange()
	var/list/the_laws = laws.get_law_list(include_zeroth = TRUE)
	var/lawtext = the_laws.Join("<br/>")
	deadchat_broadcast("'s <b>laws were changed.</b> <a href='byond://?src=[REF(src)]&dead=1&printlawtext=[url_encode(lawtext)]'>View</a>", span_name("[src]"), follow_target=src, message_type=DEADCHAT_LAWCHANGE)

/mob/living/silicon/ai/show_laws(everyone = 0)
	var/who

	if (everyone)
		who = world
	else
		who = src
		to_chat(who, "<b>Obey these laws:</b>")

	src.laws_sanity_check()
	src.laws.show_laws(who)

/mob/living/silicon/ai/add_ion_law(law)
	..()
	for(var/mob/living/silicon/robot/R in SSmobs.mob_list)
		if(R.lawupdate && (R.connected_ai == src))
			R.show_laws()

/mob/living/silicon/ai/proc/ai_checklaws()
	set category = "Silicon Commands"
	set name = "State Laws"
	open_subsystem(/datum/nano_module/law_manager)
