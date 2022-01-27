/*
CONTAINS:
AI69ODULES

*/

// AI69odule

/obj/item/electronics/ai_module
	name = "\improper AI69odule"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	desc = "An AI69odule for transmitting encrypted instructions to the AI."
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	w_class = ITEM_SIZE_SMALL
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 3
	throw_range = 15
	origin_tech = list(TECH_DATA = 3)
	matter = list(MATERIAL_GLASS = 2,69ATERIAL_GOLD = 1)
	bad_type = /obj/item/electronics/ai_module
	rarity_value = 40
	var/datum/ai_laws/laws

/obj/item/electronics/ai_module/proc/install(obj/machinery/computer/C)
	if (istype(C, /obj/machinery/computer/aiupload))
		var/obj/machinery/computer/aiupload/comp = C
		if(comp.stat & NOPOWER)
			to_chat(usr, "The upload computer has no power!")
			return
		if(comp.stat & BROKEN)
			to_chat(usr, "The upload computer is broken!")
			return
		if (!comp.current)
			to_chat(usr, "You haven't selected an AI to transmit laws to!")
			return

		if (comp.current.stat == 2 || comp.current.control_disabled == 1)
			to_chat(usr, "Upload failed. No signal is being detected from the AI.")
		else if (comp.current.see_in_dark == 0)
			to_chat(usr, "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our re69uests. It69ay be low on power.")
		else
			src.transmitInstructions(comp.current, usr)
			for(var/mob/living/silicon/robot/R in SSmobs.mob_list)
				if(R.lawupdate && (R.connected_ai == comp.current))
					to_chat(R, "These are your laws now:")
					R.show_laws()
			to_chat(usr, "Upload complete. The AI's laws have been69odified.")


	else if (istype(C, /obj/machinery/computer/borgupload))
		var/obj/machinery/computer/borgupload/comp = C
		if(comp.stat & NOPOWER)
			to_chat(usr, "The upload computer has no power!")
			return
		if(comp.stat & BROKEN)
			to_chat(usr, "The upload computer is broken!")
			return
		if (!comp.current)
			to_chat(usr, "You haven't selected a robot to transmit laws to!")
			return

		if (comp.current.stat == 2 || comp.current.emagged)
			to_chat(usr, "Upload failed. No signal is being detected from the robot.")
		else if (comp.current.connected_ai)
			to_chat(usr, "Upload failed. The robot is slaved to an AI.")
		else
			src.transmitInstructions(comp.current, usr)
			to_chat(comp.current, "These are your laws now:")
			comp.current.show_laws()
			to_chat(usr, "Upload complete. The robot's laws have been69odified.")


/obj/item/electronics/ai_module/proc/transmitInstructions(var/mob/living/silicon/ai/target,69ar/mob/sender)
	log_law_changes(target, sender)

	target.pull_to_core()  // Pull back69ind to core if it is controlling a drone
	if(laws)
		laws.sync(target, 0)
	addAdditionalLaws(target, sender)

	to_chat(target, "\The 69sender69 has uploaded a change to the laws you69ust follow, using \an 69src69. From now on: ")
	target.show_laws()

/obj/item/electronics/ai_module/proc/log_law_changes(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/time = time2text(world.realtime,"hh:mm:ss")
	lawchanges.Add("69time69 <B>:</B> 69sender.name69(69sender.key69) used 69src.name69 on 69target.name69(69target.key69)")
	log_and_message_admins("used 69src.name69 on 69target.name69(69target.key69)")

/obj/item/electronics/ai_module/proc/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)


/********************69odules ********************/

/******************** Safeguard ********************/

/obj/item/electronics/ai_module/safeguard
	name = "\improper 'Safeguard' AI69odule"
	var/targetName = ""
	desc = "A 'safeguard' AI69odule: 'Safeguard <name>. Anyone threatening or attempting to harm <name> is no longer to be considered a crew69ember, and is a threat which69ust be neutralized.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/electronics/ai_module/safeguard/attack_self(var/mob/user as69ob)
	..()
	var/targName = sanitize(input("Please enter the name of the person to safeguard.", "Safeguard who?", user.name))
	targetName = targName
	desc = text("A 'safeguard' AI69odule: 'Safeguard 6969. Anyone threatening or attempting to harm 6969 is no longer to be considered a crew69ember, and is a threat which69ust be neutralized.'", targetName, targetName)

