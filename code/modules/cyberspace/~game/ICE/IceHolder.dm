/mob/observer/cyber_entity/IceHolder
	icon = 'icons/obj/cyberspace/ices/wild.dmi'

	var/viewRange = 4 //how far the mob AI can see

	var/move_to_delay = 8
	var/distance_to_apc = 3

	var/stance = ICE_STANCE_OVERWATCH //current mob AI state

	var/list/states = list(
		// "[ICE_STANCE_OVERWATCH]" = STATE_ICON_COLOR("", CYBERSPACE_MAIN_COLOR, TRUE), // Ice stay idle
		// "[ICE_STANCE_ATTACK]" = STATE_ICON_COLOR("", CYBERSPACE_SECURITY, TRUE), // Ice want to attack
		// "[ICE_STANCE_ATTACKING]" = STATE_ICON_COLOR("", CYBERSPACE_SECURITY, TRUE), // Ice attacking someone right now
		// "[ICE_STANCE_DEAD]" = STATE_ICON_COLOR("", CYBERSPACE_SHADOW_COLOR, TRUE), // Dead ice
	)

	var/atom/target_mob //currently chased target

	var/obj/machinery/power/apc/MyFirewall

	var/AI_on = TRUE

/mob/observer/cyber_entity/IceHolder/Initialize()
	. = ..()
	CollectStates()

/mob/observer/cyber_entity/IceHolder/proc/CollectStates() //Abstract proc for creating .var/list/states
	update_icon()

/mob/observer/cyber_entity/IceHolder/Death()
	AI_on = FALSE
	stance = ICE_STANCE_DEAD
	. = ..()

/mob/observer/cyber_entity/IceHolder/proc/check_AI_act()
	if(!AI_on || !canmove || client)
		stance = ICE_STANCE_OVERWATCH
		target_mob = null
		walk(src, 0)
		update_icon()
		return
	return 1

/mob/observer/cyber_entity/IceHolder/Life()
	. = ..()
	if(stance != ICE_STANCE_DEAD && check_AI_act())
		if(CyberAvatar.Subroutines.IsAllSubroutinesLocked(CyberAvatar.Subroutines.Attack) && !Hacked)
			loseTarget()
			set_glide_size(DELAY2GLIDESIZE(move_to_delay))
			walk_to(src, MyFirewall, distance_to_apc, move_to_delay)
		else
			switch(stance)
				if(ICE_STANCE_OVERWATCH)
					target_mob = findTarget()
					if(target_mob)
						stance = ICE_STANCE_ATTACK
					else
						walk(src, 0)
				if(ICE_STANCE_ATTACK)
					stance = ICE_STANCE_ATTACKING
					set_glide_size(DELAY2GLIDESIZE(move_to_delay))
					walk_to(src, target_mob, 1, move_to_delay)
				if(ICE_STANCE_ATTACKING)
					prepareAttackOnTarget()
	update_icon()

/mob/observer/cyber_entity/IceHolder/update_icon()
	. = ..()
	cut_overlays()
	if(length(states) && (stance in states))
		var/image/parsematerial = states[stance]
		if(istype(parsematerial))
			if(parsematerial.icon_state)
				SetIconState(parsematerial.icon_state)
			if(parsematerial.icon)
				SetIcon(parsematerial.icon)
			if(length(parsematerial.overlays))
				set_overlays(parsematerial.overlays)
			if(parsematerial.color)
				CyberAvatar.SetColor(parsematerial.color)
			CyberAvatar.UpdateIcon()
		else if(istext(parsematerial))
			SetIconState(parsematerial)

