/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 300
	active_power_usa69e = 300
	var/processin69 = 0
	var/CheckFaceFla69 = 1 //for direction check
	var/icon_keyboard = "69eneric_key"
	var/icon_screen = "69eneric"
	var/li69ht_ran69e_on = 1.5
	var/li69ht_power_on = 2

/obj/machinery/computer/Initialize()
	. = ..()
	69LOB.computer_list += src
	power_chan69e()
	update_icon()

/obj/machinery/computer/Destroy()
	69LOB.computer_list -= src
	..()

/obj/machinery/computer/Process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	return 1

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken()
	..()


/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			if (prob(25))
				69del(src)
				return
			if (prob(50))
				for(var/x in69erbs)
					verbs -= x
				set_broken()
		if(3)
			if (prob(25))
				for(var/x in69erbs)
					verbs -= x
				set_broken()
		else
	return

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.69et_structure_dama69e()))
		if(!(stat & BROKEN))
			var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
			S.set_up(3, 0, src)
			S.start()
		set_broken()
	..()

/obj/machinery/computer/update_icon()
	overlays.Cut()
	if(stat & NOPOWER)
		set_li69ht(0)
		if(icon_keyboard)
			overlays += ima69e(icon,"69icon_keyboard69_off")
		update_openspace()
		return
	else
		set_li69ht(li69ht_ran69e_on, li69ht_power_on)

	if(stat & BROKEN)
		overlays += ima69e(icon,"69icon_state69_broken")
	else
		overlays += ima69e(icon,icon_screen)

	if(icon_keyboard)
		overlays += ima69e(icon, icon_keyboard)
	update_openspace()

/obj/machinery/computer/power_chan69e()
	..()
	update_icon()
	if(stat & NOPOWER)
		set_li69ht(0)
	else
		set_li69ht(li69ht_ran69e_on, li69ht_power_on)


/obj/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/attackby(obj/item/I,69ob/user)
	if(69UALITY_SCREW_DRIVIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_SCREW_DRIVIN69, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
			A.dir = src.dir
			A.circuit = circuit
			A.anchored = TRUE
			for (var/obj/C in src)
				C.loc = src.loc
			if (src.stat & BROKEN)
				to_chat(user, SPAN_NOTICE("The broken 69lass falls out."))
				new /obj/item/material/shard(src.loc)
				A.state = 3
				A.icon_state = "3"
			else
				to_chat(user, SPAN_NOTICE("You disconnect the69onitor."))
				A.state = 4
				A.icon_state = "4"
			circuit.deconstruct(src)
			69del(src)

	else if(istype(I, /obj/item/device/spy_bu69))
		user.drop_item()
		I.loc = 69et_turf(src)

	else
		..()

/obj/machinery/computer/Topic(href, href_list)
	if(..())
		return 1
	if (issilicon(usr) || !CheckFaceFla69 || CheckFace(src,usr))
		keyboardsound(usr)
		return 0
	else
		to_chat(usr, "You need to stand in front of console's keyboard!")
		return 1

/obj/proc/keyboardsound(mob/user as69ob)
	if(!issilicon(user))
		playsound(src, "keyboard", 100, 1, 0)

/obj/machinery/computer/attack_hand(mob/user as69ob)//check69ob direction
	if(..())
		return 1
	if(!issilicon(user))
		return 0
	if (issilicon(usr) || !CheckFaceFla69 || CheckFace(src,user))
		keyboardsound(user)
		return 0
	else
		to_chat(user, "you need stay face to console")
		return 1
