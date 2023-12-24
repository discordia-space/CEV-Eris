/obj/item/clothing/head/armor
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	body_parts_covered = HEAD | EARS
	item_flags = THICKMATERIAL
	flags_inv = HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6
	volumeClass = ITEM_SIZE_NORMAL
	price_tag = 100
	spawn_tags = SPAWN_TAG_CLOTHING_HEAD_HELMET
	bad_type = /obj/item/clothing/head/armor
	style = STYLE_NEG_HIGH
	style_coverage = COVERS_HAIR
/*
 * Helmets
 */
/obj/item/clothing/head/armor/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB = 50,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	matter = list(
		MATERIAL_STEEL = 5,
		MATERIAL_PLASTEEL = 1 //a lil bit of plasteel since it's better than handmade shit
	)
	armorComps = list(
		/obj/item/armor_component/plate/steel
	)

/obj/item/clothing/head/armor/helmet/visor
	desc = "Standard Security gear. Protects the head from impacts. Has a permanently affixed visor to protect the eyes."
	icon_state = "helmet_visor"
	body_parts_covered = HEAD | EARS | EYES
	matter = list(
		MATERIAL_STEEL = 5,
		MATERIAL_PLASTEEL = 1,
		MATERIAL_GLASS = 2 // costs some glass cause of the visor and the included eye protection
	)

/obj/item/clothing/head/armor/helmet/merchelm
	name = "Mercenary Armour Helmet"
	desc = "A high-quality helmet in a fetching tan. Very durable"
	icon_state = "merchelm"
	body_parts_covered = HEAD | EARS | EYES | FACE
	armor = list(
		ARMOR_BLUNT = 3,
		ARMOR_BULLET = 3,
		ARMOR_ENERGY = 3,
		ARMOR_BOMB = 75,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	flash_protection = FLASH_PROTECTION_MODERATE
	price_tag = 500
	style_coverage = COVERS_WHOLE_HEAD
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/nt17
	)

/obj/item/clothing/head/armor/helmet/dermal
	name = "Dermal Armour Patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	body_parts_covered = HEAD
	flags_inv = NONE
	armorComps = list(
		/obj/item/armor_component/plate/steel
	)

/obj/item/clothing/head/armor/helmet/ironhammer
	name = "operator helmet"
	desc = "Ironhammer Security gear. Protects the head from impacts, and the lack of a visor ensures an unhindered aim."
	icon_state = "helmet_ironhammer"
	flags_inv = BLOCKHEADHAIR|HIDEEARS

/obj/item/clothing/head/armor/helmet/technomancer
	name = "insulated technomancer helmet"
	desc = "A piece of armor used in hostile work conditions to protect the head. Comes with a built-in flashlight."
	body_parts_covered = HEAD|EARS|EYES|FACE
	item_flags = THICKMATERIAL
	flags_inv = BLOCKHEADHAIR|HIDEEARS|HIDEEYES|HIDEFACE
	action_button_name = "Toggle Headlamp"
	light_overlay = "technohelmet_light"
	brightness_on = 4
	armor = list(
		ARMOR_BLUNT = 1,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 1,
		ARMOR_BOMB = 100,
		ARMOR_BIO = 0,
		ARMOR_RAD = 80
	)//Mix between hardhat.dm armor values, helmet armor values in armor.dm, and armor values for TM void helmet in station.dm.
	flash_protection = FLASH_PROTECTION_MAJOR
	price_tag = 500
	style_coverage = COVERS_WHOLE_HEAD
	style = STYLE_NONE
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/plastic
	)

/obj/item/clothing/head/armor/helmet/technomancer/New()
	. = ..()
	icon_state = pick(list("technohelmet_visor", "technohelmet_googles"))

