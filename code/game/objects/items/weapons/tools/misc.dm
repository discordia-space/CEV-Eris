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
	name = "-One Star- medmultitool"
	desc = "A compact \"One Star\" medical multitool. It can cut things and stop bleeding by spraying biomedical gel. Require fuel to synthesize from."
	icon_state = "medmulti"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_GLASS = 2, MATERIAL_PLATINUM = 2)
	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4)
	tool_qualities = list(QUALITY_CAUTERIZING = 40)

	toggleable = TRUE
	switched_on_qualities = list(QUALITY_CUTTING = 35, QUALITY_WIRE_CUTTING = 25)
	switched_off_qualities = list(QUALITY_CAUTERIZING = 40)

	max_upgrades = 2
	workspeed = 1.8

	use_fuel_cost = 0.1
	passive_fuel_cost = 0
	max_fuel = 20


/obj/item/weapon/tool/medmultitool/turn_on(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("You changed [src]'s current mode to cuttery."))
	use_fuel_cost = 0
	playsound(loc, 'sound/items/lighter.ogg', 80, 1)


/obj/item/weapon/tool/medmultitool/turn_off(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("You changed [src]'s current mode to cautery."))
	use_fuel_cost = initial(use_fuel_cost)
	playsound(loc, 'sound/items/lighter.ogg', 80, 1)