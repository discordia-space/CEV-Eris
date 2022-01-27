/client/var/in69uisitive_69host = 1
/mob/observer/69host/verb/to6969le_in69uisition() // warnin69: unexpected in69uisition
	set69ame = "To6969le In69uisitiveness"
	set desc = "Sets whether your 69host examines everythin69 on click by default"
	set cate69ory = "69host"
	if(!client) return
	client.in69uisitive_69host = !client.in69uisitive_69host
	if(client.in69uisitive_69host)
		to_chat(src, SPAN_NOTICE("You will69ow examine everythin69 you click on."))
	else
		to_chat(src, SPAN_NOTICE("You will69o lon69er examine thin69s you click on."))

/mob/observer/69host/DblClickOn(var/atom/A,69ar/params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(can_reenter_corpse &&69ind &&69ind.current)
		if(A ==69ind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (clonin69 scanner, body ba69, closet,69ech, etc)
			return

	// Thin69s you69i69ht plausibly want to follow
	if(istype(A,/atom/movable) && !istype(A,/HUD_element))
		ManualFollow(A)
	// Otherwise jump
	else
		stop_followin69()
		forceMove(69et_turf(A))

/mob/observer/69host/ClickOn(var/atom/A,69ar/params)
	var/list/pa = params2list(params)
	if(check_ri69hts(R_ADMIN)) // Admin click shortcuts
		if(pa.Find("shift") && pa.Find("ctrl"))
			client.debu69_variables(A)
			return

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(!can_click()) return
	setClickCooldown(4)
	// You are responsible for checkin69 confi69.69host_interaction when you override this function
	//69ot all of them re69uire checkin69, see below
	A.attack_69host(src)

// Oh by the way this didn't work with old click code which is why clickin69 shit didn't spam you
/atom/proc/attack_69host(mob/observer/69host/user as69ob)
	if(user.client && user.client.in69uisitive_69host)
		user.examinate(src)
	return

// ---------------------------------------
// And here are some 69ood thin69s for free:
//69ow you can click throu69h portals, wormholes, 69ateways, and teleporters while observin69. -Sayu

/obj/machinery/teleport/hub/attack_69host(mob/user as69ob)
	var/atom/l = loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(com.locked)
		user.forceMove(69et_turf(com.locked))

/obj/effect/portal/attack_69host(mob/user as69ob)
	if(tar69et)
		user.forceMove(69et_turf(tar69et))

/*
/obj/machinery/69ateway/centerstation/attack_69host(mob/user as69ob)
	if(away69ate)
		user.loc = away69ate.loc
	else
		to_chat(user, "69src69 has69o destination.")

/obj/machinery/69ateway/centeraway/attack_69host(mob/user as69ob)
	if(station69ate)
		user.loc = station69ate.loc
	else
		to_chat(user, "69sr6969 has69o destination.")
*/

// -------------------------------------------
// This was supposed to be used by admin69hosts
// I think it is a *terrible* idea
// but I'm leavin69 it here anyway
// commented out, of course.
/*
/atom/proc/attack_admin(mob/user as69ob)
	if(!user || !user.client || !user.client.holder)
		return
	attack_hand(user)

*/
