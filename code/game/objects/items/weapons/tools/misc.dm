/obj/item/weapon/tool/omnitool
	name = "omni tool"
	desc = "Fuel powered."
	icon_state = "omnitool"
	w_class = ITEM_SIZE_NORMAL
	worksound = WORKSOUND_DRIVER_TOOL
	switched_on_qualities = list(QUALITY_SCREW_DRIVING = 5, QUALITY_BOLT_TURNING = 5, QUALITY_DRILLING = 2, QUALITY_WELDING = 3, QUALITY_CAUTERIZING = 1)

	use_fuel_cost = 2
	max_fuel = 30

	toggleable = TRUE
	create_hot_spot = TRUE
	glow_color = COLOR_ORANGE
