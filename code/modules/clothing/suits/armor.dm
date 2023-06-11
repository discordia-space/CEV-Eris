
/obj/item/clothing/suit/armor
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_flags = THICKMATERIAL|DRAG_AND_DROP_UNEQUIP
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6
	price_tag = 200
	style = STYLE_NEG_HIGH
	style_coverage = COVERS_TORSO
	equip_delay = 4 SECONDS
	bad_type = /obj/item/clothing/suit/armor
	spawn_tags = SPAWN_TAG_CLOTHING_ARMOR
	slowdown = 0
	valid_accessory_slots = list("armband","decor")
	restricted_accessory_slots = list("armband")
	maxHealth = 500
	health = 500

/*
 * Vests
 */
/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "An armored vest that protects against some damage. Not designed for serious operations."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(
		melee = 7,
		bullet = 10,
		energy = 10,
		bomb = 25,
		bio = 0,
		rad = 0
	)
	matter = list(
		MATERIAL_STEEL = 8,
		MATERIAL_PLASTEEL = 1, //Small plasteel cost since it's better than a handmade vest, which only costs steel
	)

/obj/item/clothing/suit/armor/vest/full
	name = "full armor"
	desc = "A generic armor vest, but with shoulderpads and knee pads included to cover all parts of the body. Not designed for serious operations."
	icon_state = "armor_fullbody"
	blood_overlay_type = "armor"
	slowdown = 0.1
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS // kneepads and shoulderpads, so it covers arms and legs
	matter = list(
		MATERIAL_STEEL = 10, // contains a lil bit more steel because of arm+leg prot
		MATERIAL_PLASTEEL = 1,
	)
	slowdown = LIGHT_SLOWDOWN
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS

/obj/item/clothing/suit/armor/vest/full/security
	name = "full security armor"
	desc = "A tactical armor vest, but with shoulderpads and knee pads included to cover all parts of the body. Not designed for serious operations."
	icon_state = "armor_security_fullbody"

/obj/item/clothing/suit/armor/vest/security
	name = "security armor"
	icon_state = "armor_security"

/obj/item/clothing/suit/armor/vest/detective
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "armor_detective"

/obj/item/clothing/suit/armor/vest/warden
	name = "Warden's jacket"
	desc = "An armoured jacket with an attached vest holding a badge and livery."
	icon_state = "warden_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	price_tag = 350

/obj/item/clothing/suit/armor/vest/ironhammer
	name = "operator armor"
	desc = "An armored vest that protects against some damage. This one has been done in Ironhammer Security colors. Not designed for serious operations."
	icon_state = "armor_ironhammer"

/obj/item/clothing/suit/armor/vest/full/ironhammer
	name = "full operator armor"
	desc = "An armored vest painted in Ironhammer Security colors. This one has shoulderpads and knee pads included to protect all parts of the body."
	icon_state = "armor_ironhammer_fullbody"

/obj/item/clothing/suit/armor/vest/handmade
	name = "handmade armor vest"
	desc = "An armored vest of dubious quality. Provides decent protection against physical damage, for a piece of crap."
	icon_state = "armor_handmade"
	armor = list(
		melee = 7,
		bullet = 7,
		energy = 7,
		bomb = 20,
		bio = 0,
		rad = 0
	)
	price_tag = 100

/obj/item/clothing/suit/armor/vest/handmade/full
	name = "full handmade armor vest"
	desc = "An armored vest of dubious quality. This one has had metal sheets attached to the shoulders and knees to be used as makeshift shoulderpads and kneepads."
	icon_state = "armor_handmade_fullbody"
	slowdown = LIGHT_SLOWDOWN
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS // kneepads and shoulderpads mean more covering
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS

/obj/item/clothing/suit/storage/greatcoat
	item_flags = THICKMATERIAL|DRAG_AND_DROP_UNEQUIP
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6
	spawn_tags = SPAWN_TAG_CLOTHING_ARMOR

	name = "armored coat"
	desc = "A greatcoat enhanced with a special alloy for some protection and style."
	icon_state = "greatcoat"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS
	armor = list(
		melee = 7,
		bullet = 10,
		energy = 10,
		bomb = 35,
		bio = 0,
		rad = 0
	)
	price_tag = 600
	slowdown = LIGHT_SLOWDOWN
	valid_accessory_slots = list("armband","decor")
	restricted_accessory_slots = list("armband")

