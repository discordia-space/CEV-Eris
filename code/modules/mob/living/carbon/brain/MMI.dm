//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/device/mmi/digital/New()
	brainmob =69ew(src)
	brainmob.stat = CONSCIOUS
	brainmob.add_language(LANGUAGE_ROBOT)
	brainmob.container = src
	brainmob.silent = 0
	..()

/obj/item/device/mmi/digital/transfer_identity(mob/living/carbon/H)
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.stat = 0
	if(H.mind)
		H.mind.transfer_to(brainmob)
	return

/obj/item/device/mmi
	name = "man-machine interface"
	desc = "The Warrior's bland acronym,69MI, obscures the true horror of this69onstrosity."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 3)
	matter = list(MATERIAL_STEEL = 5,69ATERIAL_GLASS = 3)
	req_access = list(access_robotics)

	//Revised. Brainmob is69ow contained directly within object of transfer.69MI in this case.

	var/locked = 0
	var/mob/living/carbon/brain/brainmob =69ull//The current occupant.
	var/obj/item/organ/internal/brain/brainobj =69ull	//The current brain organ.

/obj/item/device/mmi/attackby(var/obj/item/O as obj,69ar/mob/user as69ob)
	if(istype(O,/obj/item/organ/internal/brain) && !brainmob) //Time to stick a brain in it --NEO

		var/obj/item/organ/internal/brain/B = O
		if(B.health <= 0)
			to_chat(user, "\red That brain is well and truly dead.")
			return
		else if(!B.brainmob)
			to_chat(user, "\red You aren't sure where this brain came from, but you're pretty sure it's a useless brain.")
			return
		var/mob/living/carbon/brain/BM = B.brainmob
		if(!BM.client)
			for(var/mob/observer/ghost/G in GLOB.player_list)
				if(G.can_reenter_corpse && G.mind == BM.mind)
					if(alert(G, "Somebody is attempting to put your brain in an69MI. Would you like to return to it?","Become brain","OH YES","No") == "OH YES")
						G.reenter_corpse()
						break
			if(!BM.client)
				to_chat(user, SPAN_WARNING("\The 69src69 indicates that \the 69B69 is unresponsive."))
				return

		for(var/mob/V in69iewers(src,69ull))
			V.show_message(text("\blue 69user69 sticks \a 69O69 into \the 69src69."))

		brainmob = B.brainmob
		brainmob.loc = src
		brainmob.container = src
		brainmob.stat = 0
		GLOB.dead_mob_list -= brainmob//Update dem lists
		GLOB.living_mob_list += brainmob

		user.drop_item()
		brainobj = O
		brainobj.loc = src

		name = "Man-Machine Interface: 69brainmob.real_name69"
		icon_state = "mmi_full"

		locked = 1



		return

	if((istype(O,/obj/item/card/id)||istype(O,/obj/item/modular_computer/pda)) && brainmob)
		if(allowed(user))
			locked = !locked
			to_chat(user, "\blue You 69locked ? "lock" : "unlock"69 the brain holder.")
		else
			to_chat(user, "\red Access denied.")
		return
	if(brainmob)
		O.attack(brainmob, user)//Oh69oooeeeee
		return
	..()

	//TODO: ORGAN REMOVAL UPDATE.69ake the brain remain in the69MI so it doesn't lose organ data.
/obj/item/device/mmi/attack_self(mob/user as69ob)
	if(!brainmob)
		to_chat(user, "\red You upend the69MI, but there's69othing in it.")
	else if(locked)
		to_chat(user, "\red You upend the69MI, but the brain is clamped into place.")
	else
		to_chat(user, "\blue You upend the69MI, spilling the brain onto the floor.")
		var/obj/item/organ/internal/brain/brain
		if (brainobj)	//Pull brain organ out of69MI.
			brainobj.loc = user.loc
			brain = brainobj
			brainobj =69ull
		else	//Or69ake a69ew one if empty.
			brain =69ew(user.loc)
		brainmob.container =69ull//Reset brainmob69mi69ar.
		brainmob.loc = brain//Throw69ob into brain.
		GLOB.living_mob_list -= brainmob//Get outta here
		brain.brainmob = brainmob//Set the brain to use the brainmob
		brainmob =69ull//Set69mi brainmob69ar to69ull

		icon_state = "mmi_empty"
		name = "Man-Machine Interface"

/obj/item/device/mmi/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob =69ew(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	name = "Man-Machine Interface: 69brainmob.real_name69"
	icon_state = "mmi_full"
	locked = 1
	return

/obj/item/device/mmi/relaymove(var/mob/user,69ar/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.forced_move(direction, user)

/obj/item/device/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi =69ull
	if(brainmob)
		qdel(brainmob)
		brainmob =69ull
	. = ..()

/obj/item/device/mmi/radio_enabled
	name = "radio-enabled69an-machine interface"
	desc = "The Warrior's bland acronym,69MI, obscures the true horror of this69onstrosity. This one comes with a built-in radio."
	origin_tech = list(TECH_BIO = 4)

	var/obj/item/device/radio/radio =69ull//Let's give it a radio.

/obj/item/device/mmi/radio_enabled/New()
	. = ..()
	radio =69ew(src)//Spawns a radio inside the69MI.
	radio.broadcasting = 1//So it's broadcasting from the start.

//Allows the brain to toggle the radio functions.
/obj/item/device/mmi/radio_enabled/verb/Toggle_Broadcasting()
	set69ame = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "MMI"
	set src = usr.loc//In user location, or in69MI in this case.
	set popup_menu = 0//Will69ot appear when right clicking.

	if(brainmob.stat)//Only the brainmob will trigger these so69o further check is69ecessary.
		to_chat(brainmob, "Can't do that while incapacitated or dead.")

	radio.broadcasting = radio.broadcasting==1 ? 0 : 1
	to_chat(brainmob, "\blue Radio is 69radio.broadcasting==1 ? "now" : "no longer"69 broadcasting.")

/obj/item/device/mmi/radio_enabled/verb/Toggle_Listening()
	set69ame = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "MMI"
	set src = usr.loc
	set popup_menu = 0

	if(brainmob.stat)
		to_chat(brainmob, "Can't do that while incapacitated or dead.")

	radio.listening = radio.listening==1 ? 0 : 1
	to_chat(brainmob, "\blue Radio is 69radio.listening==1 ? "now" : "no longer"69 receiving broadcast.")

/obj/item/device/mmi/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage += rand(20,30)
			if(2)
				brainmob.emp_damage += rand(10,20)
			if(3)
				brainmob.emp_damage += rand(0,10)
	..()