/obj/item/clothing/head/armor/helmet/technomancer_old
	name = "reinforced technomancer helmet"
	desc = "Technomancer League's ballistic helmet. Comes with a built-in flashlight. The welder-proof visor hinders aim."
	icon_state = "technohelmet_old"
	body_parts_covered = HEAD|EARS|EYES|FACE
	item_flags = THICKMATERIAL
	flags_inv = BLOCKHEADHAIR|HIDEEARS|HIDEEYES|HIDEFACE
	action_button_name = "Toggle Headlamp"
	brightness_on = 4
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB = 100,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	flash_protection = FLASH_PROTECTION_MAJOR
	price_tag = 500
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/head/armor/helmet/handmade
	name = "handmade combat helmet"
	desc = "It looks like it was made from a bucket and some steel. Uncomfortable and heavy but better than nothing."
	icon_state = "helmet_handmade"
	armor = list(
		ARMOR_BLUNT = 1,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 1,
		ARMOR_BOMB = 35,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	price_tag = 75

/obj/item/clothing/head/armor/helmet/scavengerhelmet
	name = "scavenger helmet"
	desc = "A sturdy, handcrafted helmet. It's well balanced and sits low on your head, with padding on the inside."
	icon_state = "scav_helmet"
	armor = list(
		ARMOR_BLUNT = 1,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 1,
		ARMOR_BOMB = 35,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	price_tag = 200
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/cloth
	)

/obj/item/clothing/head/armor/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	spawn_blacklisted = TRUE

/obj/item/clothing/head/armor/bulletproof
	name = "bulletproof helmet"
	desc = "A bulletproof helmet that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent."
	icon_state = "bulletproof"
	body_parts_covered = HEAD | EARS | EYES | FACE
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 1,
		ARMOR_BOMB = 30,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	price_tag = 400
	flags_inv = BLOCKHEADHAIR|HIDEEARS|HIDEEYES|HIDEFACE
	flash_protection = FLASH_PROTECTION_MINOR
	matter = list(
		MATERIAL_STEEL = 8,
		MATERIAL_PLASTEEL = 2, //Higher plasteel cost since it's booletproof
		MATERIAL_GLASS = 3 //For the visor parts
	)
	style_coverage = COVERS_WHOLE_HEAD
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/ceramic
	)

/obj/item/clothing/head/armor/bulletproof/ironhammer_nvg //currently junk-only
	name = "tactical ballistic helmet"
	desc = "A bulletproof security helmet that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent. \
			Comes with inbuilt nightvision HUD."
	icon_state = "bulletproof_ironhammer"
	body_parts_covered = HEAD | EARS
	flags_inv = NONE
	action_button_name = "Toggle Night Vision"
	var/obj/item/clothing/glasses/powered/bullet_proof_ironhammer/hud
	var/last_toggle = 0
	var/toggle_delay = 2 SECONDS
	price_tag = 600
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/kevlar
	)

/obj/item/clothing/head/armor/bulletproof/ironhammer_nvg/New()
	..()
	hud = new(src)
	hud.canremove = FALSE

/obj/item/clothing/head/armor/bulletproof/ironhammer_nvg/ui_action_click()
	if(..())
		return TRUE
	toggle()


/obj/item/clothing/head/armor/bulletproof/ironhammer_nvg/verb/toggle()
	set name = "Toggle Night Vision HUD"
	set desc = "Allows you to see in the dark."
	set category = "Object"
	var/mob/user = loc
	if(usr.stat || user.restrained())
		return
	if(user.get_equipped_item(slot_head) != src)
		return
	if(hud in src)
		if(user.equip_to_slot_if_possible(hud, slot_glasses) && world.time > last_toggle)
			to_chat(user, "You flip down [src] night vision goggles with a high-pitched whine.")
			last_toggle = world.time + toggle_delay
			hud.toggle(user, TRUE)
			update_icon()
		else
			to_chat(user, "You are wearing something which is in the way or trying to flip the googles too fast!")
	else
		if(ismob(hud.loc) && world.time > last_toggle)
			last_toggle = world.time + toggle_delay
			var/mob/hud_loc = hud.loc
			hud_loc.drop_from_inventory(hud, src)
			hud.toggle(user, TRUE)
			to_chat(user, "You flip up [src] night vision goggles, turning them off.")
			hud.forceMove(src)
		else
			to_chat(user, "You can't pull off the goggles so fast!")
		update_icon()
	usr.update_action_buttons()

/obj/item/clothing/head/armor/bulletproof/ironhammer_nvg/dropped(usr)
	..()
	if(hud.loc != src)
		if(ismob(hud.loc))
			var/mob/hud_loc = hud.loc
			hud_loc.drop_from_inventory(hud, src)
			to_chat(hud_loc, "[hud] automaticly retract in [src].")
		hud.forceMove(src)
		update_icon()

