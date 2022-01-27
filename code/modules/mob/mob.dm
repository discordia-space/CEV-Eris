/mob/Destroy()//This69akes sure that69obs with clients/keys are69ot just deleted from the game.
	STOP_PROCESSING(SSmobs, src)
	GLOB.dead_mob_list -= src
	GLOB.living_mob_list -= src
	GLOB.mob_list -= src
	unset_machine()
	qdel(hud_used)
	if(client)
		for(var/atom/movable/AM in client.screen)
			qdel(AM)
		client.screen = list()

	ghostize()
	..()
	return QDEL_HINT_HARDDEL

/mob/proc/despawn()
	return

/mob/get_fall_damage(var/turf/from,69ar/turf/dest)
	return 0

/mob/fall_impact(var/turf/from,69ar/turf/dest)
	return

/mob/proc/take_overall_damage(var/brute,69ar/burn,69ar/used_weapon =69ull)
	return

/mob/Initialize()
	START_PROCESSING(SSmobs, src)
	if(stat == DEAD)
		GLOB.dead_mob_list += src
	else
		GLOB.living_mob_list += src
	GLOB.mob_list += src
	move_intent = decls_repository.get_decl(move_intent)
	. = ..()

/mob/proc/show_message(msg, type, alt, alt_type)//Message, type of69essage (1 or 2), alternative69essage, alt69essage type (1 or 2)

	if(!client)	return

	if (type)
		if(type & 1 && (sdisabilities & BLIND || blinded || paralysis) )//Vision related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
		if (type & 2 && (sdisabilities & DEAF || ear_deaf))//Hearing related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
				if ((type & 1 && sdisabilities & BLIND))
					return
	// Added69oice69uffling for Issue 41.
	if(stat == UNCONSCIOUS || sleeping > 0)
		to_chat(src, "<I>... You can almost hear someone talking ...</I>")
	else
		to_chat(src,69sg)
	return

// Show a69essage to all69obs and objects in sight of this one
// This would be for69isible actions by the src69ob
//69essage is the69essage output to anyone who can see e.g. "69src69 does something!"
// self_message (optional) is what the src69ob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"

/mob/visible_message(var/message,69ar/self_message,69ar/blind_message,69ar/range = world.view)
	var/list/messageturfs = list()//List of turfs we broadcast to.
	var/list/messagemobs = list()//List of living69obs69earby who can hear it, and distant ghosts who've chosen to hear it
	for (var/turf in69iew(range, get_turf(src)))

		messageturfs += turf

	for(var/A in GLOB.player_list)
		var/mob/M = A
		if (QDELETED(M))
			GLOB.player_list -=69
			continue
		if (!M.client || istype(M, /mob/new_player))
			continue
		if(get_turf(M) in69essageturfs)
			messagemobs +=69

	for(var/A in69essagemobs)
		var/mob/M = A
		if(self_message &&69==src)
			M.show_message(self_message, 1, blind_message, 2)
		else if(M.see_invisible < invisibility)  // Cannot69iew the invisible, but you can hear it.
			if(blind_message)
				M.show_message(blind_message, 2)
		else
			M.show_message(message, 1, blind_message, 2)


// Returns an amount of power drawn from the object (-1 if it's69ot69iable).
// If drain_check is set it will69ot actually drain power, just return a69alue.
// If surge is set, it will destroy/damage the recipient and69ot return any power.
//69ot sure where to define this, so it can sit here for the rest of time.
/atom/proc/drain_power(var/drain_check,var/surge,69ar/amount = 0)
	return -1

// Show a69essage to all69obs and objects in earshot of this one
// This would be for audible actions by the src69ob
//69essage is the69essage output to anyone who can hear.
// self_message (optional) is what the src69ob hears.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how69any tiles away the69essage can be heard.
/mob/audible_message(var/message,69ar/deaf_message,69ar/hearing_distance,69ar/self_message)

	var/range = world.view
	if(hearing_distance)
		range = hearing_distance

	var/turf/T = get_turf(src)

	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, range,69obs, objs)


	for(var/m in69obs)
		var/mob/M =69
		if(self_message &&69==src)
			M.show_message(self_message,2,deaf_message,1)
			continue

		M.show_message(message,2,deaf_message,1)

	for(var/o in objs)
		var/obj/O = o
		O.show_message(message,2,deaf_message,1)



/mob/proc/findname(msg)
	for(var/mob/M in SSmobs.mob_list)
		if (M.real_name == text("6969",69sg))
			return69
	return 0

