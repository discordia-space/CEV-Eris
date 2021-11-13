#define STATE_WORK_STABLE 1
#define STATE_UNPOWERED 0

CYBERAVATAR_INITIALIZATION(/obj/machinery/cyber_security_server, CYBERSPACE_SECURITY)
/obj/machinery/cyber_security_server/CyberAvatar_prefab = /datum/CyberSpaceAvatar/interactable/cybersecurity_server
/obj/machinery/cyber_security_server
	name = "\the cybersecurity server"
	icon = 'icons/obj/cyberspace/servers.dmi'
	var/base_state = "os"
	icon_state = "os"
	var/active = STATE_WORK_STABLE

/obj/machinery/cyber_security_server/Initialize()
	. = ..()
	update_icon()

/obj/machinery/cyber_security_server/on_update_icon()
	. = ..()
	icon_state = base_state
	if(istype(CyberAvatar))
		CyberAvatar.icon_state = "[base_state]_avatar"

/*
/obj/machinery/cyber_security_server/power_change()
	. = ..()
	if(stat & NOPOWER || stat & BROKEN)
		active = STATE_UNPOWERED
	else
		active = STATE_WORK_STABLE
*/

/obj/machinery/cyber_security_server/proc/PreventAPCHack(mob/observer/cyber_entity/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	// Return TRUE if prevented
	. = (active == STATE_WORK_STABLE)

/*
/obj/machinery/cyber_security_server/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(active == STATE_WORK_STABLE)
		to_chat(user, "[src] blinks.")
		
/obj/machinery/cyber_security_server/attack_hand(mob/user)
	. = ..()
	if(panel_open)
		to_chat(user, SPAN_WARNING("You are tring to [active ? "disable" : "re engage"] cyberspace security protocols of [name]."))
		var/cog_mod = 10
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			cog_mod /= max(H.stats.getStat(STAT_COG), 10)
		if(do_after(user, 3 SECONDS * cog_mod, src))
			active = !active
		update_icon()
*/

/datum/CyberSpaceAvatar/interactable/cybersecurity_server
	icon_file = 'icons/obj/cyberspace/servers.dmi'
	icon_state = "os_avatar"

/datum/CyberSpaceAvatar/interactable/cybersecurity_server/HackingTry(mob/observer/cyber_entity/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = ..() && do_after(user, 10 SECONDS, Owner,\
			needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE,\
			target_allowed_to_move = TRUE, move_range = 4)
	

/datum/CyberSpaceAvatar/interactable/cybersecurity_server/Hacked(mob/observer/cyber_entity/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = ..()
	if(Owner)
		explosion(Owner.loc, 0, 0, 1)
		qdel(Owner)
		qdel(src)