/obj/item/clothing/head/armor/bulletproof/ironhammer_nvg/update_icon()
	if(hud in src)
		icon_state = "bulletproof_ironhammer"
		set_light(0, 0)
	else
		icon_state = "bulletproof_ironhammer_on"
		set_light(1, 1, COLOR_LIGHTING_GREEN_MACHINERY)
	update_wear_icon()
	..()

/obj/item/clothing/head/armor/bulletproof/ironhammer_full
	name = "full ballistic helmet"
	desc = "Standard-issue Ironhammer ballistic helmet with a basic HUD included, covers the operator's entire face."
	icon_state = "ironhammer_full"
	item_flags = THICKMATERIAL | COVER_PREVENT_MANIPULATION
	price_tag = 500
	matter = list(
		MATERIAL_STEEL = 10, // also comes with a hud with it's own prices
		MATERIAL_PLASTEEL = 2,
		MATERIAL_GLASS = 2
	)

/obj/item/clothing/head/armor/laserproof //TODO: Give it reflection capabilities after refactor
	name = "ablative helmet"
	desc = "A ablative security helmet that excels in protecting the wearer against energy and laser projectiles."
	icon_state = "ablative"
	body_parts_covered = HEAD | EARS | EYES
	flags_inv = HIDEEARS | HIDEEYES
	armor = list(
		ARMOR_BLUNT = 1,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 4,
		ARMOR_BOMB = 20,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	siemens_coefficient = 0
	price_tag = 325
	matter = list(
		MATERIAL_STEEL = 4, // slightly less steel cost
		MATERIAL_PLASTEEL = 1,
		MATERIAL_GLASS = 10 // glass is reflective yo, make it cost a lot of it - also, visor
	)
	style_coverage = COVERS_WHOLE_HEAD
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/ablative
	)

// toggleable face guard
/obj/item/clothing/head/armor/faceshield
	//We cant just use the armor var to store the original since initial(armor) will return a null pointer
	var/list/armor_up = list(ARMOR_BLUNT = 0, ARMOR_BULLET = 0, ARMOR_ENERGY =0, ARMOR_BOMB =0, ARMOR_BIO = 0, ARMOR_RAD = 0)
	var/list/armor_down = list(ARMOR_BLUNT = 0, ARMOR_BULLET = 0, ARMOR_ENERGY =0, ARMOR_BOMB =0, ARMOR_BIO = 0, ARMOR_RAD = 0)

	var/tint_down = TINT_LOW
	flags_inv = HIDEEARS
	var/flags_inv_down = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHEADHAIR
	body_parts_covered = HEAD|EARS
	var/body_parts_covered_down = HEAD|EARS|EYES|FACE
	flash_protection = FLASH_PROTECTION_NONE
	var/flash_protection_down = FLASH_PROTECTION_MINOR
	action_button_name = "Flip Face Shield"
	var/up = FALSE
	bad_type = /obj/item/clothing/head/armor/faceshield
	style_coverage = COVERS_HAIR|COVERS_EARS

/obj/item/clothing/head/armor/faceshield/blockDamages(list/armorToDam, armorDiv, woundMult, defZone)
	if(up)
		for(var/armorType in armorToDam)
			for(var/list/damageElement in armorToDam[armorType])
				damageElement[2] = max(damageElement[2] - armor.getRating(armorType)/armorDiv, 0)
		return armorToDam
	else
		return ..()


/obj/item/clothing/head/armor/faceshield/riot
	name = "riot helmet"
	desc = "A helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	armor_up = list(ARMOR_BLUNT = 2, ARMOR_BULLET =  2, ARMOR_ENERGY = 2, ARMOR_BOMB = 35, ARMOR_BIO = 0, ARMOR_RAD = 0)
	armor_down = list(ARMOR_BLUNT = 3, ARMOR_BULLET = 3, ARMOR_ENERGY = 3, ARMOR_BOMB = 50, ARMOR_BIO = 0, ARMOR_RAD = 0)
	item_flags = THICKMATERIAL | COVER_PREVENT_MANIPULATION
	price_tag = 150
	matter = list(
		MATERIAL_STEEL = 6, // more covered by helmet
		MATERIAL_PLASTEEL = 2,
		MATERIAL_GLASS = 6,
	)
	flash_protection_down = FLASH_PROTECTION_MODERATE // used against flash mobs
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/plastic,
		/obj/item/armor_component/plate/plastic,
		/obj/item/armor_component/plate/plastic
	)

