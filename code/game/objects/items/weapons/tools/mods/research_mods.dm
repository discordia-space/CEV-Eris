//REINFORCEMENTS

// Plasmablock can be attached to any tool that uses fuel or power
/obj/item/weapon/tool_upgrade/reinforcement/plasmablock
	name = "plasmablock"
	desc = "A plasmablock is way more efficient to dissipate heat than classic heatsinks or waterblocks thanks to the tremendous heat-transfer capacity of liquid plasma. The fluid that is actively pumped through a radiator and cooled by fans. It greatly extends the lifespan of power tools."
	icon_state = "plasmablock"
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_PLASTIC = 2, MATERIAL_PLASMA = 1)

/obj/item/weapon/tool_upgrade/reinforcement/plasmablock/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.45,
		UPGRADE_HEALTH_THRESHOLD = 10,
		UPGRADE_POWERCOST_MULT = 1.1,
		UPGRADE_FUELCOST_MULT = 1.1
		)
	I.prefix = "plasma-cooled"
	I.req_fuel_cell = REQ_FUEL_OR_CELL


/obj/item/weapon/tool_upgrade/reinforcement/rubbermesh
	name = "rubber mesh"
	desc = "A rubber mesh that can wrapped around sensitive parts of a tool, protecting them from impacts and debris."
	icon_state = "rubbermesh"
	matter = list(MATERIAL_PLASTIC = 3)

/obj/item/weapon/tool_upgrade/reinforcement/rubbermesh/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.7,
	UPGRADE_BULK = 1,
	UPGRADE_HEALTH_THRESHOLD = 5
	)
	I.required_qualities = list(QUALITY_CUTTING,QUALITY_DRILLING, QUALITY_SAWING, QUALITY_DIGGING, QUALITY_EXCAVATION, QUALITY_WELDING, QUALITY_HAMMERING)
	I.prefix = "rubber-wrapped"

//REFINEMENTS


/obj/item/weapon/tool_upgrade/refinement/compensatedbarrel
	name = "gravity compensated barrel"
	desc = "A barrel extension for welding tools that integrates a miniaturized gravity generator that help keep the torch steady by compensating the weight of the tool."
	icon_state = "compensatedbarrel"
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_GOLD = 1)

/obj/item/weapon/tool_upgrade/refinement/compensatedbarrel/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 20,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_POWERCOST_MULT = 1.05,
	UPGRADE_FUELCOST_MULT = 1.05,
	UPGRADE_BULK = 1
	)
	I.required_qualities = list(QUALITY_WELDING)
	I.prefix = "gravity-compensated"
	I.req_fuel_cell = REQ_FUEL_OR_CELL



/obj/item/weapon/tool_upgrade/refinement/vibcompensator
	name = "vibration compensator"
	desc = "A ground-breaking innovation that dampens the vibration of a tool by emitting sound waves in a specific pattern. It does not make any sense but neither do you by installing that on your tool."
	icon_state = "vibcompensator"
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 1, MATERIAL_GOLD = 1)

/obj/item/weapon/tool_upgrade/refinement/vibcompensator/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 5,
	UPGRADE_HEALTH_THRESHOLD = 5,
	)
	I.required_qualities = list(QUALITY_CUTTING,QUALITY_WIRE_CUTTING, QUALITY_SCREW_DRIVING, QUALITY_WELDING,QUALITY_PULSING, QUALITY_CLAMPING, QUALITY_CAUTERIZING, QUALITY_BONE_SETTING, QUALITY_LASER_CUTTING)
	I.prefix = "vibration-compensated"


//PRODUCTIVITY


/obj/item/weapon/tool_upgrade/productivity/antistaining
	name = "anti-staining paint"
	desc = "Applying a thin coat of this paint on a tool prevents stains, dirt or dust to adhere to its surface."
	icon_state = "antistaining"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 2)

/obj/item/weapon/tool_upgrade/productivity/antistaining/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.7,
	UPGRADE_ITEMFLAGPLUS = NOBLOODY
	)
	I.prefix = "anti-stain coated"



/obj/item/weapon/tool_upgrade/productivity/booster
	name = "booster"
	desc = "When you do not care about energy comsumption and just want to get shit done quickly. This device shunts the power safeties of your tool whether it uses fuel or electricity."
	icon_state = "booster"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 2, MATERIAL_GOLD = 1)

/obj/item/weapon/tool_upgrade/productivity/booster/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.35,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_POWERCOST_MULT = 2,
	UPGRADE_FUELCOST_MULT = 2
	)
	I.prefix = "boosted"
	I.req_fuel_cell = REQ_CELL


/obj/item/weapon/tool_upgrade/productivity/injector
	name = "plasma injector"
	desc = "If the words \"safety regulations\" do not mean anything to you, you may consider installing this fine piece of technology on your tool. It injects small amounts of plasma in the fuel mix before combustion to greatly increase its power output, making all kinds of tasks easier to perform."
	icon_state = "injector"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 2, MATERIAL_PLASMA = 2)

/obj/item/weapon/tool_upgrade/productivity/injector/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.5,
	UPGRADE_DEGRADATION_MULT = 1.3,
	UPGRADE_FUELCOST_MULT = 1.3,
	UPGRADE_HEALTH_THRESHOLD = -10
	)
	I.prefix = "plasma-fueled"
	I.req_fuel_cell = REQ_FUEL


//AUGMENTS

/obj/item/weapon/tool_upgrade/augment/hydraulic
	name = "hydraulic circuits"
	desc = "A complex set of hydraulic circuits that can be installed on a tool to greatly improve its functions. It's loud as hell though so do not plan on being stealthy."
	icon_state = "hydraulic"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 3)
	spawn_blacklisted = TRUE

/obj/item/weapon/tool_upgrade/augment/hydraulic/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.5,
	UPGRADE_DEGRADATION_MULT = 1.5,
	UPGRADE_FUELCOST_MULT = 1.5,
	UPGRADE_POWERCOST_MULT = 1.5,
	UPGRADE_ITEMFLAGPLUS = LOUD
	)
	I.prefix = "hydraulic"