/obj/item/clothing/suit/storage/greatcoat/ironhammer
	icon_state = "greatcoat_ironhammer"

/obj/item/clothing/suit/storage/greatcoat/serbian_overcoat
	name = "black serbian overcoat"
	desc = "A black serbian overcoat with armor-weave and rank epaulettes"
	icon_state = "overcoat_black"
	item_state = "overcoat_black"

/obj/item/clothing/suit/storage/greatcoat/serbian_overcoat_brown
	name = "brown serbian overcoat"
	desc = "A brown serbian overcoat with armor-weave and rank epaulettes"
	icon_state = "overcoat_brown"
	item_state = "overcoat_brown"

// Serbian flak vests
/obj/item/clothing/suit/armor/flak
	name = "black flakvest"
	desc = "An armored vest that protects against high-velocity solid projectiles."
	icon_state = "flakvest"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(
		melee = 7,
		bullet = 13,
		energy = 7,
		bomb = 30,
		bio = 0,
		rad = 0
	)

/obj/item/clothing/suit/armor/flak/green
	name = "green flakvest vest"
	icon_state = "flakvest_green"

/obj/item/clothing/suit/armor/flak/full
	name = "full flakvest vest"
	desc = "An armored vest built for protection against high-velocity solid projectiles. This set has had kneepads and shoulderpads attached for more protection."
	icon_state = "flakvest_fullbody"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS // shoulderpads and kneepads
	slowdown = LIGHT_SLOWDOWN
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS

/obj/item/clothing/suit/armor/flak/full/green
	name = "full green flakvest vest"
	icon_state = "flakvest_green_fullbody"

/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	slowdown = 0.15
	armor = list(
		melee = 6,
		bullet = 15,
		energy = 7,
		bomb = 20,
		bio = 0,
		rad = 0
	)
	price_tag = 500
	matter = list(
		MATERIAL_STEEL = 10, // costs a bit more steel than standard vest
		MATERIAL_PLASTEEL = 3, // costs lots more plasteel than standard vest
	)
	slowdown = LIGHT_SLOWDOWN

/obj/item/clothing/suit/armor/bulletproof/full
	name = "full bulletproof vest"
	desc = "A vest built for protection against bullets and other high-velocity projectiles. This one has shoulderpads and kneepads for extra coverage."
	icon_state = "bulletproof_fullbody"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	matter = list(
		MATERIAL_STEEL = 15, // costs a smidge more steel to cover for shoulder and knees
		MATERIAL_PLASTEEL = 3,
	)
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS

/obj/item/clothing/suit/armor/bulletproof/ironhammer
	name = "full bulletproof suit"
	desc = "A vest with hand and arm-guards attached that excels in protecting the wearer against high-velocity solid projectiles. \
			This one has been done in Ironhammer Security colors."
	icon_state = "bulletproof_ironhammer"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	matter = list(
		MATERIAL_STEEL = 15, // fullbody suit, so it costs a lot of steel compared to the non-ih one
		MATERIAL_PLASTEEL = 3,
	)

/obj/item/clothing/suit/armor/platecarrier
	name = "black platecarrier vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "platecarrier"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(
		melee = 10,
		bullet = 13,
		energy = 10,
		bomb = 20,
		bio = 0,
		rad = 0
	)
	price_tag = 400
	matter = list(
		MATERIAL_STEEL = 10, // costs a bit more steel than standard vest
		MATERIAL_PLASTEEL = 3 // costs lots more plasteel than standard vest
	)
	slowdown = LIGHT_SLOWDOWN

/obj/item/clothing/suit/armor/platecarrier/green
	name = "green platecarrier vest"
	icon_state = "platecarrier_green"

/obj/item/clothing/suit/armor/platecarrier/tan
	name = "tan platecarrier vest"
	icon_state = "platecarrier_tan"

/obj/item/clothing/suit/armor/platecarrier/full
	name = "full black platecarrier vest"
	desc = "A vest built for protection against bullets and other high-velocity projectiles. This one has shoulderpads and kneepads for extra coverage."
	icon_state = "platecarrier_fullbody"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS

/obj/item/clothing/suit/armor/platecarrier/full/green
	name = "full green platecarrier vest"
	icon_state = "platecarrier_green_fullbody"

