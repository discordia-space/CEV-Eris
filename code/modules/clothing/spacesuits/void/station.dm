// Station69oidsuits
//Engineering rig
/obj/item/clothing/head/space/void/engineering
	name = "Technomancer69oidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "technohelmet_void_old"
	item_state = "technohelmet_void_old"
	light_overlay = "technohelmet_light"
	item_state_slots = list(
		slot_l_hand_str = "eng_helm",
		slot_r_hand_str = "eng_helm",
		)
	armor = list(
		melee = 35,
		bullet = 30,
		energy = 30,
		bomb = 40,
		bio = 100,
		rad = 100
	)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/void/engineering
	name = "Technomancer69oidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding and extra plating."
	icon_state = "technosuit_old"
	item_state = "technosuit_old"
	armor = list(
		melee = 35,
		bullet = 30,
		energy = 30,
		bomb = 40,
		bio = 100,
		rad = 100
	)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	extra_allowed = list(
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/device/t_scanner,
		/obj/item/rcd
	)
	helmet = /obj/item/clothing/head/space/void/engineering
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/space/void/engineering/equipped
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/jetpack/oxygen
	accompanying_object = null
	spawn_blacklisted = TRUE

//Old engineering rig
/obj/item/clothing/head/space/void/engineeringold
	name = "outdated Technomancer69oidsuit helmet"
	desc = "This69isor has a few69ore options in its shape than its69ore newer69ersion."
	icon_state = "technohelmet_void"
	item_state = "technohelmet_void"
	light_overlay = "technohelmet_light"
	item_state_slots = list(
		slot_l_hand_str = "eng_helm",
		slot_r_hand_str = "eng_helm",
		)
	armor = list(
		melee = 35,
		bullet = 30,
		energy = 30,
		bomb = 40,
		bio = 100,
		rad = 100
	)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/space/void/engineering/verb/toggle_eyeglass()
	set name = "Adjust Eyeglass node"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	var/mob/M = usr
	var/list/options = list()
	options69"generic"69 = "technohelmet_void"
	options69"visor"69 = "technohelmet_void_visor"
	options69"goggles"69 = "technohelmet_void_goggles"

	var/choice = input(M,"What kind of eyeglass do you want to look through?","Adjust69isor") as null|anything in options

	if(src && choice && !M.incapacitated() && Adjacent(M))
		icon_state = options69choice69
		to_chat(M, "You change your helmet's eyeglass69ode to 69choice69.")
		update_icon()
		update_wear_icon()
		usr.update_action_buttons()
		return 1

/obj/item/clothing/suit/space/void/engineeringold
	name = "outdated Technomancer69oidsuit"
	desc = "An outdated Technomancer69oidsuit that is nearly identical in all properties to its newer69ersion. Nevertheless this design was rejected in favour of69ore streamlined counterpart. Rumors claim there was a different reason to it, but we all stick to this one."
	icon_state = "technosuit"
	item_state = "technosuit"
	armor = list(
		melee = 35,
		bullet = 30,
		energy = 30,
		bomb = 40,
		bio = 100,
		rad = 100
	)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	extra_allowed = list(
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/device/t_scanner,
		/obj/item/rcd
	)
	helmet = /obj/item/clothing/head/space/void/engineeringold
	spawn_blacklisted = FALSE

/obj/item/clothing/suit/space/void/engineeringold/equipped
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/jetpack/oxygen
	accompanying_object = null
	spawn_blacklisted = TRUE

