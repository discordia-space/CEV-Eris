/obj/item/weapon/tool
	name = "tool"
	icon = 'icons/obj/tools.dmi'
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	w_class = ITEM_SIZE_SMALL
	var/use_power_cost = 0	//For tool system, determinze how much power tool will drain from cells

/obj/item/weapon/tool/admin_debug
	name = "Electric Boogaloo 3000"
	icon_state = "red_crowbar"
	item_state = "crowbar_red"
	tool_qualities = list(QUALITY_BOLT_TURNING = 10,
							QUALITY_PRYING = 10,
							QUALITY_WELDING = 10,
							QUALITY_SCREW_DRIVING = 10,
							QUALITY_COMPRESSING = 10,
							QUALITY_CAUTERIZING = 10,
							QUALITY_RETRACTING = 10,
							QUALITY_DRILLING = 10,
							QUALITY_SAWING = 10,
							QUALITY_VEIN_FIXING = 10,
							QUALITY_BONE_SETTING = 10,
							QUALITY_BONE_FIXING = 10,
							QUALITY_SHOVELING = 10,
							QUALITY_DIGGING = 10,
							QUALITY_CUTTING = 10)