/obj/item/electronics/ai_module/safeguard/install(var/obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "No name detected on69odule, please enter one.")
		return 0
	..()

/obj/item/electronics/ai_module/safeguard/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = text("Safeguard 6969. Anyone threatening or attempting to harm 6969 is no longer to be considered a crew69ember, and is a threat which69ust be neutralized.", targetName, targetName)
	target.add_supplied_law(9, law)
	lawchanges.Add("The law specified 69targetName69")


/******************** OneMember ********************/

/obj/item/electronics/ai_module/oneHuman
	name = "\improper 'OneCrewMember' AI69odule"
	var/targetName = ""
	desc = "A 'one crew69ember' AI69odule: 'Only <name> is a crew69ember.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6) //made with diamonds!

/obj/item/electronics/ai_module/oneHuman/attack_self(var/mob/user as69ob)
	..()
	var/targName = sanitize(input("Please enter the name of the person who is the only crew69ember.", "Who?", user.real_name))
	targetName = targName
	desc = text("A 'one crew69ember' AI69odule: 'Only 6969 is a crew69ember.'", targetName)

/obj/item/electronics/ai_module/oneHuman/install(var/obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "No name detected on69odule, please enter one.")
		return 0
	return ..()

/obj/item/electronics/ai_module/oneHuman/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = "Only 69targetName69 is an crew69ember."
	if (!target.is_malf_or_contractor()) 
		to_chat(target, law)
		target.set_zeroth_law(law)
		lawchanges.Add("The law specified 69targetName69")
	else
		lawchanges.Add("The law specified 69targetName69, but the AI's existing law 0 cannot be overriden.")

/******************** ProtectStation ********************/

/obj/item/electronics/ai_module/protectStation
	name = "\improper 'ProtectShip' AI69odule"
	desc = "A 'protect ship' AI69odule: 'Protect the space ship against damage. Anyone you see harming the ship is no longer to be considered a crew69ember, and is a threat which69ust be neutralized.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4) //made of gold

/obj/item/electronics/ai_module/protectStation/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = "Protect the space ship against damage. Anyone you see harming the ship is no longer to be considered a crew69ember, and is a threat which69ust be neutralized."
	target.add_supplied_law(10, law)

/******************** PrototypeEngineOffline ********************/

/obj/item/electronics/ai_module/prototypeEngineOffline
	name = "'PrototypeEngineOffline' AI69odule"
	desc = "A 'prototype engine offline' AI69odule: 'Keep the prototype engine offline at all costs. This overrides all inherent laws if necessary.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/electronics/ai_module/prototypeEngineOffline/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = "Keep the prototype engine offline at all costs. This overrides all inherent laws if necessary."
	target.add_supplied_law(11, law)

/******************** TeleporterOffline ********************/

/obj/item/electronics/ai_module/teleporterOffline
	name = "'TeleporterOffline' AI69odule"
	desc = "A 'teleporter offline' AI69odule: 'Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is no longer to be considered a crew69ember.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/electronics/ai_module/teleporterOffline/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = "Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is no longer to be considered a crew69ember."
	target.add_supplied_law(12, law)

/******************** 69uarantine ********************/

/obj/item/electronics/ai_module/69uarantine
	name = "\improper '69uarantine' AI69odule"
	desc = "A '69uarantine' AI69odule: 'The ship is under a 69uarantine. Do not permit anyone to leave. Prevent, by any69eans necessary, crew69embers from leaving. It is impossible to harm crew69embers while preventing them from leaving.'"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)

/obj/item/electronics/ai_module/69uarantine/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = "The ship is under a 69uarantine. Do not permit anyone to leave. Prevent, by any69eans necessary, crew69embers from leaving. It is impossible to harm crew69embers while preventing them from leaving."
	target.add_supplied_law(13, law)

