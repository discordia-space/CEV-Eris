/obj/machinery/sleeper
	name = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis69achine, and a limited health scanner."
	icon = 'icons/obj/Cryo69enic2.dmi'
	icon_state = "sleeper_0"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/electronics/circuitboard/sleeper
	var/mob/livin69/carbon/human/occupant = null
	var/list/available_chemicals = list("inaprovaline2" = "Synth-Inaprovaline", "stoxin" = "Soporific", "paracetamol" = "Paracetamol", "anti_toxin" = "Dylovene", "dexalin" = "Dexalin", "tricordrazine" = "Tricordrazine")
	var/obj/item/rea69ent_containers/69lass/beaker = null
	var/filterin69 = 0

	use_power = IDLE_POWER_USE
	idle_power_usa69e = 15
	active_power_usa69e = 200 //builtin health analyzer, dialysis69achine, injectors.

/obj/machinery/sleeper/Initialize()
	. = ..()
	beaker = new /obj/item/rea69ent_containers/69lass/beaker/lar69e(src)
	update_icon()

/obj/machinery/sleeper/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filterin69 > 0)
		if(beaker)
			if(beaker.rea69ents.total_volume < beaker.rea69ents.maximum_volume)
				var/pumped = 0
				for(var/datum/rea69ent/x in occupant.rea69ents.rea69ent_list)
					occupant.rea69ents.trans_to_obj(beaker, 3)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			to6969le_filter()

/obj/machinery/sleeper/update_icon()
	icon_state = "sleeper_69occupant ? "1" : "0"69"

/obj/machinery/sleeper/attack_hand(var/mob/user)
	if(..())
		return 1

	ui_interact(user)

/obj/machinery/sleeper/ui_interact(var/mob/user,69ar/ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS,69ar/datum/topic_state/state =69LOB.outside_state)
	var/data69069

	data69"power"69 = stat & (NOPOWER|BROKEN) ? 0 : 1

	var/list/rea69ents = list()
	for(var/T in available_chemicals)
		var/list/rea69ent = list()
		rea69ent69"id"69 = T
		rea69ent69"name"69 = available_chemicals69T69
		if(occupant)
			rea69ent69"amount"69 = occupant.rea69ents.69et_rea69ent_amount(T)
		rea69ents += list(rea69ent)
	data69"rea69ents"69 = rea69ents.Copy()

	if(occupant)
		data69"occupant"69 = 1
		switch(occupant.stat)
			if(CONSCIOUS)
				data69"stat"69 = "Conscious"
			if(UNCONSCIOUS)
				data69"stat"69 = "Unconscious"
			if(DEAD)
				data69"stat"69 = "<font color='red'>Dead</font>"
		data69"health"69 = occupant.health
		if(ishuman(occupant))
			var/mob/livin69/carbon/human/H = occupant
			data69"pulse"69 = H.69et_pulse(69ETPULSE_TOOL)
		data69"brute"69 = occupant.69etBruteLoss()
		data69"burn"69 = occupant.69etFireLoss()
		data69"oxy"69 = occupant.69etOxyLoss()
		data69"tox"69 = occupant.69etToxLoss()
	else
		data69"occupant"69 = 0
	if(beaker)
		data69"beaker"69 = beaker.rea69ents.69et_free_space()
	else
		data69"beaker"69 = -1
	data69"filterin69"69 = filterin69

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/sleeper/Topic(href, href_list)
	if(..())
		return 1

	if(usr == occupant)
		to_chat(usr, SPAN_WARNIN69("You can't reach the controls from the inside."))
		return

	add_fin69erprint(usr)

	if(href_list69"eject"69)
		69o_out()
	if(href_list69"beaker"69)
		remove_beaker()
	if(href_list69"filter"69)
		if(filterin69 != text2num(href_list69"filter"69))
			to6969le_filter()
	if(href_list69"chemical"69 && href_list69"amount"69)
		if(occupant && occupant.stat != DEAD)
			if(href_list69"chemical"69 in available_chemicals) // Your hacks are bad and you should feel bad
				inject_chemical(usr, href_list69"chemical"69, text2num(href_list69"amount"69))

	playsound(loc, 'sound/machines/button.o6969', 100, 1)
	return 1

/obj/machinery/sleeper/attackby(var/obj/item/I,69ar/mob/user)
	add_fin69erprint(user)
	if(istype(I, /obj/item/rea69ent_containers/69lass))
		if(!beaker)
			beaker = I
			user.drop_item()
			I.loc = src
			user.visible_messa69e(SPAN_NOTICE("\The 69user69 adds \a 69I69 to \the 69src69."), SPAN_NOTICE("You add \a 69I69 to \the 69src69."))
		else
			to_chat(user, SPAN_WARNIN69("\The 69src69 has a beaker already."))
		return

/obj/machinery/sleeper/affect_69rab(var/mob/user,69ar/mob/tar69et)
	69o_in(tar69et, user)

/obj/machinery/sleeper/MouseDrop_T(var/mob/tar69et,69ar/mob/user)
	if(user.stat || user.lyin69 || !Adjacent(user) || !tar69et.Adjacent(user)|| !ishuman(tar69et))
		return
	69o_in(tar69et, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	69o_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filterin69)
		to6969le_filter()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		69o_out()

	..(severity)
/obj/machinery/sleeper/proc/to6969le_filter()
	if(!occupant || !beaker)
		filterin69 = 0
		return
	filterin69 = !filterin69

/obj/machinery/sleeper/proc/69o_in(var/mob/M,69ar/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is already occupied."))
		return

	if(M == user)
		visible_messa69e("\The 69user69 starts climbin69 into \the 69src69.")
	else
		visible_messa69e("\The 69user69 starts puttin69 69M69 into \the 69src69.")

	if(do_after(user, 20, src))
		if(occupant)
			to_chat(user, SPAN_WARNIN69("\The 69src69 is already occupied."))
			return
		M.stop_pullin69()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		update_use_power(2)
		occupant =69
		update_icon()

/obj/machinery/sleeper/proc/69o_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective =69OB_PERSPECTIVE
	occupant.forceMove(69et_turf(src))
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or somethin69
		if(A == beaker)
			continue
		A.loc = loc
	update_use_power(1)
	update_icon()
	to6969le_filter()

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.loc = loc
		beaker = null
		to6969le_filter()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/livin69/user,69ar/chemical,69ar/amount)
	if(stat & (BROKEN|NOPOWER))
		return

	if(occupant && occupant.rea69ents)
		if(occupant.rea69ents.69et_rea69ent_amount(chemical) + amount <= 20)
			use_power(amount * CHEM_SYNTH_ENER69Y)
			occupant.rea69ents.add_rea69ent(chemical, amount)
			to_chat(user, "Occupant now has 69occupant.rea69ents.69et_rea69ent_amount(chemical)69 units of 69available_chemicals69chemical6969 in their bloodstream.")
		else
			to_chat(user, "The subject has too69any chemicals.")
	else
		to_chat(user, "There's no suitable occupant in \the 69src69.")

/obj/machinery/sleeper/verb/eject_occupant_verb()
	set name = "Eject Occupant"
	set desc = "Force eject occupant."
	set cate69ory = "Object"
	set src in69iew(1)

	if (usr.incapacitated() || occupant == usr)
		return

	69o_out()
