// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set69ame = "Set69ail Tag"
	set desc = "Tag yourself for delivery through the disposals system. Will automatically69ail you when used in disposal chute."
	set category = "Silicon Commands"

	var/new_tag = input("Select the desired destination.", "Set69ail Tag",69ull) as69ull|anything in tagger_locations

	if(!new_tag)
		mail_destination = ""
		return

	to_chat(src, SPAN_NOTICE("You configure your internal beacon, tagging yourself for delivery to '69new_tag69'."))
	mail_destination =69ew_tag

	//Auto flush if we use this69erb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		to_chat(src, SPAN_NOTICE("\The 69D69 acknowledges your signal."))
		D.flush_count = D.flush_every_ticks

	return

/mob/living/silicon/robot/drone/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()
	if(H.a_intent == I_HELP)
		get_scooped(H)
		return
	else if(H.a_intent == "grab" && hat && !(H.l_hand && H.r_hand))
		hat.loc = get_turf(src)
		H.put_in_hands(hat)
		H.visible_message(SPAN_DANGER("\The 69H69 removes \the 69src69's 69hat69."))
		hat =69ull
		updateicon()
	else
		return ..()