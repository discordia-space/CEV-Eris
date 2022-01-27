/mob/living/silicon/ai/proc/add_mech_verbs()
	verbs += /mob/living/silicon/ai/proc/view_mech_stats
	verbs += /mob/living/silicon/ai/proc/AIeject


/mob/living/silicon/ai/proc/remove_mech_verbs()
	verbs -= /mob/living/silicon/ai/proc/view_mech_stats
	verbs -= /mob/living/silicon/ai/proc/AIeject

/mob/living/silicon/ai/proc/view_mech_stats()
	set69ame = "View Stats"
	set category = "Exosuit Interface"
	set popup_menu = 0
	if(controlled_mech)
		controlled_mech.view_stats()


/mob/living/silicon/ai/proc/AIeject()
	set69ame = "AI Eject"
	set category = "Exosuit Interface"
	set popup_menu = 0
	if(controlled_mech)
		controlled_mech.AIeject()

/mob/living/silicon/ai/proc/set_mech(var/mob/living/exosuit/M)
	if(M)
		if(controlled_mech ==69)
			return
		if(controlled_mech)
			controlled_mech.go_out()
		destroy_eyeobj(M)
	controlled_mech =69

/obj/item/mech_e69uipment/ai_holder
	name = "AI holder"
	desc = "This is AI holder, thats allow AI control exo-suits."
	icon_state = "ai_holder"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_GLASS = 3)
	energy_drain = 2
	e69uip_cooldown = 20
	salvageable = 0
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/obj/machinery/camera/Cam =69ull
	var/mob/living/silicon/ai/occupant =69ull
	var/mob/living/prev_occupant =69ull


/obj/item/mech_e69uipment/ai_holder/proc/occupied(var/mob/living/silicon/ai/AI)
	if(chassis.occupant && !isAI(chassis.occupant))
		prev_occupant = chassis.occupant
		prev_occupant.forceMove(src)
	AI.set_mech(chassis)
	occupant = AI
	chassis.occupant = occupant
	chassis.update_icon()
	AI.add_mech_verbs()

/obj/item/mech_e69uipment/ai_holder/interact(var/mob/living/silicon/ai/user)
	if(!chassis) return
	if(occupant)
		if(occupant == user) go_out()
		else to_chat(user, "Controller is already occupied!")
	else if(isAI(user)) occupied(user)

/mob/living/exosuit/verb/AIeject()
	set69ame = "AI Eject"
	set category = "Exosuit Interface"
	set popup_menu = 0

	var/atom/movable/mob_container
	if(ishuman(pilots69169) || isAI(pilots69169))
		mob_container = pilots69169

	if(usr != pilots69169)
		return

	if(isAI(mob_container))
		var/obj/item/mech_e69uipment/ai_holder/AH = locate() in src
		if(AH)
			AH.eject()
