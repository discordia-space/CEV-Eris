/* Teleportation devices.
 * Contains:
 *		Locator
 *		Hand-tele
 */

/*
 * Locator
 */
/obj/item/weapon/locator
	name = "locator"
	desc = "Used to track those with locater implants."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/temp = null
	var/frequency = 1451
	var/broadcasting = null
	var/listening = 1.0
	flags = CONDUCT
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTIC = 2)

/obj/item/weapon/locator/attack_self(mob/user)
	user.set_machine(src)
	var/dat
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = {"
<B>Persistent Signal Locator</B><HR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

<A href='?src=\ref[src];refresh=1'>Refresh</A>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/weapon/locator/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	var/turf/current_location = get_turf(usr)//What turf is the user on?
	if(!current_location||current_location.z==2)//If turf was not found or they're on z level 2.
		to_chat(usr, "The [src] is malfunctioning.")
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if (href_list["refresh"])
			src.temp = "<B>Persistent Signal Locator</B><HR>"
			var/turf/sr = get_turf(src)

			if (sr)
				src.temp += "<B>Located Beacons:</B><BR>"

				for(var/obj/item/device/radio/beacon/W in world)
					if (W.frequency == src.frequency)
						var/turf/tr = get_turf(W)
						if (tr.z == sr.z && tr)
							var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									if (direct < 20)
										direct = "weak"
									else
										direct = "very weak"
							src.temp += "[W.code]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>Extranneous Signals:</B><BR>"
				for (var/obj/item/weapon/implant/tracking/W in world)
					if (!W.implanted || !(istype(W.loc,/obj/item/organ/external) || ismob(W.loc)))
						continue
					else
						var/mob/M = W.loc
						if (M.stat == 2)
							if (M.timeofdeath + 6000 < world.time)
								continue

					var/turf/tr = get_turf(W)
					if (tr.z == sr.z && tr)
						var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
						if (direct < 20)
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									direct = "weak"
							src.temp += "[W.id]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>You are at \[[sr.x],[sr.y],[sr.z]\]</B> in orbital coordinates.<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A><BR>"
			else
				src.temp += "<B><FONT color='red'>Processing Error:</FONT></B> Unable to locate orbital position.<BR>"
		else
			if (href_list["freq"])
				src.frequency += text2num(href_list["freq"])
				src.frequency = sanitize_frequency(src.frequency)
			else
				if (href_list["temp"])
					src.temp = null
		if (ismob(loc))
			attack_self(loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return


/*
 * Hand-tele
 */
/obj/item/weapon/hand_tele
	name = "NT BSD \"Jumper\""
	desc = "Also known as hand teleporter, this is old and unreliable way to create stable blue-space portals. Yet it become popular due its size and low energy consumption."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	item_state = "electronic"
	throwforce = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MAGNET = 1, TECH_BLUESPACE = 3)
	matter = list(MATERIAL_PLASTIC = 3, MATERIAL_GLASS = 1, MATERIAL_SILVER = 1, MATERIAL_URANIUM = 1)
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small
	var/portal_type = /obj/effect/portal
	var/portal_fail_chance = null
	var/cell_charge_per_attempt = 33

/obj/item/weapon/hand_tele/Initialize()
	. = ..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

/obj/item/weapon/hand_tele/get_cell()
	return cell

/obj/item/weapon/hand_tele/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/item/weapon/hand_tele/attack_self(mob/user)
	if(!cell || !cell.checked_use( cell_charge_per_attempt ))
		to_chat(user, SPAN_WARNING("[src] battery is dead or missing."))
		return
	var/turf/current_location = get_turf(user)//What turf is the user on?
	if(!current_location||current_location.z==2||current_location.z>=7)//If turf was not found or they're on z level 2 or >7 which does not currently exist.
		to_chat(user, SPAN_NOTICE("\The [src] is malfunctioning."))
		return
	var/list/L = list()
	for(var/obj/machinery/teleport/hub/R in world)
		var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if (istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use)
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked
			else
				L["[com.id] (Inactive)"] = com.locked
	var/list/turfs = list()
	var/turf/TLoc = get_turf(src)
	for(var/turf/T in trange(10, TLoc) - TLoc)
		if(T.x > world.maxx - 8 || T.x < 8) //putting them at the edge is dumb
			continue
		if(T.y > world.maxy - 8 || T.y < 8)
			continue
		turfs += T
	if(turfs.len)
		L["None (Dangerous)"] = pick(turfs)
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
	if ((user.get_active_hand() != src || user.stat || user.restrained()))
		return
	var/T = L[t1]
	to_chat(user, SPAN_NOTICE("Portal locked in."))
	var/obj/effect/portal/P = new portal_type(get_turf(src))
	P.set_target(T)
	if(portal_fail_chance)
		P.failchance = portal_fail_chance
	src.add_fingerprint(user)

/obj/item/weapon/hand_tele/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/weapon/hand_tele/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C


///////////////////////////////////////
////////////HANDMADE TELE-STUFF////////
///////////////////////////////////////

/obj/item/weapon/hand_tele/handmade
	name = "Handmade hand-teleporter"
	desc = "Handmade version of hand-tele. Woah, that's was they call an experimental science!"
	icon_state = "hm_hand-tele"
	portal_type = /obj/effect/portal/unstable
	portal_fail_chance = 50
	cell_charge_per_attempt = 50
	var/calibration_required = TRUE

/obj/item/weapon/hand_tele/handmade/attackby(obj/item/C, mob/living/user)
	..()
	if(istype(C, /obj/item/weapon/tool/screwdriver))
		if(user.a_intent == I_HURT)
			if(prob(5))
				var/turf/teleport_location = pick( getcircle(user.loc, 3) )
				user.drop_from_inventory(user.get_active_hand())
				user.drop_from_inventory(user.get_inactive_hand())
				if(teleport_location)
					do_teleport(user, teleport_location, 1)
					return
			if(do_after(user, 30))
				if(calibration_required)
					to_chat(user, SPAN_WARNING("You loosen [src]'s calibration, it'll probably fail when used now"))
					portal_fail_chance = 90
					calibration_required = FALSE
				else
					calibration_required = TRUE
					to_chat(user, SPAN_NOTICE("You recalibrate [src]. It'll probably function now"))
					portal_fail_chance = 50
		else
			if(do_after(user, 30))
				if(calibration_required)
					var/user_intelligence = user.stats.getStat(STAT_COG)
					portal_fail_chance -= user_intelligence
					if(portal_fail_chance < 0)
						portal_fail_chance = 0
					calibration_required = FALSE
					to_chat(user, SPAN_NOTICE("You carefully place bluespace crystal into slot to the end, and tweak the circuit with your [C]. [src] now looks more reliable."))
				else
					to_chat(user, SPAN_WARNING("[src] is calibrated already. You can decalibrate it with some harmful effort."))

/obj/item/weapon/tele_spear
	name = "Telespear"
	desc = "This is just a stick with dodgy device at the end."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telespear"
	item_state = "telespear"
	slot_flags = SLOT_BACK

/obj/item/weapon/tele_spear/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 65, 1)
	var/turf/teleport_location = pick( getcircle(user.loc, 8) )
	if(prob(5))
		do_teleport(user, teleport_location, 1)
	else
		do_teleport(M, teleport_location, 1)
	qdel(src)
	var/obj/item/stack/rods/R = new(M.loc)
	user.put_in_active_hand(R)