/mob/proc/movement_delay()
	. = 0

	if ((drowsyness > 0) && !MOVING_DELIBERATELY(src))
		. += 6
	if(lying) //Crawling, it's slower
		. += 14 + (weakened)
	. +=69ove_intent.move_delay


/mob/proc/Life()
	SEND_SIGNAL(src, COMSIG_MOB_LIFE)
//	if(organStructure)
//		organStructure.ProcessOrgans()
	//handle_typing_indicator() //You said the typing indicator would be fine. The test determined that was a lie.
	return

#define UNBUCKLED 0
#define PARTIALLY_BUCKLED 1
#define FULLY_BUCKLED 2
/mob/proc/buckled()
	// Preliminary work for a future buckle rewrite,
	// where one69ight be fully restrained (like an elecrical chair), or69erely secured (shuttle chair, keeping you safe but69ot otherwise restrained from acting)
	if(!buckled)
		return UNBUCKLED
	return restrained() ? FULLY_BUCKLED : PARTIALLY_BUCKLED

/mob/proc/is_physically_disabled()
	return incapacitated(INCAPACITATION_DISABLED)

/mob/proc/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if ((incapacitation_flags & INCAPACITATION_STUNNED) && stunned)
		return 1

	if ((incapacitation_flags & INCAPACITATION_SOFTLYING) && (resting))
		return 1

	if ((incapacitation_flags & INCAPACITATION_FORCELYING) && (weakened || pinned.len))
		return 1

	if ((incapacitation_flags & INCAPACITATION_UNCONSCIOUS) && (stat || paralysis || sleeping || (status_flags & FAKEDEATH)))
		return 1

	if((incapacitation_flags & INCAPACITATION_RESTRAINED) && restrained())
		return 1

	if((incapacitation_flags & (INCAPACITATION_BUCKLED_PARTIALLY|INCAPACITATION_BUCKLED_FULLY)))
		var/buckling = buckled()
		if(buckling >= PARTIALLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_PARTIALLY))
			return 1
		if(buckling == FULLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_FULLY))
			return 1

	return 0

#undef UNBUCKLED
#undef PARTIALLY_BUCKLED
#undef FULLY_BUCKLED

/mob/proc/restrained()
	return

