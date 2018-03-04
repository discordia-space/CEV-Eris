/obj/item/weapon/tool/omnitool
	name = "Asters \"Munchkin 5000\""
	desc = "Fuel powered monster of a tool. Its weldier part is most advanced one, capable of welding things without harmfull glow and sparks, so no protection needed."
	icon_state = "omnitool"
	w_class = ITEM_SIZE_NORMAL
	worksound = WORKSOUND_DRIVER_TOOL
	switched_on_qualities = list(QUALITY_SCREW_DRIVING = 5, QUALITY_BOLT_TURNING = 5, QUALITY_DRILLING = 2, QUALITY_WELDING = 3, QUALITY_CAUTERIZING = 1)

	use_fuel_cost = 1
	max_fuel = 30

	toggleable = TRUE
	create_hot_spot = TRUE
	glow_color = COLOR_ORANGE
