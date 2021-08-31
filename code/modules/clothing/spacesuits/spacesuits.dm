//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!

/obj/item/clothing/head/space
	name = "space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT|COVER_PREVENT_MANIPULATION
	item_state_slots = list(
		slot_l_hand_str = "s_helmet",
		slot_r_hand_str = "s_helmet",
		)
	permeability_coefficient = 0.01
	armor = list(
		melee = 10,
		bullet = 10,
		energy = 10,
		bomb = 0,
		bio = 100,
		rad = 50
	)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES|EARS
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	species_restricted = list("exclude")
	flash_protection = FLASH_PROTECTION_MAJOR
	price_tag = 100
	spawn_blacklisted = TRUE
	bad_type = /obj/item/clothing/head/space
	style = STYLE_NEG_HIGH

	var/obj/machinery/camera/camera
	var/list/camera_networks

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = FALSE

/obj/item/clothing/head/space/Initialize()
	. = ..()
	if(camera_networks && camera_networks.len)
		verbs += /obj/item/clothing/head/space/proc/toggle_camera

/obj/item/clothing/head/space/proc/toggle_camera()
	set name = "Toggle Helmet Camera"
	set category = "Object"
	set src in usr

	if(!camera && camera_networks)
		camera = new /obj/machinery/camera(src)
		camera.replace_networks(camera_networks)
		camera.set_status(0)

	if(camera)
		camera.set_status(!camera.status)
		if(camera.status)
			camera.c_tag = FindNameFromID(usr)
			to_chat(usr, SPAN_NOTICE("User scanned as [camera.c_tag]. Camera activated."))
		else
			to_chat(usr, SPAN_NOTICE("Camera deactivated."))

/obj/item/clothing/head/space/examine(var/mob/user)
	if(..(user, 1) && camera_networks && camera_networks.len)
		to_chat(user, "This helmet has a built-in camera. It's [camera && camera.status ? "" : "in"]active.")

/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A cheap and bulky suit that protects against low pressure environments."
	icon_state = "space"
	item_state = "s_suit"
	w_class = ITEM_SIZE_BULKY
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|COVER_PREVENT_MANIPULATION
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	matter = list(MATERIAL_PLASTIC = 30, MATERIAL_STEEL = 10)
	slowdown = 1
	armor = list(
		melee = 10,
		bullet = 10,
		energy = 10,
		bomb = 0,
		bio = 100,
		rad = 50
	)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude")
	equip_delay = 4 SECONDS
	bad_type = /obj/item/clothing/suit/space
	style = STYLE_NEG_HIGH
	var/list/supporting_limbs //If not-null, automatically splints breaks. Checked when removing the suit.

/obj/item/clothing/suit/space/equipped(mob/M)
	check_limb_support()
	..()

/obj/item/clothing/suit/space/dropped(mob/user)
	check_limb_support(user)
	..()

// Some space suits are equipped with reactive membranes that support
// broken limbs - at the time of writing, only the ninja suit, but
// I can see it being useful for other suits as we expand them. ~ Z
// The actual splinting occurs in /obj/item/organ/external/proc/fracture()
/obj/item/clothing/suit/space/proc/check_limb_support(mob/living/carbon/human/user)

	// If this isn't set, then we don't need to care.
	if(!supporting_limbs || !supporting_limbs.len)
		return

	if(!istype(user) || user.wear_suit == src)
		return

	// Otherwise, remove the splints.
	for(var/obj/item/organ/external/E in supporting_limbs)
		E.status &= ~ ORGAN_SPLINTED
		to_chat(user, "The suit stops supporting your [E.name].")
	supporting_limbs = list()