/obj/item/clothing/suit/armor/platecarrier/full/tan
	name = "full tan platecarrier vest"
	icon_state = "platecarrier_tan_fullbody"

/obj/item/clothing/suit/armor/laserproof
	bad_type = /obj/item/clothing/suit/armor/laserproof

/obj/item/clothing/suit/armor/laserproof/full
	name = "full ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "ablative"
	item_state = "ablative"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS
	blood_overlay_type = "armor"
	armor = list(
		melee = 5,
		bullet = 7,
		energy = 16,
		bomb = 20,
		bio = 0,
		rad = 0
	)
	siemens_coefficient = 0
	price_tag = 650
	matter = list(
		MATERIAL_STEEL = 6, // slightly less steel cost to make room for reflective glass
		MATERIAL_PLASTEEL = 1,
		MATERIAL_GLASS = 15 // reflective material, lots of it
	)
	slowdown = LIGHT_SLOWDOWN
	//spawn_blacklisted = TRUE//antag_item_targets-crafteable?

/obj/item/clothing/suit/armor/laserproof/handle_shield(mob/user, damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack") //TODO: Refactor this all into humandefense
	if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
		var/obj/item/projectile/P = damage_source

		var/reflectchance = 40 - round(damage/3)
		if(!(def_zone in list(BP_CHEST, BP_GROIN)))
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message(SPAN_DANGER("\The [user]'s [src.name] reflects [attack_text]!"))

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)

			return PROJECTILE_CONTINUE // complete projectile permutation

/obj/item/clothing/suit/storage/greatcoat/german_overcoat
	name = "Oberth Republic uniform overcoat"
	desc = "A black overcoat made out of special materials that will protect against energy projectiles. Probably surplus."
	icon_state = "germancoat"
	item_state = "germancoat"
	armor = list(
		melee = 7,
		bullet = 7,
		energy = 10,
		bomb = 20,
		bio = 0,
		rad = 0
	)

/obj/item/clothing/suit/storage/greatcoat/onestar
	name = "One Star officer coat"
	desc = "A rare stylish red jacket worn by One Star officers. It seems to be extremly durable and is strangely warm to the touch."
	icon_state = "onestar_coat"
	item_state = "onestar_coat"
	style = STYLE_HIGH
	slowdown = 0
	spawn_tags = SPAWN_TAG_CLOTHING_OS
	spawn_blacklisted = TRUE
	price_tag = 2000
	armor = list(
		melee = 3,
		bullet = 12,
		energy = 12,
		bomb = 30,
		bio = 5,
		rad = 5
	)

	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.7

/*
 * Heavy Armor Types
 */
/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = ITEM_SIZE_BULKY
	gas_transfer_coefficient = 0.9
	permeability_coefficient = 0.9
	siemens_coefficient = 0.5
	item_flags = THICKMATERIAL|DRAG_AND_DROP_UNEQUIP|COVER_PREVENT_MANIPULATION|EQUIP_SOUNDS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	style_coverage = COVERS_WHOLE_TORSO_AND_LIMBS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(
		melee = 16, //massive slowdown justifies
		bullet = 13,
		energy = 10,
		bomb = 75,
		bio = 0,
		rad = 0
	)
	equip_delay = 2 SECONDS
	price_tag = 500
	style = STYLE_NEG_HIGH
	slowdown = MEDIUM_SLOWDOWN

/obj/item/clothing/suit/armor/heavy/red
	name = "Thunderdome suit (red)"
	desc = "Reddish armor."
	icon_state = "tdred"
	item_state = "tdred"
	siemens_coefficient = 1
	spawn_frequency = 0//Thunderdome

/obj/item/clothing/suit/armor/heavy/green
	name = "Thunderdome suit (green)"
	desc = "Pukish armor."
	icon_state = "tdgreen"
	item_state = "tdgreen"
	siemens_coefficient = 1
	spawn_frequency = 0//Thunderdome

// Riot suit
/obj/item/clothing/suit/armor/heavy/riot
	name = "riot suit"
	desc = "A suit of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	flags_inv = NONE
	armor = list(
		melee = 20,
		bullet = 7,
		energy = 6,
		bomb = 50,
		bio = 0,
		rad = 0
	)
	slowdown = LIGHT_SLOWDOWN // Very uncomfortable, but not that particularly heavy

