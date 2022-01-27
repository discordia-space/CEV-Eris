//
//Robotic Component Analyser, basically a health analyser for robots
//
/obj/item/device/robotanalyzer
	name = "robot analyzer"
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 5
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 1, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	rarity_value = 50
	suitable_cell = /obj/item/cell/small

/obj/item/device/robotanalyzer/attack(mob/living/M,69ob/living/user)
	if(!cell_use_check(5, user))
		return
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, text("\red You try to analyze the floor's69itals!"))
		for(var/mob/O in69iewers(M,69ull))
			O.show_message(text("\red 69user69 has analyzed the floor's69itals!"), 1)
		user.show_message(text("\blue Analyzing Results for The floor:\n\t Overall Status: Healthy"), 1)
		user.show_message(text("\blue \t Damage Specifics: 69069-69069-69069-69069"), 1)
		user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
		user.show_message("\blue Body Temperature: ???", 1)
		return

	var/scan_type
	if(isrobot(M))
		scan_type = "robot"
	else if(ishuman(M))
		scan_type = "prosthetics"
	else
		to_chat(user, "\red You can't analyze69on-robotic things!")
		return

	user.visible_message(SPAN_NOTICE("\The 69user69 has analyzed 69M69's components."),SPAN_NOTICE("You have analyzed 69M69's components."))
	switch(scan_type)
		if("robot")
			var/BU =69.getFireLoss() > 50 	? 	"<b>69M.getFireLoss()69</b>" 		:69.getFireLoss()
			var/BR =69.getBruteLoss() > 50 	? 	"<b>69M.getBruteLoss()69</b>" 	:69.getBruteLoss()
			user.show_message("\blue Analyzing Results for 69M69:\n\t Overall Status: 69M.stat > 1 ? "fully disabled" : "69M.health -69.halloss69% functional"69")
			user.show_message("\t Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>", 1)
			user.show_message("\t Damage Specifics: <font color='#FFA500'>69BU69</font> - <font color='red'>69BR69</font>")
			if(M.timeofdeath &&69.stat == DEAD)
				user.show_message("\blue Time of Disable: 69worldtime2stationtime(M.timeofdeath)69")
			var/mob/living/silicon/robot/H =69
			var/list/damaged = H.get_damaged_components(1,1,1)
			user.show_message("\blue Localized Damage:",1)
			if(length(damaged)>0)
				for(var/datum/robot_component/org in damaged)
					user.show_message(text("\blue \t 6969: 69696969 - 6969 - 6969 - 6969",	\
					capitalize(org.name),					\
					(org.installed == -1)	?	"<font color='red'><b>DESTROYED</b></font> "							:"",\
					(org.electronics_damage > 0)	?	"<font color='#FFA500'>69org.electronics_damage69</font>"	:0,	\
					(org.brute_damage > 0)	?	"<font color='red'>69org.brute_damage69</font>"							:0,		\
					(org.toggled)	?	"Toggled ON"	:	"<font color='red'>Toggled OFF</font>",\
					(org.powered)	?	"Power ON"		:	"<font color='red'>Power OFF</font>"),1)
			else
				user.show_message("\blue \t Components are OK.",1)
			if(H.emagged && prob(5))
				user.show_message("\red \t ERROR: INTERNAL SYSTEMS COMPROMISED",1)
			user.show_message("\blue Operating Temperature: 69M.bodytemperature-T0C69&deg;C (69M.bodytemperature*1.8-459.6769&deg;F)", 1)

		if("prosthetics")
			var/mob/living/carbon/human/H =69
			to_chat(user, SPAN_NOTICE("Analyzing Results for \the 69H69:"))
			to_chat(user, "Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>")

			to_chat(user, SPAN_NOTICE("External prosthetics:"))
			var/organ_found
			if(H.internal_organs.len)
				for(var/obj/item/organ/external/E in H.organs)
					if(!BP_IS_ROBOTIC(E))
						continue
					organ_found = 1
					to_chat(user, "69E.name69: <font color='red'>69E.brute_dam69</font> <font color='#FFA500'>69E.burn_dam69</font>")
			if(!organ_found)
				to_chat(user, "No prosthetics located.")
			to_chat(user, "<hr>")
			to_chat(user, SPAN_NOTICE("Internal prosthetics:"))
			organ_found =69ull
			if(H.internal_organs.len)
				for(var/obj/item/organ/O in H.internal_organs)
					if(!BP_IS_ROBOTIC(O))
						continue
					organ_found = 1
					to_chat(user, "69O.name69: <font color='red'>69O.damage69</font>")
			if(!organ_found)
				to_chat(user, "No prosthetics located.")
	src.add_fingerprint(user)