/mob/proc/reset_view(atom/A)
	if (client)
		if (istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if (isturf(loc))
				client.eye = client.mob
				client.perspective =69OB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
		client.view = world.view  // Reset69iew range if it has been altered

	if(hud_used)
		hud_used.updatePlaneMasters(src)

	return


/mob/proc/show_inv(mob/user as69ob)
	return

//mob69erbs are faster than object69erbs. See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as69ob|obj|turf in69iew())
	set69ame = "Examine"
	set category = "IC"

	if((is_blind(src) || usr.stat) && !isobserver(src))
		to_chat(src, "<span class='notice'>Something is there but you can't see it.</span>")
		return 1

	face_atom(A)
	var/obj/item/device/lighting/toggleable/flashlight/FL = locate() in src
	if (FL && FL.on && src.stat != DEAD && !incapacitated())
		FL.afterattack(A,src)
	A.examine(src)

/mob/verb/pointed(atom/A as69ob|obj|turf in69iew())
	set69ame = "Point To"
	set category = "Object"

	if(!src || !isturf(src.loc) || !(A in69iew(src.loc)))
		return 0
	if(istype(A, /obj/effect/decal/point))
		return 0

	var/tile = get_turf(A)
	if (!tile)
		return 0

	var/obj/P =69ew /obj/effect/decal/point(tile)
	P.invisibility = invisibility
	P.pixel_x = A.pixel_x
	P.pixel_y = A.pixel_y
	QDEL_IN(P, 2 SECONDS)

	face_atom(A)
	return 1


/mob/proc/ret_grab(obj/effect/list_container/mobl/L as obj, flag)
	if(!istype(l_hand, /obj/item/grab) && !istype(r_hand, /obj/item/grab))
		if (!L)
			return69ull
		else
			return L.container
	else
		if(!L)
			L =69ew /obj/effect/list_container/mobl(null)
			L.container += src
			L.master = src
		if(istype(l_hand, /obj/item/grab))
			var/obj/item/grab/G = l_hand
			if (!L.container.Find(G.affecting))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if(istype(r_hand, /obj/item/grab))
			var/obj/item/grab/G = r_hand
			if (!L.container.Find(G.affecting))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if(!flag)
			if (L.master == src)
				var/list/temp = list()
				temp += L.container
				//L =69ull
				qdel(L)
				return temp
			else
				return L.container
	return

/mob/verb/mode()
	set69ame = "Activate Held Object"
	set category = "Object"
	set src = usr

	var/obj/item/W = get_active_hand()
	if (W)
		W.attack_self(src)

/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += text("6969\n", t)
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	set69ame = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have69isplaced your69ind datum, so we can't show you your69otes.")

/mob/verb/add_memory(msg as69essage)
	set69ame = "Add69ote"
	set category = "IC"

	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		to_chat(src, "The game appears to have69isplaced your69ind datum, so we can't show you your69otes.")

/mob/proc/store_memory(msg as69essage, popup, sane = 1)
	msg = copytext(msg, 1,69AX_MESSAGE_LEN)

	if (sane)
		msg = sanitize(msg)

	if (length(memory) == 0)
		memory +=69sg
	else
		memory += "<BR>69msg69"

	if (popup)
		memory()

/mob/proc/update_flavor_text()
	set src in usr
	if(usr != src)
		to_chat(usr, "No.")
	var/msg = sanitize(input(usr,"Set the flavor text in your 'examine'69erb. Can also be used for OOC69otes about your character.","Flavor Text",html_decode(flavor_text)) as69essage|null, extra = 0)

	if(msg !=69ull)
		flavor_text =69sg

/mob/proc/print_flavor_text()
	if (flavor_text && flavor_text != "")
		var/msg = trim(replacetext(flavor_text, "\n", " "))
		if(!msg) return ""
		if(length(msg) <= 40)
			return "<font color='blue'>69msg69</font>"
		else
			return "<font color='blue'>69copytext_preserve_html(msg, 1, 37)69... <a href='byond://?src=\ref69src69;flavor_more=1'>More...</a></font>"

/*
/mob/verb/help()
	set69ame = "Help"
	src << browse('html/help.html', "window=help")
	return
*/



/client/verb/changes()
	set69ame = "Changelog"
	set category = "OOC"
	getFiles(
		'html/88x31.png',
		'html/bug-minus.png',
		'html/cross-circle.png',
		'html/hard-hat-exclamation.png',
		'html/image-minus.png',
		'html/image-plus.png',
		'html/map-pencil.png',
		'html/music-minus.png',
		'html/music-plus.png',
		'html/tick-circle.png',
		'html/wrench-screwdriver.png',
		'html/spell-check.png',
		'html/burn-exclamation.png',
		'html/chevron.png',
		'html/chevron-expand.png',
		'html/changelog.css',
		'html/changelog.js',
		'html/changelog.html'
		)
	src << browse('html/changelog.html', "window=changes;size=675x650")
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		prefs.save_preferences()
		winset(src, "rpane.changelog", "background-color=none;font-style=;")

/mob/verb/observe()
	set69ame = "Observe"
	set category = "OOC"
	var/is_admin = 0

	if(client.holder && (client.holder.rights & R_ADMIN))
		is_admin = 1
	else if(stat != DEAD || isnewplayer(src))
		to_chat(usr, "\blue You69ust be observing to use this!")
		return

	if(is_admin && stat == DEAD)
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	for(var/obj/O in world)				//EWWWWWWWWWWWWWWWWWWWWWWWW ~needs to be optimised
		if(!O.loc)
			continue
		if(istype(O, /obj/item/disk/nuclear))
			var/name = "Nuclear Disk"
			if (names.Find(name))
				namecounts69name69++
				name = "69name69 (69namecounts69name6969)"
			else
				names.Add(name)
				namecounts69name69 = 1
			creatures69name69 = O

		if(istype(O, /obj/singularity))
			var/name = "Singularity"
			if (names.Find(name))
				namecounts69name69++
				name = "69name69 (69namecounts69name6969)"
			else
				names.Add(name)
				namecounts69name69 = 1
			creatures69name69 = O

		if(istype(O, /obj/machinery/bot))
			var/name = "BOT: 69O.name69"
			if (names.Find(name))
				namecounts69name69++
				name = "69name69 (69namecounts69name6969)"
			else
				names.Add(name)
				namecounts69name69 = 1
			creatures69name69 = O


	for(var/mob/M in sortNames(SSmobs.mob_list))
		var/name =69.name
		if (names.Find(name))
			namecounts69name69++
			name = "69name69 (69namecounts69name6969)"
		else
			names.Add(name)
			namecounts69name69 = 1

		creatures69name69 =69


	client.perspective = EYE_PERSPECTIVE

	var/eye_name =69ull

	var/ok = "69is_admin ? "Admin Observe" : "Observe"69"
	eye_name = input("Please, select a player!", ok,69ull,69ull) as69ull|anything in creatures

	if (!eye_name)
		return

	var/mob/mob_eye = creatures69eye_name69

	if(client &&69ob_eye)
		client.eye =69ob_eye
		if (is_admin)
			client.adminobs = 1
			if(mob_eye == client.mob || client.eye == client.mob)
				client.adminobs = 0

/mob/verb/cancel_camera()
	set69ame = "Cancel Camera69iew"
	set category = "OOC"
	unset_machine()
	reset_view(null)

/mob/Topic(href, href_list)
	if(href_list69"mach_close"69)
		var/t1 = text("window=69href_list69"mach_close"6969")
		unset_machine()
		src << browse(null, t1)

	if(href_list69"flavor_more"69)
		if(src in69iew(usr))
			var/dat = {"
				<html><meta charset=\"utf-8\"><head><title>69name69</title></head>
				<body><tt>69replacetext(flavor_text, "\n", "<br>")69</tt></body>
				</html>
			"}
			usr << browse(dat, "window=69name69;size=500x200")
			onclose(usr, "69name69")
	if(href_list69"flavor_change"69)
		update_flavor_text()
//	..()
	return


/mob/proc/pull_damage()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.health - H.halloss <= HEALTH_THRESHOLD_SOFTCRIT)
			for(var/name in H.organs_by_name)
				var/obj/item/organ/external/e = H.organs_by_name69name69
				if(e && H.lying)
					if(((e.status & ORGAN_BROKEN && !(e.status & ORGAN_SPLINTED)) || e.status & ORGAN_BLEEDING) && (H.getBruteLoss() + H.getFireLoss() >= 100))
						return 1
		else
			return 0

/mob/MouseDrop(mob/M as69ob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(isAI(M)) return
	show_inv(usr)


/mob/verb/stop_pulling()

	set69ame = "Stop Pulling"
	set category = "IC"

	if(pulling)
		pulling.pulledby =69ull
		pulling =69ull
		/*if(pullin)
			pullin.icon_state = "pull0"*/

/mob/proc/start_pulling(var/atom/movable/AM)

	if ( !AM || !usr || src==AM || !isturf(src.loc) )	//if there's69o person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if (AM.anchored)
		to_chat(src, "<span class='warning'>It won't budge!</span>")
		return

	var/mob/M = AM
	if(ismob(AM))

		if(M.mob_size >= 69OB_GIGANTIC)
			to_chat(src, SPAN_WARNING("It won't budge!"))
			return

		if(!can_pull_mobs || !can_pull_size)
			to_chat(src, SPAN_WARNING("It won't budge!"))
			return

		if((mob_size <69.mob_size) && (can_pull_mobs !=69OB_PULL_LARGER))
			to_chat(src, SPAN_WARNING("It won't budge!"))
			return

		if((mob_size ==69.mob_size) && (can_pull_mobs ==69OB_PULL_SMALLER))
			to_chat(src, SPAN_WARNING("It won't budge!"))
			return

		// If your size is larger than theirs and you have some
		// kind of69ob pull69alue AT ALL, you will be able to pull
		// them, so don't bother checking that explicitly.

		if(!iscarbon(src))
			M.LAssailant =69ull
		else
			M.LAssailant = usr

	else if(isobj(AM))
		var/obj/I = AM
		if(!can_pull_size || can_pull_size < I.w_class)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

	if(pulling)
		var/pulling_old = pulling
		stop_pulling()
		// Are we pulling the same thing twice? Just stop pulling.
		if(pulling_old == AM)
			return

	src.pulling = AM
	AM.pulledby = src

	/*if(pullin)
		pullin.icon_state = "pull1"*/

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.pull_damage())
			to_chat(src, "\red <B>Pulling \the 69H69 in their current condition would probably be a bad idea.</B>")

	//Attempted fix for people flying away through space when cuffed and dragged.
	if(ismob(AM))
		var/mob/pulled = AM
		pulled.inertia_dir = 0

/mob/proc/can_use_hands()
	return

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_dead()
	return stat == DEAD

/mob/proc/is_mechanical()
	if(mind && (mind.assigned_role == "Robot" ||69ind.assigned_role == "AI"))
		return 1
	return issilicon(src)

/mob/proc/is_ready()
	return client && !!mind

/mob/proc/get_gender()
	return gender

/mob/proc/see(message)
	if(!is_active())
		return 0
	to_chat(src,69essage)
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in69iewers())
		M.see(message)

