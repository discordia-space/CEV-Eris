/datum/faction/excelsior
	id = FACTION_EXCELSIOR
	name = "Excelsior"
	antag = "infiltrator"
	antag_plural = "infiltrators"
	welcome_text = "You are Excelsior, Ever Upward. You have infiltrated this vessel to further the Revolution.\n\
	The People's strength lies in securing our position, gathering the oppressed, spreading propaganda and producing arms and armor for the final revolution. A methodical approach is recommended. \n\n\
	Our first phase is to retrieve the cache of manufacturing materials and circuit boards. Without a means of production our revolution is in peril.\n\n\
	Our second phase is to establish a fortified position in secret. The People will send additional resources through the teleporter once it is established. This and our autolathe can be protected further with turrets and shield generators, in addition to loyal comrades.\n\n\
	Our third phase is expansion. Complete mandates for power and to delay detection by automated ship systems, which is sped up by the presence of additional brute-force implanted recruits. Aquire implants, prosthetics or robotic parts and convert them into new implants. These can be injected into the oppressed to formally induct them to the Revolution. Use their labor to produce the weapons of their liberation.\n\n\
	When the People are ready, break the chains of the oppressor and seize control of the ship"

	hud_indicator = "excelsior"

	possible_antags = list(ROLE_EXCELSIOR_REV)
	verbs = list(/datum/faction/excelsior/proc/communicate_verb,
				/datum/faction/excelsior/proc/summon_stash)

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
	new /datum/objective/timed/excelsior(src)
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
	if(alert(H, "Are you sure you want to summon Excelsior stash?","Means of Production", "Yes, the time has come", "No, not yet") == "Yes, the time has come")
		F.stash_holder = H.real_name
		var/area/comrade_area = get_area(H)
		var/comrade_location = initial(comrade_area.name)
		var/text = "<span class='revolution'>\"Comrade [H] has seized the means of production in [comrade_location]!\"</span>"
		for(var/i in SSmobs.mob_list)
			if(is_excelsior(i))
				to_chat(i, text)

		for(var/mob/observer/ghost/M as anything in GLOB.dead_mob_list)
			if(!M.client)
				continue
			if(M.antagHUD || is_admin(M))
				to_chat(M, "[text] ([ghost_follow_link(H, M)])")


		var/obj/item/storage/deferred/stash/sack/stash = new

		new /obj/item/computer_hardware/hard_drive/portable/design(stash)
		new /obj/item/computer_hardware/hard_drive/portable/design/excelsior/core(stash)
		new /obj/item/computer_hardware/hard_drive/portable/design/excelsior/weapons(stash)
		new /obj/item/electronics/circuitboard/excelsiorautolathe(stash)
		new /obj/item/electronics/circuitboard/excelsior_teleporter(stash)

		H.put_in_hands(stash)