//Mining rig
/obj/item/clothing/head/space/void/mining
	name = "mining69oidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	icon_state = "mining_helmet"
	item_state = "mining_helmet"
	item_state_slots = list(
		slot_l_hand_str = "mining_helm",
		slot_r_hand_str = "mining_helm",
		)
	armor = list(
		melee = 50,
		bullet = 35,
		energy = 30,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/mining
	name = "mining69oidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	item_state = "miner_suit"
	icon_state = "miner_suit"
	armor = list(
		melee = 50,
		bullet = 35,
		energy = 30,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	helmet = /obj/item/clothing/head/space/void/mining
	spawn_blacklisted = TRUE

//Medical
/obj/item/clothing/head/space/void/medical
	name = "medical69oidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has69inor radiation shielding."
	icon_state = "rig-medical"
	item_state = "rig-medical"
	item_state_slots = list(
		slot_l_hand_str = "medical_helm",
		slot_r_hand_str = "medical_helm",
		)
	armor = list(
		melee = 30,
		bullet = 10,
		energy = 35,
		bomb = 25,
		bio = 100,
		rad = 75
	)

/obj/item/clothing/suit/space/void/medical
	name = "medical69oidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has69inor radiation shielding."
	icon_state = "rig-medical"
	item_state = "rig-medical"
	extra_allowed = list(
		/obj/item/storage/firstaid,
		/obj/item/device/scanner/health,
		/obj/item/stack/medical,
		/obj/item/roller
	)
	armor = list(
		melee = 20,
		bullet = 10,
		energy = 35,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	helmet = /obj/item/clothing/head/space/void/medical
	slowdown = LIGHT_SLOWDOWN

/obj/item/clothing/suit/space/void/medical/equipped
	boots = /obj/item/clothing/shoes/magboots
	accompanying_object = null
	spawn_blacklisted = TRUE

	//Security
/obj/item/clothing/head/space/void/security
	name = "ironhammer69oidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Sacrifices sight for protection."
	icon_state = "ihsvoidhelm"
	item_state = "ihsvoidhelm"
	item_state_slots = list(
		slot_l_hand_str = "sec_helm",
		slot_r_hand_str = "sec_helm",
		)

	armor = list(
		melee = 35,
		bullet = 45,
		energy = 35,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_ihs"
	obscuration =69EDIUM_OBSCURATION

/obj/item/clothing/suit/space/void/security
	name = "ironhammer69oidsuit"
	icon_state = "ihvoidsuit"
	desc = "A bulky suit that protects against hazardous, low pressure environments. Sacrifices69obility for protection."
	item_state = "ihvoidsuit"
	armor = list(
		melee = 35,
		bullet = 45,
		energy = 35,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	siemens_coefficient = 0.7
	helmet = /obj/item/clothing/head/space/void/security
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/space/void/security/equipped
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/jetpack/oxygen
	accompanying_object = null
	spawn_blacklisted = TRUE

//Atmospherics Rig (BS12)
/obj/item/clothing/head/space/void/atmos
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has improved thermal protection and69inor radiation shielding."
	name = "atmospherics69oidsuit helmet"
	icon_state = "rig0-atmos"
	item_state = "atmos_helm"
	item_state_slots = list(
		slot_l_hand_str = "atmos_helm",
		slot_r_hand_str = "atmos_helm",
		)
	armor = list(
		melee = 30,
		bullet = 10,
		energy = 10,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/atmos
	desc = "A special suit that protects against hazardous, low pressure environments. Has improved thermal protection and69inor radiation shielding."
	icon_state = "rig-atmos"
	name = "atmos69oidsuit"
	item_state = "atmos_voidsuit"
	armor = list(
		melee = 30,
		bullet = 10,
		energy = 10,
		bomb = 25,
		bio = 100,
		rad = 75
	)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	helmet = /obj/item/clothing/head/space/void/atmos

//Science
/obj/item/clothing/head/space/void/science
	name = "Moebius combat helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. The high-tech sensor systems built into the69isor allow a good amount of protection without impairing aim."
	icon_state = "moebiushelmb"
	item_state = "moebiushelmb"
	item_state_slots = list(
		slot_l_hand_str = "assaulthelm",
		slot_r_hand_str = "assaulthelm",
		)
	matter = list(
	MATERIAL_PLASTEEL = 5,
	MATERIAL_STEEL = 5,
	MATERIAL_GLASS = 5
	)
	price_tag = 200
	armor = list(
		melee = 40,
		bullet = 40,
		energy = 55,
		bomb = 40,
		bio = 100,
		rad = 75
	)
	siemens_coefficient = 0.4
	light_overlay = "helmet_light_dual"
	obscuration = 0

/obj/item/clothing/head/space/void/science
	var/list/icon_states = list(
		"Blue" = "moebiushelmb",
		"Red" = "moebiushelmr",
		"Purple" = "moebiushelmp",
		"Green" = "moebiushelmg",
		"Yellow" = "moebiushelmy",
		"White" = "moebiushelmw")

/obj/item/clothing/head/space/void/science/verb/recolor()
	set name = "Change helmet color"
	set category = "Object"
	set src in usr

	var/color = input(usr, "Available colors", "Visor configuration") in icon_states
	icon_state = icon_states69color69
	update_wear_icon()
	usr.update_action_buttons()

/obj/item/clothing/head/space/void/science/New()
	..()
	var/color = pick(icon_states)
	icon_state = icon_states69color69

/obj/item/clothing/head/space/void/science/emag_act(remaining_charges,69ob/user, emag_source)
	icon_state = "moebiushelmcaramel"
	update_wear_icon()
	usr.update_action_buttons()

/obj/item/clothing/suit/space/void/science
	name = "Moebius combat69oidsuit"
	icon_state = "moebiussuit"
	desc = "A heavy space suit designed by69oebius personnel for work in hazardous environment without impairing69obility. Features several advanced layers of armor."
	item_state = "moebiussuit"
	matter = list(
	MATERIAL_PLASTEEL = 15,
	MATERIAL_STEEL = 10,
	MATERIAL_PLASTIC = 10,
	MATERIAL_PLATINUM = 5
	)
	armor = list(
		melee = 40,
		bullet = 40,
		energy = 55,
		bomb = 40, //platinum price justifies bloated stats
		bio = 100,
		rad = 75
	)
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	price_tag = 1200
	siemens_coefficient = 0.4
	helmet = /obj/item/clothing/head/space/void/science
	spawn_blacklisted = TRUE
	stiffness =69EDIUM_STIFFNESS

/obj/item/clothing/suit/space/void/science/handle_shield(mob/user, damage, atom/damage_source = null,69ob/attacker = null, def_zone = null, attack_text = "the attack")
	if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
		var/obj/item/projectile/P = damage_source

		var/reflectchance = 30 - round(damage/3)
		if(!(def_zone in list(BP_CHEST, BP_GROIN)))
			reflectchance /= 1.5
		if(P.starting && prob(reflectchance))
			visible_message(SPAN_DANGER("\The 69user69\'s 69name69 reflects 69attack_text69!"))

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)

			return PROJECTILE_CONTINUE // complete projectile permutation

/obj/item/clothing/head/space/void/riggedvoidsuit
	name = "makeshift armored Helmet"
	desc = "A69akeshift armored helmet you can see the glue holding it, just close enough to be airtight."
	icon_state = "makeshift_void"
	item_state = "makeshift_void"
	slowdown = 2

	armor = list(
		melee = 20,
		bullet = 15,
		energy = 20,
		bomb = 25,
		bio = 100,
		rad = 0
	)
	light_overlay = "helmet_light_dual"
	siemens_coefficient = 0.8

/obj/item/clothing/suit/space/void/riggedvoidsuit
	name = "makeshift armored69oidsuit"
	desc = "A69akeshift armored69oidsuit you can see the glue holding it, just close enough to be airtight."
	icon_state = "makeshift_void"
	item_state = "makeshift_void"
	siemens_coefficient = 0.4
	armor = list(
		melee = 10,
		bullet = 20,
		energy = 20,
		bomb = 25,
		bio = 100,
		rad = 0
	)
	siemens_coefficient = 0.8
	helmet = /obj/item/clothing/head/space/void/riggedvoidsuit
	spawn_blacklisted = TRUE

//NT

/obj/item/clothing/head/space/void/NTvoid
	name = "neotheology69oidsuit helmet"
	desc = "A69oidsuit helmet designed by NeoTheology with a69ost holy69ix of biomatter and inorganic69atter."
	icon_state = "ntvoidhelmet"
	item_state = "ntvoidhelmet"
	action_button_name = "Toggle Helmet Light"
	flags_inv = BLOCKHAIR
	armor = list(
		melee = 40,
		bullet = 30,
		energy = 30,
		bomb = 30,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.35
	species_restricted = list(SPECIES_HUMAN)
	light_overlay = "helmet_light"

/obj/item/clothing/suit/space/void/NTvoid
	name = "neotheology69oidsuit"
	desc = "A69oidsuit designed by NeoTheology with a69ost holy69ix of biomatter and inorganic69atter."
	icon_state = "ntvoid"
	item_state = "ntvoid"
	matter = list(MATERIAL_PLASTEEL = 8,69ATERIAL_STEEL = 10,69ATERIAL_BIOMATTER = 35)
	slowdown = 0.3
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	armor = list(
	   69elee = 40,
		bullet = 30,
		energy = 30,
		bomb = 30,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.35
	breach_threshold = 10
	resilience = 0.07
	species_restricted = list(SPECIES_HUMAN)
	helmet = /obj/item/clothing/head/space/void/NTvoid
	spawn_blacklisted = TRUE
	slowdown = LIGHT_SLOWDOWN