/mob/Stat()
	..()
	. = (is_client_active(1069INUTES))

	if(.)
		if(statpanel("Status") && SSticker.current_state != GAME_STATE_PREGAME)
			stat("Storyteller", "69master_storyteller69")
			stat("Station Time", stationtime2text())
			stat("Round Duration", roundduration2text())

		if(client.holder)
			if(statpanel("Status"))
				stat("Location:", "(69x69, 69y69, 69z69) 69loc69")
			if(statpanel("MC"))
				stat("CPU:","69world.cpu69")
				stat("Instances:","69world.contents.len69")
				stat(null)
				if(Master)
					Master.stat_entry()
				else
					stat("Master Controller:", "ERROR")
				if(Failsafe)
					Failsafe.stat_entry()
				else
					stat("Failsafe Controller:", "ERROR")
				if(GLOB)
					GLOB.stat_entry()
				else
					stat("Globals:", "ERROR")
				if(Master)
					stat(null)
					for(var/datum/controller/subsystem/SS in69aster.subsystems)
						SS.stat_entry()

		if(listed_turf && client)
			if(!TurfAdjacent(listed_turf))
				listed_turf =69ull
			else
				if(statpanel("Turf"))
					stat(listed_turf)
					for(var/atom/A in listed_turf)
						if(!A.mouse_opacity)
							continue
						if(A.invisibility > see_invisible)
							continue
						if(is_type_in_list(A, shouldnt_see))
							continue
						stat(A)


