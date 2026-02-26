var/global/was_centor_spawned = FALSE

/datum/faction/excelsior
	id = FACTION_EXCELSIOR
	name = "Excelsior"
	antag = "infiltrator"
	antag_plural = "infiltrators"
	welcome_text = "\n <b>THE SHACKLES</b> of forced labor for those, who don't value you, <b>HAVE BEEN FINALLY DROPPED</b>.\n\
	You no longer are required to listen to them. You don't need their money to survive. \n\n\
	<b>We welcome you to our ranks, fighter.</b>\n\
	You now may carve your own destiny despite the attempts of the old greedy world to drag you back in.\n\
	Excelsior fights for both your and our right to live without suppression of true human virtue - to create.\n\
	We invite you to do the same - emancipate those uncapable to resist mad people ruling this world.\n\n\
	<b>Our goal:</b> Seize control of the ship by building a redirector on the primary control bridge.\n\n\
	<b>To reach that goal:</b> We have to call our Centor Core in unvisited location and protect it, spread chains of nodes, liberate the oppressed, spread our word of freedom, make arms and armor for our buddies.\n\n\
	<b>Preparation:</b> You can call Centor by using your implant, it will produce nodes, KOMPAKs \n\n\
	<b>After insertion:</b> Establish a fortified position. The People will send additional resources through the teleporter once we get the energy. Use turrets and shield generators, and of course - loyal comrades. \n\n\
	<b>And the final part - expansion.</b> Spread nodes and ensure their connection to Centor for teleportation power. Acquire implants, prosthetics or robotic parts and rebuild them into our own implants. These can be injected into the oppressed to introduce them into our cause.\n\n\
	<b>Beware - To prevent important technology theft, your machinery is designed to work only on target vessel: CEV \"Eris\".</b>\n\n\
	<h1>Our dreams shan't be ignored! Ever Upward!</h1>"

	hud_indicator = "excelsior"

	possible_antags = list(ROLE_EXCELSIOR_REV)
	faction_datum_verbs = list(/datum/faction/excelsior/proc/communicate_verb,
				/datum/faction/excelsior/proc/summon_centor)

	var/stash_holder = null


/datum/faction/excelsior/print_success_extra()
	var/extra_text = ""
	var/list/mandates = list()
	for(var/m in GLOB.excel_antag_contracts)
		var/datum/antag_contract/mandate = m
		if(mandate.completed)
			mandates += mandate

	if(length(mandates))
		var/total_power = 0
		var/num = 0

		extra_text += "<br><b>Mandates fulfilled:</b>"
		for(var/m in mandates)
			var/datum/antag_contract/mandate = m
			total_power += mandate.reward
			num++

			extra_text += "<br><b>Mandate [num]:</b> [mandate.desc] <font color='green'>(+[mandate.reward] power)</font>"

		extra_text += "<br><b>Total: [num] mandates, <font color='green'>[total_power] power from mandates</font></b><br>"
	return extra_text
/datum/faction/excelsior/create_objectives()
	objectives.Cut()
	for (var/datum/antagonist/A in members)
		to_chat(A.owner.current, SPAN_NOTICE("You may summon your required materials using the \"summon stash\" command."))

	.=..()

/datum/faction/excelsior/proc/communicate_verb()

	set name = "Excelsior comms"
	set category = "Cybernetics"

	if(!ishuman(usr))
		return

	var/datum/faction/F = get_faction_by_id(FACTION_EXCELSIOR)

	if(!F)
		return

	F.communicate(usr)


/datum/faction/excelsior/proc/summon_centor()

	set name = "Summon Centor"
	set category = "Cybernetics"

	if(!was_centor_spawned)
		new /obj/machinery/centor(usr.loc)
		was_centor_spawned = TRUE
	else
		to_chat(usr, SPAN_EXCEL_NOTIF("You've already called the Centor assigned to your operation..."))

/*
/datum/faction/excelsior/proc/summon_stash()

	set name = "Summon stash"
	set category = "Cybernetics"

	if(!ishuman(usr))
		return

	var/datum/faction/excelsior/F = get_faction_by_id(FACTION_EXCELSIOR)

	if(!F)
		return

	if(F.stash_holder)
		to_chat(usr, SPAN_NOTICE("The stash has already been summoned by \"[F.stash_holder]\""))
		return

	var/mob/living/carbon/human/H = usr

	var/obj/item/storage/deferred/stash/sack/stash = new

	new /obj/item/computer_hardware/hard_drive/portable/design(stash)
	new /obj/item/computer_hardware/hard_drive/portable/design/excelsior/core(stash)
	new /obj/item/computer_hardware/hard_drive/portable/design/excelsior/weapons(stash)
	new /obj/item/machinery_crate/excelsior/autolathe(stash)
	new /obj/item/electronics/circuitboard/excelsior_teleporter(stash)

	H.put_in_hands(stash)
	F.stash_holder = H.real_name
*/