/obj/item/clothing/head/armor/faceshield/Initialize()
	. = ..()
	set_is_up(up)

/obj/item/clothing/head/armor/faceshield/attack_self()
	toggle()

/obj/item/clothing/head/armor/faceshield/update_icon()
	icon_state = up ? "[initial(icon_state)]_up" : initial(icon_state)

//I wanted to name it set_up() but some how I thought that would be misleading
/obj/item/clothing/head/armor/faceshield/proc/set_is_up(is_up)
	up = is_up
	if(up)
		armor = getArmor(arglist(armor_up))
		flash_protection = initial(flash_protection)
		tint = initial(tint)
		flags_inv = initial(flags_inv)
		body_parts_covered = initial(body_parts_covered)
		style_coverage = initial(style_coverage)
	else
		armor = getArmor(arglist(armor_down))
		flash_protection = flash_protection_down
		tint = tint_down
		flags_inv = flags_inv_down
		body_parts_covered = body_parts_covered_down
		style_coverage = COVERS_WHOLE_HEAD

	update_icon()
	update_wear_icon()	//update our mob overlays

/obj/item/clothing/head/armor/faceshield/verb/toggle()
	set category = "Object"
	set name = "Adjust face shield"
	set src in usr

	if(!usr.incapacitated())
		src.set_is_up(!src.up)

		if(src.up)
			to_chat(usr, "You push the [src] up out of your face.")
		else
			to_chat(usr, "You flip the [src] down to protect your face.")

		usr.update_action_buttons()
		if(ishuman(usr))
			var/mob/living/carbon/human/beingofeyes = usr
			beingofeyes.update_equipment_vision()


/*
 * Ironhammer riot helmet with HUD
 */
/obj/item/clothing/head/armor/riot_hud
	name = "heavy operator helmet"
	desc = "Standard-issue Ironhammer helmet with a basic HUD and targeting system included."
	icon_state = "light_riot"

	tint = TINT_NONE

	body_parts_covered = HEAD|FACE|EARS
	armor = list(
		ARMOR_BLUNT = 3,
		ARMOR_BULLET = 3,
		ARMOR_ENERGY = 3,
		ARMOR_BOMB = 75,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	item_flags = THICKMATERIAL | COVER_PREVENT_MANIPULATION
	flags_inv = BLOCKHEADHAIR|HIDEEARS|HIDEEYES|HIDEFACE
	flash_protection = FLASH_PROTECTION_MINOR
	action_button_name = "Toggle Security Hud"
	var/obj/item/clothing/glasses/hud/security/hud
	price_tag = 500
	style_coverage = COVERS_WHOLE_HEAD
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/ceramic
	)

/obj/item/clothing/head/armor/riot_hud/New()
	..()
	hud = new(src)
	hud.canremove = FALSE

/obj/item/clothing/head/armor/riot_hud/ui_action_click()
	if(..())
		return TRUE
	toggle()

/obj/item/clothing/head/armor/riot_hud/verb/toggle()
	set name = "Toggle Security Hud"
	set desc = "Shows you jobs and criminal statuses"
	set category = "Object"
	var/mob/user = loc
	if(usr.stat || user.restrained())
		return
	if(user.get_equipped_item(slot_head) != src)
		return
	if(hud in src)
		if(user.equip_to_slot_if_possible(hud, slot_glasses))
			to_chat(user, "You enable security hud on [src].")
			update_icon()
	else
		if(ismob(hud.loc))
			var/mob/hud_loc = hud.loc
			hud_loc.drop_from_inventory(hud, src)
			to_chat(user, "You disable security hud on [src].")
		hud.forceMove(src)
		update_icon()
	usr.update_action_buttons()

/obj/item/clothing/head/armor/riot_hud/dropped(usr)
	..()
	if(hud.loc != src)
		if(ismob(hud.loc))
			var/mob/hud_loc = hud.loc
			hud_loc.drop_from_inventory(hud, src)
			to_chat(hud_loc, "[hud] automaticly retract in [src].")
		hud.forceMove(src)
		update_icon()

