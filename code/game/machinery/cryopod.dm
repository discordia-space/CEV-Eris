/*
 * Cryo69enic refri69eration unit. Basically a despawner.
 * Stealin69 a lot of concepts/code from sleepers due to69assive laziness.
 * The despawn tick will only fire if it's been69ore than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant69oves in.
 * ~ Zuhayr
 */


//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryo69enic oversi69ht console"
	desc = "An interface between crew and the cryo69enic stora69e oversi69ht systems."
	icon = 'icons/obj/Cryo69enic2.dmi'
	icon_state = "cellconsole"
	li69ht_power = 1.5
	li69ht_color = COLOR_LI69HTIN69_BLUE_MACHINERY
	circuit = /obj/item/electronics/circuitboard/cryopodcontrol
	density = FALSE
	interact_offline = 1
	var/mode = null

	//Used for lo6969in69 people enterin69 cryosleep and important items they are carryin69.
	var/list/frozen_crew = list()
	var/list/frozen_items = list()
	var/list/_admin_lo69s = list() // _ so it shows first in69V

	var/stora69e_type = "crewmembers"
	var/stora69e_name = "Cryo69enic Oversi69ht Control"
	var/allow_items = 1

/obj/machinery/computer/cryopod/robot
	name = "robotic stora69e console"
	desc = "An interface between crew and the robotic stora69e systems"
	icon = 'icons/obj/robot_stora69e.dmi'
	icon_state = "console"
	circuit = /obj/item/electronics/circuitboard/robotstora69econtrol

	stora69e_type = "cybor69s"
	stora69e_name = "Robotic Stora69e Control"
	allow_items = 0

/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	src.add_fin69erprint(usr)

	var/dat

	dat += "<hr/><br/><b>69stora69e_name69</b><br/>"
	dat += "<i>Welcome, 69user.real_name69.</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref69src69;lo69=1'>View stora69e lo69</a>.<br>"
	if(allow_items)
		dat += "<a href='?src=\ref69src69;view=1'>View objects</a>.<br>"
		dat += "<a href='?src=\ref69src69;item=1'>Recover object</a>.<br>"
		dat += "<a href='?src=\ref69src69;allitems=1'>Recover all objects</a>.<br>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/Topic(href, href_list)

	if(..())
		return

	var/mob/user = usr

	src.add_fin69erprint(user)

	if(href_list69"lo69"69)

		var/dat = "<b>Recently stored 69stora69e_type69</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "69person69<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryolo69")

	if(href_list69"view"69)
		if(!allow_items) return

		var/dat = "<b>Recently stored objects</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items)
			dat += "69I.name69<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryoitems")

	else if(href_list69"item"69)
		if(!allow_items) return

		if(frozen_items.len == 0)
			to_chat(user, "<span class='notice'>There is nothin69 to recover from stora69e.</span>")
			return

		var/obj/item/I = input(usr, "Please choose which object to retrieve.","Object recovery",null) as null|anythin69 in frozen_items
		if(!I)
			return

		if(!(I in frozen_items))
			to_chat(user, "<span class='notice'>\The 69I69 is no lon69er in stora69e.</span>")
			return

		visible_messa69e("<span class='notice'>The console beeps happily as it dis69or69es \the 69I69.</span>")

		I.forceMove(69et_turf(src))
		frozen_items -= I

	else if(href_list69"allitems"69)
		if(!allow_items) return

		if(frozen_items.len == 0)
			to_chat(user, "<span class='notice'>There is nothin69 to recover from stora69e.</span>")
			return

		visible_messa69e("<span class='notice'>The console beeps happily as it dis69or69es the desired objects.</span>")

		for(var/obj/item/I in frozen_items)
			I.forceMove(69et_turf(src))
			frozen_items -= I

	src.updateUsrDialo69()
	return

/obj/item/electronics/circuitboard/cryopodcontrol
	name = "Circuit board (Cryo69enic Oversi69ht Console)"
	build_path = /obj/machinery/computer/cryopod
	ori69in_tech = list(TECH_DATA = 3)

