/*
 * Contains
 * /obj/item/rig_module/vision
 * /obj/item/rig_module/vision/multi
 * /obj/item/rig_module/vision/meson
 * /obj/item/rig_module/vision/thermal
 * /obj/item/rig_module/vision/nvg
 * /obj/item/rig_module/vision/medhud
 * /obj/item/rig_module/vision/sechud
 */

/datum/rig_vision
	var/mode
	var/obj/item/clothing/glasses/glasses

/datum/rig_vision/nvg
	mode = "night69ision"
/datum/rig_vision/nvg/New()
	glasses = new /obj/item/clothing/glasses/powered/night

/datum/rig_vision/thermal
	mode = "thermal scanner"
/datum/rig_vision/thermal/New()
	glasses = new /obj/item/clothing/glasses/powered/thermal

/datum/rig_vision/meson
	mode = "meson scanner"
/datum/rig_vision/meson/New()
	glasses = new /obj/item/clothing/glasses/powered/meson

/datum/rig_vision/sechud
	mode = "security HUD"
/datum/rig_vision/sechud/New()
	glasses = new /obj/item/clothing/glasses/hud/security

/datum/rig_vision/medhud
	mode = "medical HUD"
/datum/rig_vision/medhud/New()
	glasses = new /obj/item/clothing/glasses/hud/health

/obj/item/rig_module/vision

	name = "hardsuit69isor"
	desc = "A layered, translucent69isor system for a hardsuit."
	icon_state = "optics"

	active_power_cost = 0.05

	interface_name = "optical scanners"
	interface_desc = "An integrated69ulti-mode69ision system."

	usable = 1
	toggleable = 1
	disruptive = 0

	engage_string = "Cycle69isor69ode"
	activate_string = "Enable69isor"
	deactivate_string = "Disable69isor"
	bad_type = /obj/item/rig_module/vision
	var/datum/rig_vision/vision
	var/list/vision_modes = list(
		/datum/rig_vision/nvg,
		/datum/rig_vision/thermal,
		/datum/rig_vision/meson
		)

	var/vision_index

/obj/item/rig_module/vision/multi

	name = "hardsuit optical package"
	desc = "A complete69isor system of optical scanners and69ision69odes."
	icon_state = "fulloptics"


	interface_name = "multi optical69isor"
	interface_desc = "An integrated69ulti-mode69ision system."

	vision_modes = list(/datum/rig_vision/meson,
						/datum/rig_vision/nvg,
						/datum/rig_vision/thermal,
						/datum/rig_vision/sechud,
						/datum/rig_vision/medhud)
	rarity_value = 100

/obj/item/rig_module/vision/meson
	name = "hardsuit69eson scanner"
	desc = "A layered, translucent69isor system for a hardsuit."
	icon_state = "meson"

	usable = 0

	interface_name = "meson scanner"
	interface_desc = "An integrated69eson scanner."

	vision_modes = list(/datum/rig_vision/meson)
	spawn_tags = SPAWN_TAG_RIG_MODULE_COMMON

/obj/item/rig_module/vision/thermal
	name = "hardsuit thermal scanner"
	desc = "A layered, translucent69isor system for a hardsuit."
	icon_state = "thermal"

	usable = 0

	interface_name = "thermal scanner"
	interface_desc = "An integrated thermal scanner."

	vision_modes = list(/datum/rig_vision/thermal)
	rarity_value = 50

/obj/item/rig_module/vision/nvg
	name = "hardsuit night69ision interface"
	desc = "A69ulti input night69ision system for a hardsuit."
	icon_state = "night"

	usable = 0

	interface_name = "night69ision interface"
	interface_desc = "An integrated night69ision system."
	vision_modes = list(/datum/rig_vision/nvg)
	rarity_value = 30

/obj/item/rig_module/vision/sechud

	name = "hardsuit security hud"
	desc = "A simple tactical information system for a hardsuit."
	icon_state = "securityhud"

	usable = 0

	interface_name = "security HUD"
	interface_desc = "An integrated security heads up display."

	vision_modes = list(/datum/rig_vision/sechud)
	spawn_tags = SPAWN_TAG_RIG_MODULE_COMMON

/obj/item/rig_module/vision/medhud
	name = "hardsuit69edical hud"
	desc = "A simple69edical status indicator for a hardsuit."
	icon_state = "healthhud"

	usable = 0

	interface_name = "medical HUD"
	interface_desc = "An integrated69edical heads up display."

	vision_modes = list(/datum/rig_vision/medhud)
	spawn_tags = SPAWN_TAG_RIG_MODULE_COMMON


// There should only ever be one69ision69odule installed in a suit.
/obj/item/rig_module/vision/installed()
	..()
	holder.visor = src

/obj/item/rig_module/vision/engage()

	var/starting_up = !active

	if(!..() || !vision_modes)
		return 0

	// Don't cycle if this engage() is being called by activate().
	if(starting_up)
		to_chat(holder.wearer, "<font color='blue'>You activate your69isual sensors.</font>")
		return 1

	if(vision_modes.len > 1)
		vision_index++
		if(vision_index >69ision_modes.len)
			vision_index = 1
		vision =69ision_modes69vision_index69

		to_chat(holder.wearer, "<font color='blue'>You cycle your sensors to <b>69vision.mode69</b>69ode.</font>")
	else
		to_chat(holder.wearer, "<font color='blue'>Your sensors only have one69ode.</font>")
	return 1

/obj/item/rig_module/vision/New()
	..()

	if(!vision_modes)
		return

	vision_index = 1
	var/list/processed_vision = list()

	for(var/vision_mode in69ision_modes)
		var/datum/rig_vision/vision_datum = new69ision_mode
		if(!vision)69ision =69ision_datum
		processed_vision +=69ision_datum

	vision_modes = processed_vision