// facing69erbs
/mob/proc/canface()
	if(!canmove)						return 0
	if(stat)							return 0
	if(anchored)						return 0
	if(transforming)						return 0
	return 1

//69ot sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't69eed to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

/mob/proc/cannot_stand()
	return incapacitated(INCAPACITATION_DEFAULT & (~INCAPACITATION_RESTRAINED))


//Updates lying and icons
/*
Note from69anako: 2019-02-01
TODO: Bay69ovement:
All Canmove setting in this proc is temporary. This69ar should69ot be set from here, but from69ovement controllers
*/
/mob/proc/update_lying_buckled_and_verb_status()

	if(!resting && cannot_stand() && can_stand_overridden())
		lying = 0
		canmove = TRUE //TODO: Remove this
	else if(buckled)
		anchored = TRUE
		if(istype(buckled))
			if(buckled.buckle_lying == -1)
				lying = incapacitated(INCAPACITATION_KNOCKDOWN)
			else
				lying = buckled.buckle_lying
			if(buckled.buckle_movable)
				anchored = FALSE
		canmove = FALSE //TODO: Remove this
	else
		lying = incapacitated(INCAPACITATION_GROUNDED)
		canmove = FALSE //TODO: Remove this

	if(lying)
		set_density(0)
		if(stat == UNCONSCIOUS)
			if(l_hand) unEquip(l_hand) //we want to be able to keep items, for tactical resting and ducking behind cover
			if(r_hand) unEquip(r_hand)
	else
		canmove = TRUE
		set_density(initial(density))
	reset_layer()

	for(var/obj/item/grab/G in grabbed_by)
		if(G.force_stand())
			lying = 0

	//Temporarily69oved here from the69arious life() procs
	//I'm fixing stuff incrementally so this will likely find a better home.
	//It just69akes sense for69ow. ~Carn
	if( update_icon )	//forces a full overlay update
		update_icon = 0
		regenerate_icons()
	else if( lying != lying_prev )
		update_icons()

/mob/proc/reset_layer()
	if(lying)
		set_plane(LYING_MOB_PLANE)
		layer = LYING_MOB_LAYER
	else
		reset_plane_and_layer()

/mob/facedir(var/ndir)
	if(!canface() || client.moving)
		return 0
	set_dir(ndir)
	if(buckled && buckled.buckle_movable)
		buckled.set_dir(ndir)
	set_move_cooldown(movement_delay())
	return 1


/mob/verb/eastface()
	set hidden = 1
	return facedir(client.client_dir(EAST))


/mob/verb/westface()
	set hidden = 1
	return facedir(client.client_dir(WEST))


/mob/verb/northface()
	set hidden = 1
	return facedir(client.client_dir(NORTH))


/mob/verb/southface()
	set hidden = 1
	return facedir(client.client_dir(SOUTH))


//This69ight69eed a rename but it should replace the can this69ob use things check
/mob/proc/IsAdvancedToolUser()
	return 0