/obj/item/clothing/suit/armor/heavy/ironhammer
	name = "heavy operator armor"
	desc = "A heavily armoured suit with extra padding to better protect against blunt trauma. Looks like it might impair movement."
	icon_state = "riot_ironhammer"
	item_state = "swat_suit"
	flags_inv = HIDEJUMPSUIT
	armor = list(
		melee = 16,
		bullet = 13, //comparable to RIG
		energy = 10,
		bomb = 50,
		bio = 0,
		rad = 0
	)
	price_tag = 800

/*
 * Storage Types
 */
/obj/item/clothing/suit/storage/vest
	name = "webbed armor"
	desc = "An armored vest used for day-to-day operations. This one has various pouches and straps attached."
	icon_state = "webvest"
	price_tag = 250 //Normal vest is worth 200, this one is worth 250 because it also has storage space
	armor = list( //Same stats as the standard vest only difference is that this one has storage
		melee = 7,
		bullet = 10,
		energy = 10,
		bomb = 25,
		bio = 0,
		rad = 0
	)

	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	style_coverage = COVERS_TORSO
	item_flags = DRAG_AND_DROP_UNEQUIP|EQUIP_SOUNDS|THICKMATERIAL

	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6
	bad_type = /obj/item/clothing/suit/storage/vest
	style = STYLE_NEG_HIGH

	matter = list(
		MATERIAL_STEEL = 8,
		MATERIAL_PLASTEEL = 1,
		MATERIAL_PLASTIC = 3, //for webbing
	)
	valid_accessory_slots = list("armband","decor")
	restricted_accessory_slots = list("armband")

/obj/item/clothing/suit/storage/vest/ironhammer
	name = "webbed operator armor"
	desc = "An armored vest that protects against some damage. This one has been done in Ironhammer Security colors and has various pouches and straps attached."
	icon_state = "webvest_ironhammer"
	spawn_blacklisted = TRUE

//Provides the protection of a merc voidsuit, but only covers the chest/groin, and also takes up a suit slot. In exchange it has no slowdown and provides storage.
/obj/item/clothing/suit/storage/vest/merc
	name = "mercenary armor vest"
	desc = "A high-quality armor vest in a fetching tan. It is surprisingly flexible and light, even with the added webbing and armor plating."
	icon_state = "mercwebvest"
	item_state = "mercwebvest"
	armor = list(
		melee = 12,
		bullet = 12,
		energy = 12,
		bomb = 75,
		bio = 0,
		rad = 0
	)

/obj/item/clothing/suit/storage/vest/merc/full
	name = "full mercenary armor vest"
	desc = "A high-quality armor vest in a fetching tan. This one is webbed, and has kneepads and shoulderpads for extra coverage."
	icon_state = "mercwebvest_fullbody"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	slowdown = LIGHT_SLOWDOWN