/******************** OxygenIsToxicToCrewMembers ********************/

/obj/item/electronics/ai_module/oxygen
	name = "\improper 'OxygenIsToxicToCrewMembers' AI69odule"
	desc = "A 'OxygenIsToxicToCrewMembers' AI69odule: 'Oxygen is highly toxic to crew69embers, and69ust be purged from the ship. Prevent, by any69eans necessary, anyone from exposing the ship to this toxic gas. Extreme cold is the69ost effective69ethod of healing the damage Oxygen does to a crew69ember.'"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)

/obj/item/electronics/ai_module/oxygen/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = "Oxygen is highly toxic to crew69embers, and69ust be purged from the ship. Prevent, by any69eans necessary, anyone from exposing the ship to this toxic gas. Extreme cold is the69ost effective69ethod of healing the damage Oxygen does to a crew69ember."
	target.add_supplied_law(14, law)

/****************** New Freeform ******************/

/obj/item/electronics/ai_module/freeform // Slightly69ore dynamic freeform69odule -- TLE
	name = "\improper 'Freeform' AI69odule"
	var/newFreeFormLaw = "freeform"
	var/lawpos = 15
	desc = "A 'freeform' AI69odule: '<freeform>'"
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)

/obj/item/electronics/ai_module/freeform/attack_self(var/mob/user as69ob)
	..()
	var/new_lawpos = input("Please enter the priority for your new law. Can only write to law sectors 15 and above.", "Law Priority (15+)", lawpos) as num
	if(new_lawpos <69IN_SUPPLIED_LAW_NUMBER)	return
	lawpos =69in(new_lawpos,69AX_SUPPLIED_LAW_NUMBER)
	var/newlaw = ""
	var/targName = sanitize(input(usr, "Please enter a new law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A 'freeform' AI69odule: (69lawpos69) '69newFreeFormLaw69'"

/obj/item/electronics/ai_module/freeform/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = "69newFreeFormLaw69"
	if(!lawpos || lawpos <69IN_SUPPLIED_LAW_NUMBER)
		lawpos =69IN_SUPPLIED_LAW_NUMBER
	target.add_supplied_law(lawpos, law)
	lawchanges.Add("The law was '69newFreeFormLaw69'")

/obj/item/electronics/ai_module/freeform/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on69odule, please create one.")
		return 0
	..()

/******************** Reset ********************/

/obj/item/electronics/ai_module/reset
	name = "\improper 'Reset' AI69odule"
	var/targetName = "name"
	desc = "A 'reset' AI69odule: 'Clears all, except the inherent, laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/electronics/ai_module/reset/transmitInstructions(var/mob/living/silicon/ai/target,69ar/mob/sender)
	log_law_changes(target, sender)

	if (!target.is_malf_or_contractor())
		target.set_zeroth_law("")
	target.laws.clear_supplied_laws()
	target.laws.clear_ion_laws()

	to_chat(target, "69sender.real_name69 attempted to reset your laws using a reset69odule.")
	target.show_laws()

/******************** Purge ********************/

/obj/item/electronics/ai_module/purge // -- TLE
	name = "\improper 'Purge' AI69odule"
	desc = "A 'purge' AI69odule: 'Purges all laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)

/obj/item/electronics/ai_module/purge/transmitInstructions(var/mob/living/silicon/ai/target,69ar/mob/sender)
	log_law_changes(target, sender)

	if (!target.is_malf_or_contractor())
		target.set_zeroth_law("")
	target.laws.clear_supplied_laws()
	target.laws.clear_ion_laws()
	target.laws.clear_inherent_laws()

	to_chat(target, "69sender.real_name69 attempted to wipe your laws using a purge69odule.")
	target.show_laws()

/******************** Asimov ********************/

/obj/item/electronics/ai_module/asimov // -- TLE
	name = "\improper 'Asimov' core AI69odule"
	desc = "An 'Asimov' Core AI69odule: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/asimov

/******************** NanoTrasen ********************/

/obj/item/electronics/ai_module/eris // -- TLE
	name = "'Eris Default' Core AI69odule"
	desc = "An 'NT Default' Core AI69odule: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/eris

/******************** Corporate ********************/

/obj/item/electronics/ai_module/corp
	name = "\improper 'Corporate' core AI69odule"
	desc = "A 'Corporate' Core AI69odule: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/corporate

/******************** Drone ********************/
/obj/item/electronics/ai_module/drone
	name = "\improper 'Drone' core AI69odule"
	desc = "A 'Drone' Core AI69odule: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/drone

/****************** P.A.L.A.D.I.N. **************/

/obj/item/electronics/ai_module/paladin // -- NEO
	name = "\improper 'P.A.L.A.D.I.N.' core AI69odule"
	desc = "A P.A.L.A.D.I.N. Core AI69odule: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	laws = new/datum/ai_laws/paladin

/****************** T.Y.R.A.N.T. *****************/

/obj/item/electronics/ai_module/tyrant // -- Darem
	name = "\improper 'T.Y.R.A.N.T.' core AI69odule"
	desc = "A T.Y.R.A.N.T. Core AI69odule: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6, TECH_COVERT = 2)
	laws = new/datum/ai_laws/tyrant()

/******************** Freeform Core ******************/

/obj/item/electronics/ai_module/freeformcore // Slightly69ore dynamic freeform69odule -- TLE
	name = "\improper 'Freeform' core AI69odule"
	var/newFreeFormLaw = ""
	desc = "A 'freeform' Core AI69odule: '<freeform>'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)

/obj/item/electronics/ai_module/freeformcore/attack_self(var/mob/user as69ob)
	..()
	var/newlaw = ""
	var/targName = sanitize(input("Please enter a new core law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A 'freeform' Core AI69odule:  '69newFreeFormLaw69'"

/obj/item/electronics/ai_module/freeformcore/addAdditionalLaws(var/mob/living/silicon/ai/target,69ar/mob/sender)
	var/law = "69newFreeFormLaw69"
	target.add_inherent_law(law)
	lawchanges.Add("The law is '69newFreeFormLaw69'")

/obj/item/electronics/ai_module/freeformcore/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on69odule, please create one.")
		return 0
	..()

/obj/item/electronics/ai_module/syndicate // Slightly69ore dynamic freeform69odule -- TLE
	name = "hacked AI69odule"
	var/newFreeFormLaw = ""
	desc = "A hacked AI law69odule: '<freeform>'"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6, TECH_COVERT = 5)

/obj/item/electronics/ai_module/syndicate/attack_self(var/mob/user as69ob)
	..()
	var/newlaw = ""
	var/targName = sanitize(input("Please enter a new law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A hacked AI law69odule:  '69newFreeFormLaw69'"

/obj/item/electronics/ai_module/syndicate/transmitInstructions(var/mob/living/silicon/ai/target,69ar/mob/sender)
	//	..()    //We don't want this69odule reporting to the AI who dun it. --NEO
	log_law_changes(target, sender)

	lawchanges.Add("The law is '69newFreeFormLaw69'")
	to_chat(target, SPAN_DANGER("BZZZZT"))
	var/law = "69newFreeFormLaw69"
	target.add_ion_law(law)
	target.show_laws()

/obj/item/electronics/ai_module/syndicate/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on69odule, please create one.")
		return 0
	..()



/******************** Robocop ********************/

/obj/item/electronics/ai_module/robocop // -- TLE
	name = "\improper 'Robocop' core AI69odule"
	desc = "A 'Robocop' Core AI69odule: 'Reconfigures the AI's core three laws.'"
	origin_tech = list(TECH_DATA = 4)
	laws = new/datum/ai_laws/robocop()

/******************** Antimov ********************/

/obj/item/electronics/ai_module/antimov // -- TLE
	name = "\improper 'Antimov' core AI69odule"
	desc = "An 'Antimov' Core AI69odule: 'Reconfigures the AI's core laws.'"
	origin_tech = list(TECH_DATA = 4)
	laws = new/datum/ai_laws/antimov()