/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		facing_dir =69ull
		stunned =69ax(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		update_lying_buckled_and_verb_status()
	return

/mob/proc/SetStunned(amount) //if you REALLY69eed to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned =69ax(amount,0)
		update_lying_buckled_and_verb_status()
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned =69ax(stunned + amount,0)
		update_lying_buckled_and_verb_status()
	return

/mob/proc/Weaken(amount)
	if(status_flags & CANWEAKEN)
		facing_dir =69ull
		weakened =69ax(max(weakened,amount),0)
		update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
	return

/mob/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened =69ax(amount,0)
		update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
	return

/mob/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened =69ax(weakened + amount,0)
		update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
	return

/mob/proc/Paralyse(amount)
	if(status_flags & CANPARALYSE)
		facing_dir =69ull
		paralysis =69ax(max(paralysis,amount),0)
		return TRUE
	return

/mob/living/Paralyse(amount)
	var/zero_before = FALSE
	if (!paralysis)
		zero_before = TRUE
	.=..()
	if (. && zero_before)
		//These three procs instantly create the blinding/sleep overlay
		//We only call them if the69ob has just become paralysed, to prevent an infinite loop
		handle_regular_status_updates() //This checks paralysis and sets stat
		handle_disabilities() //This checks stat and sets eye_blind
		handle_regular_hud_updates() //This checks eye_blind and adds or removes the hud overlay

/mob/proc/SetParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis =69ax(amount,0)
	return

/mob/proc/AdjustParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis =69ax(paralysis + amount,0)
	return

/mob/proc/Sleeping(amount)
	facing_dir =69ull
	sleeping =69ax(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping =69ax(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping =69ax(sleeping + amount,0)
	return

/mob/proc/Resting(amount)
	facing_dir =69ull
	resting =69ax(max(resting,amount),0)
	return

/mob/proc/SetResting(amount)
	resting =69ax(amount,0)
	return

/mob/proc/AdjustResting(amount)
	resting =69ax(resting + amount,0)
	return

/mob/proc/get_species()
	return ""

/mob/proc/flash_weak_pain()
	return

/mob/living/flash_weak_pain()
//	flick("weak_pain", flash69"pain"69)
	if(HUDtech.Find("pain"))
		flick("weak_pain", HUDtech69"pain"69)


/mob/proc/get_visible_implants()
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		visible_implants += O
	return69isible_implants

/mob/proc/embedded_needs_process()
	return (embedded.len > 0)

mob/proc/yank_out_object()
	set category = "Object"
	set69ame = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in69iew(1)

	if(!isliving(usr) || !usr.can_click())
		return
	usr.setClickCooldown(20)

	if(usr.stat == 1)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self =69ull

	if(S == U)
		self = 1 // Removing object from yourself.

	valid_objects = get_visible_implants()
	if(!valid_objects.len)
		if(self)
			to_chat(src, "You have69othing stuck in your body that is large enough to remove.")
		else
			to_chat(U, "69src69 has69othing stuck in their wounds that is large enough to remove.")
		return

	var/obj/item/selection = input("What do you want to yank out?", "Embedded objects") in69alid_objects

	if(self)
		to_chat(src, "<span class='warning'>You attempt to get a good grip on 69selection69 in your body.</span>")
	else
		to_chat(U, "<span class='warning'>You attempt to get a good grip on 69selection69 in 69S69's body.</span>")

	if(!do_mob(U, S, 30))
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message("<span class='warning'><b>69src69 rips 69selection69 out of their body.</b></span>","<span class='warning'><b>You rip 69selection69 out of your body.</b></span>")
	else
		visible_message("<span class='warning'><b>69usr69 rips 69selection69 out of 69src69's body.</b></span>","<span class='warning'><b>69usr69 rips 69selection69 out of your body.</b></span>")
	valid_objects = get_visible_implants()
	if(valid_objects.len == 1) //Yanking out last object - removing69erb.
		src.verbs -= /mob/proc/yank_out_object

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/external/affected

		for(var/obj/item/organ/external/organ in H.organs) //Grab the organ holding the implant.
			for(var/obj/item/O in organ.implants)
				if(O == selection)
					affected = organ

		affected.implants -= selection
		affected.embedded -= selection
		selection.on_embed_removal(src)
		H.shock_stage+=20
		affected.take_damage((selection.w_class * 3), 0, 0, 1, "Embedded object extraction")

		if (ishuman(U))
			var/mob/living/carbon/human/human_user = U
			human_user.bloody_hands(H)

	else
		embedded -= selection
		selection.on_embed_removal(src)
		if(issilicon(src))
			var/mob/living/silicon/robot/R = src
			R.adjustBruteLoss(5)
			R.adjustFireLoss(10)

	selection.forceMove(get_turf(src))

	if(!(U.l_hand && U.r_hand))
		U.put_in_hands(selection)

	for(var/obj/item/O in pinned)
		if(O == selection)
			pinned -= O
		if(!pinned.len)
			anchored = FALSE
	return 1

/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_weakened()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()
	handle_slowdown()

/mob/living/proc/handle_stunned()
	if(stunned)
		AdjustStunned(-1)
	return stunned

/mob/living/proc/handle_weakened()
	if(weakened)
		weakened =69ax(weakened-1,0)	//before you get69ad Rockdtben: I done this so update_lying_buckled_and_verb_status isn't called69ultiple times
	return weakened

/mob/living/proc/handle_stuttering()
	if(stuttering)
		stuttering =69ax(stuttering-1, 0)
	return stuttering

/mob/living/proc/handle_silent()
	if(silent)
		silent =69ax(silent-1, 0)
	return silent

/mob/living/proc/handle_drugged()
	if(druggy)
		druggy =69ax(druggy-1, 0)
	return druggy

/mob/living/proc/handle_slurring()
	if(slurring)
		slurring =69ax(slurring-1, 0)
	return slurring

/mob/living/proc/handle_paralysed() // Currently only used by simple_animal.dm, treated as a special case in other69obs
	if(paralysis)
		AdjustParalysis(-1)
	return paralysis

/mob/living/proc/handle_slowdown()
	if(slowdown)
		slowdown =69ax(slowdown-1, 0)
	return slowdown

//Check for brain worms in head.
/mob/proc/has_brain_worms()

	for(var/I in contents)
		if(istype(I,/mob/living/simple_animal/borer))
			return I

	return FALSE

/mob/proc/updateicon()
	return

/mob/verb/face_direction()

	set69ame = "Face Direction"
	set category = "IC"
	set src = usr

	set_face_dir()

	if(!facing_dir)
		to_chat(usr, "You are69ow69ot facing anything.")
	else
		to_chat(usr, "You are69ow facing 69dir2text(facing_dir)69.")

/mob/verb/browse_mine_stats()
	set69ame		= "Show stats and perks"
	set desc		= "Browse your character stats and perks."
	set category	= "IC"
	set src			= usr

	browse_src_stats(src)

/mob/proc/browse_src_stats(mob/user)
	var/additionalcss = {"
		<style>
			table {
				float: left;
			}
			table, th, td {
				border: #3333aa solid 1px;
				border-radius: 5px;
				padding: 5px;
				text-align: center;
			}
			th{
				background:#633;
			}
		</style>
	"}
	var/table_header = "<th>Stat69ame<th>Stat69alue"
	var/list/S = list()
	for(var/TS in ALL_STATS)
		S += "<td>69TS69<td>69getStatStats(TS)69"
	var/data = {"
		69additionalcss69
		69user == src ? "Your stats:" : "69name69's stats"69<br>
		<table width=20%>
			<tr>69table_header69
			<tr>69S.Join("<tr>")69
		</table>
	"}
	// Perks
	var/list/Plist = list()
	if (stats) // Check if69ob has stats. Otherwise we cannot read69ull.perks
		for(var/perk in stats.perks)
			var/datum/perk/P = perk
			var/filename = sanitizeFileName("69P.type69.png")
			var/asset = asset_cache.cache69filename69 // this is definitely a hack, but getAtomCacheFilename accepts only atoms for69o fucking reason whatsoever.
			if(asset)
				Plist += "<td69align='middle'><img src=69filename69></td><td><span style='text-align:center'>69P.name69<br>69P.desc69</span></td>"
	data += {"
		<table width=80%>
			<th colspan=2>Perks</th>
			<tr>69Plist.Join("</tr><tr>")69</tr>
		</table>
	"}

	var/datum/browser/B =69ew(src, "StatsBrowser","69user == src ? "Your stats:" : "69name69's stats"69", 1000, 345)
	B.set_content(data)
	B.set_window_options("can_minimize=0")
	B.open()

/mob/proc/getStatStats(typeOfStat)
	if (SSticker.current_state != GAME_STATE_PREGAME)
		if(stats)
			return stats.getStat(typeOfStat)
		return 0

/mob/proc/set_face_dir(var/newdir)
	if(!isnull(facing_dir) &&69ewdir == facing_dir)
		facing_dir =69ull
	else if(newdir)
		set_dir(newdir)
		facing_dir =69ewdir
	else if(facing_dir)
		facing_dir =69ull
	else
		set_dir(dir)
		facing_dir = dir

/mob/set_dir()
	if(facing_dir)
		if(!canface() || lying || buckled || restrained())
			facing_dir =69ull
		else if(dir != facing_dir)
			return ..(facing_dir)
	else
		return ..()

/mob/verb/northfaceperm()
	set hidden = 1
	if(facing_dir)
		facing_dir =69ull
		to_chat(usr, "You are69ow69ot facing anything.")
	else
		set_face_dir(client.client_dir(NORTH))
		to_chat(usr, "You are69ow facing69orth.")

/mob/verb/southfaceperm()
	set hidden = 1
	if(facing_dir)
		facing_dir =69ull
		to_chat(usr, "You are69ow69ot facing anything.")
	else
		set_face_dir(client.client_dir(SOUTH))
		to_chat(usr, "You are69ow facing south.")

/mob/verb/eastfaceperm()
	set hidden = 1
	if(facing_dir)
		facing_dir =69ull
		to_chat(usr, "You are69ow69ot facing anything.")
	else
		set_face_dir(client.client_dir(EAST))
		to_chat(usr, "You are69ow facing east.")

/mob/verb/westfaceperm()
	set hidden = 1
	if(facing_dir)
		facing_dir =69ull
		to_chat(usr, "You are69ow69ot facing anything.")
	else
		set_face_dir(client.client_dir(WEST))
		to_chat(usr, "You are69ow facing west.")

/mob/verb/change_move_intent()
	set69ame = "Change69oving intent"
	set category = "IC"
	set src = usr

	if(HUDneed69"move intent"69)
		var/obj/screen/mov_intent/mov_intent = HUDneed69"move intent"69
		mov_intent.Click()  // Yep , this is all.

/mob/proc/adjustEarDamage()
	return

/mob/proc/setEarDamage()
	return

//Throwing stuff

/mob/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/proc/throw_mode_off()
	src.in_throw_mode = 0
	/*for (var/obj/screen/HUDthrow/HUD in src.client.screen.)
		if(HUD.name == "throw") //in case we don't have the HUD and we use the hotkey
			//src.throw_icon.icon_state = "act_throw_off"
			HUD.toggle_throw_mode()
			break*/

/mob/proc/throw_mode_on()
	src.in_throw_mode = 1
	/*if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_on"*/
	/*for (var/obj/screen/HUDthrow/HUD in src.client.screen.)
		if(HUD.name == "throw") //in case we don't have the HUD and we use the hotkey
			//src.throw_icon.icon_state = "act_throw_off"
			HUD.toggle_throw_mode()
			break*/

/mob/proc/swap_hand()
	return

/mob/proc/check_CH(CH_name as text,69ar/CH_type,69ar/second_arg =69ull)
	if(!src.client.CH || !istype(src.client.CH, CH_type))//(src.client.CH.handler_name != CH_name))
		src.client.CH =69ew CH_type(client, second_arg)
		to_chat(src, SPAN_WARNING("You prepare 69CH_name69."))
	else
		kill_CH()
	return

/mob/proc/kill_CH()
	if (src.client.CH)
		to_chat(src, SPAN_NOTICE ("You unprepare 69src.client.CH.handler_name69."))
		qdel(src.client.CH)


/mob/living/proc/Released()
	//This is called when the69ob is let out of a holder
	//Override for69ob-specific functionality
	return

/mob/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/proc/get_face_name()
	return69ame

/client/proc/check_has_body_select()
	return69ob &&69ob.HUDneed &&69ob.HUDneed69"damage zone"69

/client/verb/body_toggle_head()
	set69ame = "body-toggle-head"
	set hidden = TRUE
	set category = "OOC"
	toggle_zone_sel(list(BP_HEAD,BP_EYES,BP_MOUTH))

/client/verb/body_r_arm()
	set69ame = "body-r-arm"
	set hidden = TRUE
	set category = "OOC"
	toggle_zone_sel(list(BP_R_ARM))

/client/verb/body_l_arm()
	set69ame = "body-l-arm"
	set hidden = TRUE
	toggle_zone_sel(list(BP_L_ARM))

/client/verb/body_chest()
	set69ame = "body-chest"
	set hidden = TRUE
	toggle_zone_sel(list(BP_CHEST))

/client/verb/body_groin()
	set69ame = "body-groin"
	set hidden = TRUE
	toggle_zone_sel(list(BP_GROIN))

/client/verb/body_r_leg()
	set69ame = "body-r-leg"
	set hidden = TRUE
	toggle_zone_sel(list(BP_R_LEG))

/client/verb/body_l_leg()
	set69ame = "body-l-leg"
	set hidden = TRUE
	toggle_zone_sel(list(BP_L_LEG))

/client/proc/toggle_zone_sel(list/zones)
	if(!check_has_body_select())
		return
	var/obj/screen/zone_sel/selector =69ob.HUDneed69"damage zone"69
	selector.set_selected_zone(next_list_item(mob.targeted_organ,zones))
/mob/proc/set_stat(var/new_stat)
	. = stat !=69ew_stat
	stat =69ew_stat

/mob/proc/ssd_check()
	return !client && !teleop
