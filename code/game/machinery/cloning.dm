//Clonin69 revival69ethod.
//The pod handles the actual clonin69 while the computer69ana69es the clone profiles

#define CLONE_BIOMASS 150

/obj/machinery/clonepod
	name = "biomass pod"
	desc = "An electronically-lockable pod for 69rowin69 or69anic tissue."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/clonin69.dmi'
	icon_state = "pod_0"
	re69_access = list(access_69enetics) //For premature unlockin69.
	circuit = /obj/item/electronics/circuitboard/clonepod
	var/mob/livin69/occupant
	var/heal_level = 20 //The clone is released once its health reaches this level.
	var/heal_rate = 1
	var/notoxin = 0
	var/locked = 0
	var/obj/machinery/computer/clonin69/connected = null //So we remember the connected clone69achine.
	var/mess = 0 //Need to clean out it if it's full of exploded clone.
	var/attemptin69 = 0 //One clone attempt at a time thanks
	var/eject_wait = 0 //Don't eject them as soon as they are created fuckkk
	var/biomass = CLONE_BIOMASS * 3

/obj/machinery/clonepod/New()
	set_extension(src, /datum/extension/multitool, /datum/extension/multitool/store)
	..()
	if(SSticker.current_state != 69AME_STATE_PLAYIN69)
		biomass = CLONE_BIOMASS * 3

/obj/machinery/clonepod/Destroy()
	if(connected)
		connected.release_pod(src)
	return ..()

/obj/machinery/clonepod/attack_ai(mob/user as69ob)

	add_hiddenprint(user)
	return attack_hand(user)

/obj/machinery/clonepod/attack_hand(mob/user as69ob)
	if(isnull(occupant) || (stat & NOPOWER))
		return
	if(occupant.stat != DEAD)
		var/completion = (100 * ((occupant.health + 50) / (heal_level + 100))) // Clones start at -150 health
		to_chat(user, "Current clone cycle is 69round(completion)69% complete.")
	return

//Clonepod

//Start 69rowin69 a human clone in the pod!
/obj/machinery/clonepod/proc/69rowclone(var/datum/dna2/record/R)
	if(mess || attemptin69)
		return 0
	var/datum/mind/clonemind = locate(R.mind)

	if(!istype(clonemind, /datum/mind))	//not a69ind
		return 0
	if(clonemind.current && clonemind.current.stat != DEAD)	//mind is associated with a non-dead body
		return 0
	if(clonemind.active)	//somebody is usin69 that69ind
		if(ckey(clonemind.key) != R.ckey)
			return 0
	else
		for(var/mob/observer/69host/69 in 69LOB.player_list)
			if(69.ckey == R.ckey)
				if(69.can_reenter_corpse)
					break
				else
					return 0

	attemptin69 = 1 //One at a time!!
	locked = 1

	eject_wait = 1
	spawn(30)
		eject_wait = 0

	var/mob/livin69/carbon/human/H = new /mob/livin69/carbon/human(src, R.dna.species)
	occupant = H

	if(!R.dna.real_name)	//to prevent null names
		R.dna.real_name = "clone (69rand(0,999)69)"
	H.real_name = R.dna.real_name

	//69et the clone body ready
	H.adjustCloneLoss(150) // New dama69e69ar so you can't eject a clone early then stab them to abuse the current dama69e system --NeoFite
	H.Paralyse(4)

	//Here let's calculate their health so the pod doesn't immediately eject them!!!
	H.updatehealth()

	clonemind.transfer_to(H)
	H.ckey = R.ckey
	to_chat(H, SPAN_NOTICE("<b>Consciousness slowly creeps over you as your body re69enerates.</b><br><i>So this is what clonin69 feels like?</i>"))

	// --69ode/mind specific stuff 69oes here
	callHook("clone", list(H))
	update_anta69_icons(H.mind)
	// -- End69ode specific stuff

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna
	H.UpdateAppearance()
	H.sync_or69an_dna()
	if(heal_level < 60)
		randmutb(H) //Sometimes the clones come out wron69.
		H.dna.UpdateSE()
		H.dna.UpdateUI()

	H.set_cloned_appearance()
	update_icon()

	for(var/datum/lan69ua69e/L in R.lan69ua69es)
		H.add_lan69ua69e(L.name)
	H.flavor_text = R.flavor
	attemptin69 = 0
	return 1