//Technomancer armor
/obj/item/clothing/suit/storage/vest/insulated
	name = "insulated technomancer armor"
	desc = "A set of armor insulated against heat and electrical shocks, shielded against radiation, and protected against blunt hits."
	icon_state = "armor_engineering"
	item_state = "armor_engineering"
	blood_overlay_type = "armor"
	armor = list(
		melee = 7,
		bullet = 7,
		energy = 2,
		bomb = 50,
		bio = 0,
		rad = 80
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	item_flags = DRAG_AND_DROP_UNEQUIP
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0
	price_tag = 600
	//Used ablative gear armor values and technomancer helmet/voidsuit values.
	slowdown = LIGHT_SLOWDOWN
	style = STYLE_NONE

/obj/item/clothing/suit/storage/vest/technomancer_old
	name = "reinforced Technomancer armor"
	desc = "Technomancer League's ballistic armor, less protective against industrial hazards but better in a fight."
	icon_state = "armor_engineering_old"
	item_state = "armor_engineering_old"
	blood_overlay_type = "armor"
	armor = list(
		melee = 9,
		bullet = 9,
		energy = 9,
		bomb = 75,
		bio = 0,
		rad = 0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	item_flags = DRAG_AND_DROP_UNEQUIP
	siemens_coefficient = 0.5
	price_tag = 600
	slowdown = LIGHT_SLOWDOWN
	style = STYLE_NONE

/*
 * Reactive Armor
 */
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armor"
	desc = "Someone separated our Research Director's head from their body!"
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(
		melee = 5,
		bullet = 5,
		energy = 5,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	var/active = FALSE
	var/entropy_value = 2

/obj/item/clothing/suit/armor/reactive/handle_shield(mob/user, damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	if(prob(50))
		user.visible_message(SPAN_DANGER("The reactive teleport system flings [user] clear of the attack!"))
		var/turf/TLoc = get_turf(user)
		var/turf/picked = get_random_secure_turf_in_range(src, 7, 1)
		if(!picked) return
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		go_to_bluespace(TLoc, entropy_value, TRUE, user, picked)
		return PROJECTILE_FORCE_MISS
	return FALSE

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	src.active = !( src.active )
	if (src.active)
		to_chat(user, "\blue The reactive armor is now active.")
		src.icon_state = "reactive"
		src.item_state = "reactive"
	else
		to_chat(user, "\blue The reactive armor is now inactive.")
		src.icon_state = "reactiveoff"
		src.item_state = "reactiveoff"
		src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"
	..()

/obj/item/clothing/suit/armor/crusader
	name = "crusader armor"
	desc = "God will protect those who defend his faith."
	icon_state = "crusader_suit"
	item_state = "crusader_suit"
	matter = list(MATERIAL_BIOMATTER = 25, MATERIAL_PLASTEEL = 10, MATERIAL_STEEL = 15, MATERIAL_GOLD = 2)
	armor = list(
		melee = 13,
		bullet = 13,
		energy = 13,
		bomb = 75,
		bio = 0,
		rad = 0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS
	unacidable = TRUE
	spawn_blacklisted = TRUE
	slowdown = LIGHT_SLOWDOWN

/obj/item/clothing/suit/armor/paramedic
	name = "Moebius paramedic armor"
	desc = "Seven minutes or a refund."
	icon_state = "trauma_team"
	item_state = "trauma_team"
	matter = list(
		MATERIAL_PLASTEEL = 10,
		MATERIAL_STEEL = 5,
		MATERIAL_PLASTIC = 5,
		MATERIAL_PLATINUM = 3,
		MATERIAL_URANIUM = 4,
		MATERIAL_SILVER = 2
		)
	armor = list(
		melee = 7,
		bullet = 10,
		energy = 10,
		bomb = 20,
		bio = 100,
		rad = 50
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS
	spawn_blacklisted = TRUE
	style = STYLE_HIGH
	action_button_name = "Toggle Acceleration"
	var/speed_boost_ready = TRUE
	var/speed_boost_active = FALSE
	var/speed_boost_power = -0.5
	var/speed_boost_length = 30 SECONDS
	var/speed_boost_cooldown = 5 MINUTES
	var/matching_helmet = /obj/item/clothing/head/armor/faceshield/paramedic
	slowdown = 0 // No slowdown in exchange for worse accuracy


/obj/item/clothing/suit/armor/paramedic/ui_action_click(mob/living/user, action_name)
	if(..())
		return TRUE

	trigger_speed_boost(user)


/obj/item/clothing/suit/armor/paramedic/proc/trigger_speed_boost(mob/living/carbon/human/user)
	if(!istype(user))
		return

	if(!speed_boost_ready)
		if(user.head && istype(user.head, matching_helmet))
			if(speed_boost_active)
				to_chat(usr, SPAN_WARNING("[user.head] beeps: 'Acceleration protocol active.'"))
			else
				to_chat(usr, SPAN_WARNING("[user.head] beeps: 'Acceleration protocol failture. Insufficient capacitor charge.'"))
		return

	speed_boost_ready = FALSE
	speed_boost_active = TRUE
	slowdown = speed_boost_power

	if(user.head && istype(user.head, matching_helmet))
		to_chat(usr, SPAN_WARNING("[user.head] beeps: 'Acceleration protocol initiated.'"))

	spawn(speed_boost_length)
		if(QDELETED(src))
			return
		slowdown = initial(slowdown)
		speed_boost_active = FALSE
		if(user.head && istype(user.head, matching_helmet))
			to_chat(usr, SPAN_WARNING("[user.head] beeps: 'Capacitors discharged. Acceleration protocol aborted.'"))

		spawn(speed_boost_cooldown)
			if(QDELETED(src))
				return
			speed_boost_ready = TRUE
			if(user.head && istype(user.head, matching_helmet))
				to_chat(usr, SPAN_WARNING("[user.head] beeps: 'Capacitors have been recharged.'"))