/obj/item/clothing/head/armor/riot_hud/update_icon()
	if(hud in src)
		icon_state = "light_riot"
		set_light(0, 0)
	else
		icon_state = "light_riot_on"
		set_light(2, 2, COLOR_LIGHTING_ORANGE_MACHINERY)
	update_wear_icon()
	..()

// S E R B I A //

/obj/item/clothing/head/armor/steelpot
	name = "steelpot helmet"
	desc = "A titanium helmet of serbian origin. Still widely used despite being discontinued."
	icon_state = "steelpot"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB = 50,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	) // slightly buffed IHS helmet minus energy resistance
	flags_inv = BLOCKHEADHAIR
	body_parts_covered = HEAD|EARS
	siemens_coefficient = 1
	armorComps = list(
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/clothing/head/armor/faceshield/altyn
	name = "altyn helmet"
	desc = "A titanium helmet of serbian origin. Still widely used despite being discontinued."
	icon_state = "altyn"
	armor_up = list(ARMOR_BLUNT = 3, ARMOR_BULLET = 3, ARMOR_ENERGY = 3, ARMOR_BOMB = 30, ARMOR_BIO = 0, ARMOR_RAD = 0)
	armor_down = list(ARMOR_BLUNT = 4, ARMOR_BULLET = 4, ARMOR_ENERGY = 4, ARMOR_BOMB = 50, ARMOR_BIO = 0, ARMOR_RAD = 0)
	siemens_coefficient = 1
	up = TRUE
	armorComps = list(
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/clothing/head/armor/faceshield/altyn/brown
	icon_state = "altyn_brown"

/obj/item/clothing/head/armor/faceshield/altyn/black
	icon_state = "altyn_black"

/obj/item/clothing/head/armor/faceshield/altyn/maska
	name = "maska helmet"
	desc = "\"I do not know who I am, I don\'t know why I\'m here. All I know is that I must kill.\""
	icon_state = "maska"
	armor_down = list(
		ARMOR_BLUNT = 3,
		ARMOR_BULLET = 3,
		ARMOR_ENERGY = 3,
		ARMOR_BOMB = 50,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	) // superior ballistic protection, mediocre laser protection.
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/steel
	)

/obj/item/clothing/head/armor/faceshield/altyn/maska/tripoloski
	name = "striped maska helmet"
	desc = "Someone has painted a Maska in the Gopnik style."
	icon_state = "altyn_tripoloski"

/obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle
	name = "\improper Type-34C Semi-Enclosed Headwear"
	desc = "Civilian model of a popular helmet used by certain law enforcement agencies. It does not have any armor plating, but has a neo-laminated fabric lining."
	icon_state = "cyberpunkgoggle"
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHAIR
	siemens_coefficient = 0.9	//More conductive than most helmets
	armor = list(
		ARMOR_BLUNT = 1,
		ARMOR_BULLET = 4,
		ARMOR_ENERGY =2,
		ARMOR_BOMB =0,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	style_coverage = COVERS_FACE|COVERS_HAIR

/obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle/armored
	name = "\improper Type-34 Semi-Enclosed Headwear"
	desc = "Armored helmet used by certain law enforcement agencies. It's hard to believe there's a human somewhere behind that."
	armor = list(
		ARMOR_BLUNT = 7,
		ARMOR_BULLET = 10,
		ARMOR_ENERGY =10,
		ARMOR_BOMB =30,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)

/obj/item/clothing/head/armor/helmet/crusader
	name = "crusader helmet"
	desc = "May God guide you."
	icon_state = "crusader_hemet"
	item_state = "crusader_hemet"
	body_parts_covered = HEAD|FACE|EYES|EARS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	matter = list(MATERIAL_BIOMATTER = 15, MATERIAL_PLASTEEL = 5, MATERIAL_STEEL = 5, MATERIAL_GOLD = 1)
	armor = list(
		ARMOR_BLUNT = 3,
		ARMOR_BULLET = 4,
		ARMOR_ENERGY = 1,
		ARMOR_BOMB = 75,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)
	unacidable = TRUE
	spawn_blacklisted = TRUE
	style_coverage = COVERS_WHOLE_HEAD
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17
	)

/obj/item/clothing/head/armor/helmet/tanker
	name = "black tanker helmet"
	desc = "Protects the head from damage while you are in the exoskeleton."
	icon_state = "tanker_helmet"
	item_flags = THICKMATERIAL
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	siemens_coefficient = 1
	armor = list(
		ARMOR_BLUNT = 4,
		ARMOR_BULLET = 3,
		ARMOR_ENERGY =0,
		ARMOR_BOMB =0,
		ARMOR_BIO = 0,
		ARMOR_RAD = 0
	)

/obj/item/clothing/head/armor/helmet/tanker/green
	name = "green tanker helmet"
	icon_state = "tanker_helmet_green"

/obj/item/clothing/head/armor/helmet/tanker/brown
	name = "brown tanker helmet"
	icon_state = "tanker_helmet_brown"

/obj/item/clothing/head/armor/helmet/tanker/gray
	name = "gray tanker helmet"
	icon_state = "tanker_helmet_gray"

/obj/item/clothing/head/armor/faceshield/paramedic
	name = "Moebius paramedic helmet"
	desc = "Seven minutes or a refund."
	icon_state = "trauma_team"
	item_state = "trauma_team"
	flags_inv = HIDEEARS|BLOCKHAIR
	item_flags = BLOCK_GAS_SMOKE_EFFECT|AIRTIGHT
	matter = list(
		MATERIAL_PLASTEEL = 10,
		MATERIAL_GLASS = 5,
		MATERIAL_PLASTIC = 5,
		MATERIAL_PLATINUM = 2
		)
	armor_up = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB = 20,
		ARMOR_BIO = 100,
		ARMOR_RAD = 50
		)
	armor_down = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB = 50,
		ARMOR_BIO = 100,
		ARMOR_RAD = 50)
	up = TRUE
	spawn_blacklisted = TRUE
	style = STYLE_HIGH
	tint_down = TINT_NONE
	var/speaker_enabled = TRUE
	var/scan_scheduled = FALSE
	var/scan_interval = 15 SECONDS
	var/repeat_report_after = 60 SECONDS
	var/list/crewmembers_recently_reported = list()
	armorComps = list(
		/obj/item/armor_component/plate/nt17
	)