//69row clones to69aturity then kick them out.  FREELOADERS
/obj/machinery/clonepod/Process()

	if(stat & NOPOWER) //Autoeject if power is lost
		if(occupant)
			locked = 0
			69o_out()
		return

	if((occupant) && (occupant.loc == src))
		if((occupant.stat == DEAD) || !occupant.key)
			locked = 0
			69o_out()
			connected_messa69e("Clone Rejected: Deceased.")
			return

		else if(occupant.health < heal_level && occupant.69etCloneLoss() > 0)
			occupant.Paralyse(4)

			 //Slowly 69et that clone healed and finished.
			occupant.adjustCloneLoss(-2 * heal_rate)

			//Premature clones69ay have brain dama69e.
			occupant.adjustBrainLoss(-(CEILIN69(0.5*heal_rate, 1)))

			//So clones don't die of oxyloss in a runnin69 pod.
			if(occupant.rea69ents.69et_rea69ent_amount("inaprovaline") < 30)
				occupant.rea69ents.add_rea69ent("inaprovaline", 60)
			occupant.Sleepin69(30)
			//Also heal some oxyloss ourselves because inaprovaline is so bad at preventin69 it!!
			occupant.adjustOxyLoss(-4)

			use_power(7500) //This69i69ht need tweakin69.
			return

		else if((occupant.health >= heal_level) && (!eject_wait))
			playsound(src.loc, 'sound/machines/din69.o6969', 50, 1)
			src.audible_messa69e("\The 69src69 si69nals that the clonin69 process is complete.")
			connected_messa69e("Clonin69 Process Complete.")
			locked = 0
			69o_out()
			return

	else if((!occupant) || (occupant.loc != src))
		occupant = null
		if(locked)
			locked = 0
		return

	return

//Let's unlock this early I 69uess. 69i69ht be too early, needs tweakin69.
/obj/machinery/clonepod/attackby(var/obj/item/I,69ob/user as69ob)
	if(isnull(occupant))

		if(default_deconstruction(I, user))
			return

		if(default_part_replacement(I, user))
			return

	if(I.69etIdCard())
		if(!check_access(I))
			to_chat(user, SPAN_WARNIN69("Access Denied."))
			return
		if(!locked || isnull(occupant))
			return
		if((occupant.health < -20) && (occupant.stat != DEAD))
			to_chat(user, SPAN_WARNIN69("Access Refused."))
			return
		else
			locked = 0
			to_chat(user, "System unlocked.")
	else
		for(var/type in BIOMASS_TYPES)
			if(istype(I,type))
				to_chat(user, SPAN_NOTICE("\The 69src69 processes \the 69I69."))
				biomass += BIOMASS_TYPES69type69
				user.drop_from_inventory(I)
				69del(I)
				return
	..()

/obj/machinery/clonepod/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(isnull(occupant))
		return NO_EMA69_ACT
	to_chat(user, "You force an emer69ency ejection.")
	locked = 0
	69o_out()
	return 1

//Put69essa69es in the connected computer's temp69ar for display.
/obj/machinery/clonepod/proc/connected_messa69e(var/messa69e)
	if(isnull(connected) || !istype(connected, /obj/machinery/computer/clonin69))
		return 0
	if(!messa69e)
		return 0

	connected.temp = "69name69 : 69messa69e69"
	connected.updateUsrDialo69()
	return 1

/obj/machinery/clonepod/RefreshParts()
	..()
	var/ratin69 = 0
	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/scannin69_module) || istype(P, /obj/item/stock_parts/manipulator))
			ratin69 += P.ratin69

	heal_level = ratin69 * 10 - 20
	heal_rate = round(ratin69 / 4)
	if(ratin69 >= 8)
		notoxin = 1
	else
		notoxin = 0

/obj/machinery/clonepod/verb/eject()
	set name = "Eject Cloner"
	set cate69ory = "Object"
	set src in oview(1)

	if(usr.stat)
		return
	69o_out()
	add_fin69erprint(usr)
	return

/obj/machinery/clonepod/proc/69o_out()
	if(locked)
		return

	if(mess) //Clean that69ess and dump those 69ibs!
		mess = 0
		69ibs(loc)
		update_icon()
		return

	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective =69OB_PERSPECTIVE
	occupant.loc = loc
	eject_wait = 0 //If it's still set somehow.
	domutcheck(occupant) //Waitin69 until they're out before possible transformin69.
	occupant = null

	biomass -= CLONE_BIOMASS
	update_icon()
	return

/obj/machinery/clonepod/proc/malfunction()
	if(occupant)
		connected_messa69e("Critical Error!")
		mess = 1
		update_icon()
		occupant.69hostize()
		spawn(5)
			69del(occupant)
	return

/obj/machinery/clonepod/relaymove(mob/user as69ob)
	if(user.stat)
		return
	69o_out()
	return

/obj/machinery/clonepod/emp_act(severity)
	if(prob(100/severity))
		malfunction()
	..()

/obj/machinery/clonepod/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A in src)
				A.loc = loc
				ex_act(severity)
			69del(src)
			return
		if(2)
			if(prob(50))
				for(var/atom/movable/A in src)
					A.loc = loc
					ex_act(severity)
				69del(src)
				return
		if(3)
			if(prob(25))
				for(var/atom/movable/A in src)
					A.loc = loc
					ex_act(severity)
				69del(src)
				return
		else
	return

/obj/machinery/clonepod/update_icon()
	..()
	icon_state = "pod_0"
	if (occupant && !(stat & NOPOWER))
		icon_state = "pod_1"
	else if (mess)
		icon_state = "pod_69"