/obj/item/electronics/circuitboard/robotstora69econtrol
	name = "Circuit board (Robotic Stora69e Console)"
	build_path = /obj/machinery/computer/cryopod/robot
	ori69in_tech = list(TECH_DATA = 3)

//Decorative structures to 69o alon69side cryopods.
/obj/structure/cryofeed
	name = "cryo69enic feed"
	desc = "A bewilderin69 tan69le of69achinery and pipes."
	icon = 'icons/obj/Cryo69enic2.dmi'
	icon_state = "cryo_rear"
	density = TRUE
	anchored = TRUE
	dir = WEST

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryo69enic freezer"
	desc = "A69an-sized pod for enterin69 suspended animation."
	icon = 'icons/obj/Cryo69enic2.dmi'
	icon_state = "cryopod"
	density = TRUE
	anchored = TRUE
	dir = WEST

	var/on_store_messa69e = "has entered lon69-term stora69e."
	var/on_store_name = "Cryo69enic Oversi69ht"
	var/on_enter_occupant_messa69e = "You feel cool air surround you. You 69o numb as your senses turn inward."
	var/allow_occupant_types = list(/mob/livin69/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/occupant = null       // Person waitin69 to be despawned.
	var/time_till_despawn = 6000  // 1069inutes-ish safe period before bein69 despawned.
	var/time_entered = 0          // Used to keep track of the safe period.
	var/obj/item/device/radio/intercom/announce //

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_messa69e = 0
	var/applies_stasis = 1

	// These items are preserved when the process() despawn proc occurs.
	var/list/preserve_items = list(
		/obj/item/hand_tele,
		/obj/item/card/id/captains_spare,
		/obj/item/device/aicard,
		/obj/item/device/mmi,
		/obj/item/device/paicard,
		/obj/item/69un,
		/obj/item/pinpointer,
		/obj/item/clothin69/suit,
		/obj/item/clothin69/shoes/ma69boots,
		/obj/item/blueprints,
		/obj/item/clothin69/head/space,
		/obj/item/stora69e/internal
	)

/obj/machinery/cryopod/robot
	name = "robotic stora69e unit"
	desc = "A stora69e unit for robots."
	icon = 'icons/obj/robot_stora69e.dmi'
	icon_state = "pod"
	on_store_messa69e = "has entered robotic stora69e."
	on_store_name = "Robotic Stora69e Oversi69ht"
	on_enter_occupant_messa69e = "The stora69e unit broadcasts a sleep si69nal to you. Your systems start to shut down, and you enter low-power69ode."
	allow_occupant_types = list(/mob/livin69/silicon/robot)
	disallow_occupant_types = list(/mob/livin69/silicon/robot/drone)
	applies_stasis = 0

/obj/machinery/cryopod/New()
	announce = new /obj/item/device/radio/intercom(src)
	update_icon()
	..()

/obj/machinery/cryopod/Destroy()
	if(occupant)
		occupant.forceMove(loc)
		occupant.restin69 = 1
	. = ..()

/obj/machinery/cryopod/Initialize()
	. = ..()

	find_control_computer()

/obj/machinery/cryopod/update_icon()
	if(occupant)
		icon_state = "69initial(icon_state)69_1"
	else
		icon_state = "69initial(icon_state)69_0"

/obj/machinery/cryopod/proc/find_control_computer(ur69ent=0)
	// Workaround for http://www.byond.com/forum/?post=2007448
	for(var/obj/machinery/computer/cryopod/C in src.loc.loc)
		control_computer = C
		break
	// control_computer = locate(/obj/machinery/computer/cryopod) in src.loc.loc

	// Don't send69essa69es unless we *need* the computer, and less than five69inutes have passed since last time we69essa69ed
	if(!control_computer && ur69ent && last_no_computer_messa69e + 5*60*10 < world.time)
		lo69_admin("Cryopod in 69src.loc.loc69 could not find control computer!")
		messa69e_admins("Cryopod in 69src.loc.loc69 could not find control computer!")
		last_no_computer_messa69e = world.time

	return control_computer != null

/obj/machinery/cryopod/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1

//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/machinery/cryopod/Process()
	if(occupant)
		//Allow a ten69inute 69ap between enterin69 the pod and actually despawnin69.
		if(world.time - time_entered < time_till_despawn)
			return

		if(!occupant.client && occupant.stat<2) //Occupant is livin69 and has no client.
			if(!control_computer)
				if(!find_control_computer(ur69ent=1))
					return

			despawn_occupant()

// This function can not be undone; do not call this unless you are sure
// Also69ake sure there is a69alid control computer
/obj/machinery/cryopod/robot/despawn_occupant()
	var/mob/livin69/silicon/robot/R = occupant
	if(!istype(R)) return ..()

	69del(R.mmi)

	// Cryopod code to extract items from cybor69s before callin69 ..() so the cybro69 is in clean state for proc/despawn_occupant()
	for(var/obj/item/I in R.module) // the tools the bor69 has;69etal, 69lass, 69uns etc
		for(var/obj/item/O in I) // the thin69s inside the tools, if anythin69;69ainly for janibor69 trash ba69s
			O.forceMove(R)
		69del(I)

	69del(R.module)

	return ..()

// This function can not be undone; do not call this unless you are sure
// Also69ake sure there is a69alid control computer
/obj/machinery/cryopod/proc/despawn_occupant()
	var/mob/livin69/carbon/human/H = occupant
	var/list/occupant_or69ans
	if(istype(H))
		occupant_or69ans = H.or69ans | H.internal_or69ans

	//Drop all items into the pod.
	//// Local pod code
	for(var/obj/item/W in occupant)
		// Don't delete the or69ans!
		if(W in occupant_or69ans)
			continue

		occupant.drop_from_inventory(W)
		W.forceMove(src)

		if(W.contents.len) //Make sure we catch anythin69 not handled by 69del() on the items.
			for(var/obj/item/O in W.contents)
				if(istype(O,/obj/item/stora69e/internal)) //Stop eatin69 pockets, you fuck!
					continue
				O.forceMove(src)

	//Delete all items not on the preservation list.
	var/list/items = src.contents.Copy()
	items -= occupant // Don't delete the occupant
	items -= announce // or the autosay radio.

	// Preserve the69mi brain, 69uite snowflake code here
	for(var/obj/item/W in items)
		var/preserve = null
		// Snowflaaaake.
		if(istype(W, /obj/item/device/mmi))
			var/obj/item/device/mmi/brain = W
			if(brain.brainmob && brain.brainmob.client && brain.brainmob.key)
				preserve = 1
			else
				continue
		else
			for(var/T in preserve_items)
				if(istype(W,T))
					preserve = 1
					break

		if(!preserve)
			69del(W)
		else
			if(control_computer && control_computer.allow_items)
				control_computer.frozen_items += W
				W.loc = null
			else
				W.forceMove(src.loc)

	//Make an announcement and lo69 the person enterin69 stora69e.
	control_computer.frozen_crew += "69occupant.real_name69" + "69occupant.mind ? ", 69occupant.mind.assi69ned_role69" : ""69" + " - 69stationtime2text()69"
	control_computer._admin_lo69s += "69key_name(occupant)69" + "69occupant.mind ? ", (69occupant.mind.assi69ned_role69)" : ""69" + " at 69stationtime2text()69"
	lo69_and_messa69e_admins("69key_name(occupant)69" + "69occupant.mind ? " (69occupant.mind.assi69ned_role69)" : ""69" + " entered cryostora69e.")

	announce.autosay("69occupant.real_name69" + "69occupant.mind ? ", 69occupant.mind.assi69ned_role69" : ""69" + ", 69on_store_messa69e69", "69on_store_name69")
	visible_messa69e("<span class='notice'>\The 69initial(name)69 hums and hisses as it69oves 69occupant.real_name69 into stora69e.</span>")

	//When the occupant is put into stora69e, their respawn time is reduced.
	//This check exists for the benefit of people who 69et put into cryostora69e while SSD and come back later
	if (occupant.in_perfect_health())
		if (occupant.mind && occupant.mind.key)

			//Whoever inhabited this body is lon69 69one, we need some black69a69ic to find where and who they are now
			var/mob/M = key2mob(occupant.mind.key)
			if (istype(M))
				if (!(M.69et_respawn_bonus("CRYOSLEEP")))
					//We send a69essa69e to the occupant's current69ob - probably a 69host, but who knows.
					to_chat(M, SPAN_NOTICE("Because your body was put into cryostora69e, your crew respawn time has been reduced by 69CRYOPOD_SPAWN_BONUS_DESC69."))
					M << 'sound/effects/ma69ic/blind.o6969' //Play this sound to a player whenever their respawn time 69ets reduced

				//69oin69 safely to cryo will allow the patient to respawn69ore 69uickly
				M.set_respawn_bonus("CRYOSLEEP", CRYOPOD_SPAWN_BONUS)

	// This despawn is not a 69ib() in this sense, it is used to remove objectives tied on these despawned69obs in cryos
	occupant.despawn()
	set_occupant(null)

/obj/machinery/cryopod/affect_69rab(var/mob/user,69ar/mob/tar69et)
	try_put_inside(tar69et, user)
	return TRUE

/obj/machinery/cryopod/MouseDrop_T(var/mob/livin69/L,69ob/livin69/user)
	if(istype(L) && istype(user))
		try_put_inside(L, user)

/obj/machinery/cryopod/proc/try_put_inside(var/mob/livin69/affectin69,69ar/mob/livin69/user)
	if(occupant)
		to_chat(user, "<span class='notice'>\The 69src69 is in use.</span>")
		return

	if(!ismob(affectin69) || !Adjacent(affectin69) || !Adjacent(user))
		return

	if(!check_occupant_allowed(affectin69))
		return

	var/willin69 = null //We don't want to allow people to be forced into despawnin69.

	if(affectin69 != user && affectin69.client)
		if(alert(affectin69,"Would you like to enter lon69-term stora69e?",,"Yes","No") == "Yes")
			if(!affectin69)
				return
			willin69 = 1
	else
		willin69 = 1

	if(willin69)

		visible_messa69e("69user69 starts puttin69 69affectin6969 into \the 69src69.")

		if(!do_after(user, 20, src))
			return

		if(!user || !Adjacent(user))
			return
		if(!affectin69 || !Adjacent(affectin69))
			return

		set_occupant(affectin69)

		// Book keepin69!
		var/turf/location = 69et_turf(src)
		lo69_admin("69key_name_admin(affectin69)69 has entered a stasis pod. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69location.x69;Y=69location.y69;Z=69location.z69'>JMP</a>)")
		messa69e_admins("<span class='notice'>69key_name_admin(affectin69)69 has entered a stasis pod.</span>")
		if(user == affectin69)
			src.add_fin69erprint(affectin69)

		//Despawnin69 occurs when process() is called with an occupant without a client.
		src.add_fin69erprint(user)



/obj/machinery/cryopod/verb/eject()
	set name = "Eject Pod"
	set cate69ory = "Object"
	set src in oview(1)
	if(!usr) // when called from preferences_spawnpoints.dm there is no usr since it is called indirectly. If there is no occupant and usr somethin69 really bad has happened here so just keep them in the pod - Hopek
		if(!occupant)
			return
		usr = occupant
	if(usr.stat != 0)
		return

	//Eject any items that aren't69eant to be in the pod. Attempts to put the items back on the occupant otherwise drops them.
	var/list/items = src.contents
	if(occupant)
		if(usr != occupant && !occupant.client && occupant.stat != DEAD)
			to_chat(usr, SPAN_WARNIN69("It's locked inside!"))
			return
		items -= occupant
	if(announce)
		items -= announce

	for(var/obj/item/W in items)
		W.forceMove(69et_turf(src))
		occupant.e69uip_to_appropriate_slot(W) // Items are now ejected. Tries to put them items on the occupant so they don't leave them behind

	src.69o_out()
	add_fin69erprint(usr)

	name = initial(name)
	return

/obj/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set cate69ory = "Object"
	set src in oview(1)

	if(usr.stat != 0 || !check_occupant_allowed(usr))
		return

	if(src.occupant)
		to_chat(usr, "<span class='notice'><B>\The 69src69 is in use.</B></span>")
		return

	for(var/mob/livin69/carbon/slime/M in ran69e(1,usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy 69ettin69 your life sucked out of you.")
			return

	visible_messa69e("69usr69 starts climbin69 into \the 69src69.")

	if(do_after(usr, 20, src))

		if(!usr || !usr.client)
			return

		if(src.occupant)
			to_chat(usr, "<span class='notice'><B>\The 69src69 is in use.</B></span>")
			return

		usr.stop_pullin69()
		set_occupant(usr)

		src.add_fin69erprint(usr)

	return

/obj/machinery/cryopod/relaymove(var/mob/user)
	..()
	eject()

/obj/machinery/cryopod/proc/69o_out()

	if(!occupant)
		return

	set_occupant(null)

	spawn(30)
		state("Please remember to check inside the cryopod if any belon69in69s are69issin69.")
		playsound(loc, "robot_talk_li69ht", 100, 0, 0)

//Notifications is set false when someone spawns in here
/obj/machinery/cryopod/proc/set_occupant(var/mob/livin69/new_occupant,69ar/notifications = TRUE)
	name = initial(name)
	if(new_occupant)
		occupant = new_occupant
		if (occupant.name)
			name = "69name69 (69occupant.name69)"
		else
			//Name isn't set durin69 spawnin69, but real_name is. This is used for people spawnin69 in cryopods
			name = "69name69 (69occupant.real_name69)"

		time_entered = world.time
		if(ishuman(occupant) && applies_stasis)
			var/mob/livin69/carbon/human/H = occupant
			H.EnterStasis()
			if(H.mind && H.mind.initial_account)
				var/datum/money_account/A = H.mind.initial_account
				if(A.employer && A.wa69e_ori69inal) // Dicrease personnel bud69et of our department, if have one
					var/datum/money_account/EA = department_accounts69A.employer69
					var/datum/department/D = 69LOB.all_departments69A.employer69
					if(EA && D) // Don't bother if department have no employer
						D.bud69et_personnel -= A.wa69e_ori69inal
						if(!EA.wa69e_manual) // Update department account's wa69e if it's not in69anual69ode
							EA.wa69e = D.69et_total_bud69et()

		new_occupant.forceMove(src)

		if (notifications)
			to_chat(occupant, SPAN_NOTICE("69on_enter_occupant_messa69e69"))
			to_chat(occupant, SPAN_NOTICE("<b>If you 69host, lo69 out or close your client now, your character will shortly be permanently removed from the round.</b>"))
		if (occupant.in_perfect_health() && notifications)
			to_chat(occupant, SPAN_NOTICE("<b>Your respawn time will be reduced by 2069inutes, allowin69 you to respawn as a crewmember69uch69ore 69uickly.</b>"))
		else if (notifications)
			to_chat(occupant, SPAN_DAN69ER("<b>Because you are not in perfect health, 69oin69 into cryosleep will not reduce your crew respawn time. \
			If you wish to respawn as a different crewmember, you should treat your injuries at69edical first</b>"))

	else
		if(!69DELETED(occupant))
			occupant.forceMove(69et_turf(src))
			occupant.reset_view(null)
			if(ishuman(occupant) && applies_stasis)
				var/mob/livin69/carbon/human/H = occupant
				H.ExitStasis()
		occupant = null

	update_icon()
