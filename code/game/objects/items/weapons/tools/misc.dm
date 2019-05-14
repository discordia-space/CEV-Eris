/obj/item/weapon/tool/omnitool
	name = "Asters \"Munchkin 5000\""
	desc = "Fuel powered monster of a tool. Its weldier part is most advanced one, capable of welding things without harmfull glow and sparks, so no protection needed."
	icon_state = "omnitool"
	w_class = ITEM_SIZE_NORMAL
	worksound = WORKSOUND_DRIVER_TOOL
	switched_on_qualities = list(QUALITY_SCREW_DRIVING = 50, QUALITY_BOLT_TURNING = 50, QUALITY_DRILLING = 20, QUALITY_WELDING = 30, QUALITY_CAUTERIZING = 10)

	use_fuel_cost = 0.1
	max_fuel = 50

	toggleable = TRUE
	create_hot_spot = TRUE
	glow_color = COLOR_ORANGE
	max_upgrades = 5

/obj/item/weapon/tool/medmultitool
	name = "One Star medmultitool"
	desc = "A compact One Star medical multitool. It has all surgery tools."
	icon_state = "medmulti"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_GLASS = 2, MATERIAL_PLATINUM = 2)
	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4)
	tool_qualities = list(QUALITY_CLAMPING = 30, QUALITY_RETRACTING = 30, QUALITY_BONE_SETTING = 30, QUALITY_CAUTERIZING = 30, QUALITY_SAWING = 15, QUALITY_CUTTING = 30, QUALITY_WIRE_CUTTING = 25)

	max_upgrades = 2
	workspeed = 1.2