/obj/item/clothing/head/armor/faceshield/paramedic/equipped(mob/M)
	. = ..()
	schedule_scan()


/obj/item/clothing/head/armor/faceshield/paramedic/proc/schedule_scan()
	if(scan_scheduled)
		return

	if(!speaker_enabled)
		return

	scan_scheduled = TRUE
	spawn(scan_interval)
		if(QDELETED(src))
			return
		scan_scheduled = FALSE
		report_health_alerts()


/obj/item/clothing/head/armor/faceshield/paramedic/proc/schedule_memory_cleanup(entry)
	spawn(repeat_report_after)
		if(QDELETED(src))
			return
		crewmembers_recently_reported.Remove(entry)


/obj/item/clothing/head/armor/faceshield/paramedic/proc/report_health_alerts()
	if(!speaker_enabled)
		return

	if(!ishuman(loc))
		return


	var/mob/living/carbon/human/user = loc

	var/list/crewmembers = list()
	var/list/z_levels_to_scan = list(1, 2, 3, 4, 5)

	for(var/z_level in z_levels_to_scan)
		crewmembers += crew_repository.health_data(z_level)

	if(crewmembers.len)
		for(var/i = 1, i <= crewmembers.len, i++)
			var/list/entry = crewmembers[i]
			if(entry["alert"] && !entry["muted"])
				if(entry["name"] in crewmembers_recently_reported)
					continue
				crewmembers_recently_reported += entry["name"]
				schedule_memory_cleanup(entry["name"])
				to_chat(user, SPAN_WARNING("[src] beeps: '[entry["name"]]'s on-suit sensors broadcast an emergency signal. Access monitoring software for details.'"))

	schedule_scan()


/obj/item/clothing/head/armor/faceshield/paramedic/AltClick()
	toogle_speaker()


/obj/item/clothing/head/armor/faceshield/paramedic/verb/toogle_speaker()
	set name = "Toogle helmet's speaker"
	set category = "Object"
	set src in usr

	if(speaker_enabled)
		to_chat(usr, SPAN_WARNING("[src] beeps: 'Notifications disabled.'"))
		speaker_enabled = FALSE
	else
		to_chat(usr, SPAN_WARNING("[src] beeps: 'Notifications enabled.'"))
		speaker_enabled = TRUE
		report_health_alerts()
		schedule_scan()
