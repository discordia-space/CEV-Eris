/client/var/inquisitive_ghost = 1
/mob/observer/ghost/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Ghost"
	if(!client) return
	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		to_chat(src, SPAN_NOTICE("You will now examine everything you click on."))
	else
		to_chat(src, SPAN_NOTICE("You will no longer examine things you click on."))

/mob/observer/ghost/DblClickOn(atom/A, params)
	// if(check_click_intercept(params, A))
	// 	return
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	if(can_reenter_corpse && mind?.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse() // (body bag, closet, mech, etc)
			return // seems legit.

	// Things you might plausibly want to follow
	if(ismovable(A) && !istype(A, /HUD_element) && !istype(A, /obj/screen)) // pepelaugh old code
		ManualFollow(A)

	// Otherwise jump
	else if(A.loc)
		forceMove(get_turf(A))
		// update_parallax_contents()

/mob/observer/ghost/ClickOn(atom/A, params)
	// if(check_click_intercept(params,A))
	// 	return

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, "shift"))
		if(LAZYACCESS(modifiers, "middle"))
			ShiftMiddleClickOn(A)
			return
		if(LAZYACCESS(modifiers, "ctrl"))
			CtrlShiftClickOn(A)
			if(check_rights(R_ADMIN))
				client.debug_variables(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, "middle"))
		MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, "alt"))
		// AltClickNoInteract(src, A)
		return
	if(LAZYACCESS(modifiers, "ctrl"))
		CtrlClickOn(A)
		return

	if(!can_click())
		return
	setClickCooldown(4)
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/observer/ghost/user as mob)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_GHOST, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(user.client)
		// if(user.gas_scan && atmosanalyzer_scan(user, src))
		// 	return TRUE
		// else if(isAdminGhostAI(user))
		// 	attack_ai(user) else
		if(user.client.inquisitive_ghost)
			user.examinate(src)
	return FALSE

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/machinery/teleport/hub/attack_ghost(mob/user)
	var/atom/l = loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(com.locked)
		user.forceMove(get_turf(com.locked))
	return ..()

/obj/effect/portal/attack_ghost(mob/user)
	if(target)
		user.forceMove(get_turf(target))
	return ..()

/*
dumbass just modify the parent proc (gateway)
/obj/machinery/gateway/centerstation/attack_ghost(mob/user as mob)
	if(awaygate)
		user.loc = awaygate.loc
	else
		to_chat(user, "[src] has no destination.")

/obj/machinery/gateway/centeraway/attack_ghost(mob/user as mob)
	if(stationgate)
		user.loc = stationgate.loc
	else
		to_chat(user, "[src] has no destination.")
*/
