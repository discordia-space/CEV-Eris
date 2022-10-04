/obj/item/clothing/glasses/powered/thermal
	name = "Optical Thermal Scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
	action_button_name = "Toggle Optical Matrix"
	origin_tech = list(TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_URANIUM = 3, MATERIAL_PLATINUM = 2)
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_REDUCED
	price_tag = 1000
	tick_cost = 0.5


/obj/item/clothing/glasses/powered/thermal/emp_act(severity)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/M = src.loc
		if(M.glasses == src)
			to_chat(M, SPAN_DANGER("[src] overloads and blinds you!"))
			M.eye_blind = 3
			M.eye_blurry = 5
	..()

/obj/item/clothing/glasses/powered/thermal/Initialize()
	. = ..()
	overlay = global_hud.thermal

/obj/item/clothing/glasses/powered/thermal/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_THERMAL = TRUE
		)
	I.gun_loc_tag = GUN_SCOPE
	I.req_gun_tags = list(GUN_AMR)

/obj/item/clothing/glasses/powered/thermal/syndi	//These are now a contractor item, concealed as mesons.	-Pete
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	origin_tech = list(TECH_MAGNET = 3, TECH_COVERT = 4)
	spawn_blacklisted = TRUE


/obj/item/clothing/glasses/powered/thermal/onestar
	name = "OS Type - 73 \"Zhenchayuan\""
	desc = "Chinese thermals in the shape of goggles."
	icon_state = "onestar_thermal"
	off_state = "onestar_thermal"
	darkness_view = 7
	origin_tech = list(TECH_MAGNET = 6, TECH_COVERT = 2) //add replace with Tech_Onestar when thats done made -Valo
	spawn_tags = SPAWN_TAG_ITEM_TECH_OS
	spawn_blacklisted = TRUE

/obj/item/clothing/glasses/powered/thermal/plain
	toggleable = FALSE
	activation_sound = null
	action_button_name = null

/obj/item/clothing/glasses/powered/thermal/plain/monocle
	name = "Thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh

	body_parts_covered = 0
	style = STYLE_HIGH

/obj/item/clothing/glasses/powered/thermal/plain/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0
	style = STYLE_HIGH

/obj/item/clothing/glasses/powered/thermal/plain/jensen
	name = "Optical Thermal Implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state = "syringe_kit"


