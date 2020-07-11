/******************************
	UPGRADE TYPES
******************************/
// 	 REINFORCEMENT: REDUCES TOOL DEGRADATION
//------------------------------------------------

//This can be attached to basically any long tool
//This includes most mechanical ones
/obj/item/weapon/tool_upgrade/reinforcement/stick
	name = "brace bar"
	desc = "A sturdy pole made of fiber tape and plasteel rods. Can be used to reinforce the shaft of many tools."
	icon_state = "brace_bar"

	price_tag = 120
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_PLASTIC = 1)

//list/tool_upgrades, list/required_qualities, list/negative_qualities, prefix, req_fuel, req_cell

/obj/item/weapon/tool_upgrade/reinforcement/stick/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.65,
		UPGRADE_FORCE_MOD = 1,
		)

	I.required_qualities = list(QUALITY_BOLT_TURNING,QUALITY_PRYING, QUALITY_SAWING,QUALITY_SHOVELING,QUALITY_DIGGING,QUALITY_EXCAVATION)
	I.prefix = "braced"

// High-tech version of the stick
/obj/item/weapon/tool_upgrade/reinforcement/stick/hightech
	name = "high-tech brace bar"
	desc = "A high-tech sturdy pole made of fiber tape and plasteel rods. Can be used to reinforce the shaft of many tools."

/obj/item/weapon/tool_upgrade/reinforcement/stick/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.45,
		UPGRADE_FORCE_MOD = 2,
		)

//Heatsink can be attached to any tool that uses fuel or power
/obj/item/weapon/tool_upgrade/reinforcement/heatsink
	name = "heatsink"
	desc = "An array of plasteel fins which dissipates heat, reducing damage and extending the lifespan of power tools."
	icon_state = "heatsink"
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_PLASTIC = 1)

/obj/item/weapon/tool_upgrade/reinforcement/heatsink/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.65,
		UPGRADE_HEALTH_THRESHOLD = 10
		)
	I.prefix = "heatsunk"
	I.req_fuel_cell = REQ_FUEL_OR_CELL

// High-tech version of the heatsink
/obj/item/weapon/tool_upgrade/reinforcement/heatsink/hightech
	name = "high-tech heatsink"
	desc = "A high-tech array of plasteel fins which dissipates heat, reducing damage and extending the lifespan of power tools."

/obj/item/weapon/tool_upgrade/reinforcement/heatsink/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.45,
		UPGRADE_HEALTH_THRESHOLD = 20,
		)

/obj/item/weapon/tool_upgrade/reinforcement/plating
	name = "reinforced plating"
	desc = "A sturdy bit of plasteel that can be bolted onto any tool to protect it. Tough, but bulky."
	icon_state = "plate"
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_STEEL = 2) //steel to compensate for metal rods used in crafting

/obj/item/weapon/tool_upgrade/reinforcement/plating/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.55,
	UPGRADE_FORCE_MOD = 1,
	UPGRADE_PRECISION = -5,
	UPGRADE_BULK = 1,
	UPGRADE_HEALTH_THRESHOLD = 10)
	I.prefix = "reinforced"

// High-tech version of the plating
/obj/item/weapon/tool_upgrade/reinforcement/plating/hightech
	name = "high-tech reinforced plating"
	desc = "A high-tech sturdy bit of plasteel that can be bolted onto any tool to protect it. Tough, but bulky."

/obj/item/weapon/tool_upgrade/reinforcement/plating/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.35,
	UPGRADE_FORCE_MOD = 2,
	UPGRADE_PRECISION = -5,
	UPGRADE_BULK = 1,
	UPGRADE_HEALTH_THRESHOLD = 20
	)

/obj/item/weapon/tool_upgrade/reinforcement/guard
	name = "metal guard"
	desc = "A bent piece of metal that wraps around sensitive parts of a tool, protecting it from impacts, debris, and stray fingers."
	icon_state = "guard"
	matter = list(MATERIAL_PLASTEEL = 5)

/obj/item/weapon/tool_upgrade/reinforcement/guard/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.75,
	UPGRADE_PRECISION = 5,
	UPGRADE_HEALTH_THRESHOLD = 10
	)
	I.required_qualities = list(QUALITY_CUTTING,QUALITY_DRILLING, QUALITY_SAWING, QUALITY_DIGGING, QUALITY_EXCAVATION, QUALITY_WELDING, QUALITY_HAMMERING)
	I.prefix = "shielded"

// High-tech version of the guard
/obj/item/weapon/tool_upgrade/reinforcement/guard/hightech
	name = "high-tech metal guard"
	desc = "A high-tech bent piece of metal that wraps around sensitive parts of a tool, protecting it from impacts, debris, and stray fingers."

/obj/item/weapon/tool_upgrade/reinforcement/guard/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.55,
	UPGRADE_PRECISION = 10,
	UPGRADE_HEALTH_THRESHOLD = 20
	)

// 	 PRODUCTIVITY: INCREASES WORKSPEED
//------------------------------------------------
/obj/item/weapon/tool_upgrade/productivity/ergonomic_grip
	name = "ergonomic grip"
	desc = "A replacement grip for a tool which allows it to be more precisely controlled with one hand."
	icon_state = "ergonomic"
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 5)

/obj/item/weapon/tool_upgrade/productivity/ergonomic_grip/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.15
	)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = 0.9,
	)
	I.gun_loc_tag = GUN_GRIP
	I.req_gun_tags = list(GUN_GRIP)

	I.prefix = "ergonomic"

// High-tech version of the ergonomic grip
/obj/item/weapon/tool_upgrade/productivity/ergonomic_grip/hightech
	name = "high-tech ergonomic grip"
	desc = "A high-tech replacement grip for a tool which allows it to be more precisely controlled with one hand."

/obj/item/weapon/tool_upgrade/productivity/ergonomic_grip/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.25
	)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = 0.8,
	)

/obj/item/weapon/tool_upgrade/productivity/ratchet
	name = "ratcheting mechanism"
	desc = "A mechanical upgrade for wrenches and screwdrivers which allows the tool to only turn in one direction."
	icon_state = "ratchet"
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTEEL = 4, MATERIAL_PLASTIC = 1)

/obj/item/weapon/tool_upgrade/productivity/ratchet/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.25
	)
	I.required_qualities = list(QUALITY_BOLT_TURNING,QUALITY_SCREW_DRIVING)
	I.prefix = "ratcheting"

// High-tech version of the ratchet
/obj/item/weapon/tool_upgrade/productivity/ratchet/hightech
	name = "high-tech ratcheting mechanism"
	desc = "A high-tech mechanical upgrade for wrenches and screwdrivers which allows the tool to only turn in one direction."

/obj/item/weapon/tool_upgrade/productivity/ratchet/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.35
	)

/obj/item/weapon/tool_upgrade/productivity/red_paint
	name = "red paint"
	desc = "Do red tools really work faster, or is the effect purely psychological."
	icon_state = "paint_red"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)

/obj/item/weapon/tool_upgrade/productivity/red_paint/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.20,
	UPGRADE_PRECISION = -10,
	UPGRADE_COLOR = "#FF4444"
	)
	I.prefix = "red"

// High-tech version of the red paint
/obj/item/weapon/tool_upgrade/productivity/red_paint/hightech
	name = "high-tech red paint"
	desc = "Do red tools really work faster, or is the effect purely psychological."

/obj/item/weapon/tool_upgrade/productivity/red_paint/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.30,
	UPGRADE_PRECISION = -10,
	UPGRADE_COLOR = "#FF4444"
	)

/obj/item/weapon/tool_upgrade/productivity/whetstone
	name = "sharpening block"
	desc = "A rough single-use block to sharpen a blade. The honed edge cuts smoothly."
	icon_state = "whetstone"
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_DIAMOND = 3)

/obj/item/weapon/tool_upgrade/productivity/whetstone/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.15,
	UPGRADE_PRECISION = 5,
	UPGRADE_FORCE_MULT = 1.15
	)
	I.required_qualities = list(QUALITY_CUTTING,QUALITY_SAWING, QUALITY_SHOVELING, QUALITY_WIRE_CUTTING)
	I.negative_qualities = list(QUALITY_WELDING, QUALITY_LASER_CUTTING)
	I.prefix = "sharpened"

// High-version of the whetstone
/obj/item/weapon/tool_upgrade/productivity/whetstone/hightech
	name = "high-tech sharpening block"
	desc = "A high-tech single-use block to sharpen a blade. The honed edge cuts smoothly."

/obj/item/weapon/tool_upgrade/productivity/whetstone/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.25,
	UPGRADE_PRECISION = 10,
	UPGRADE_FORCE_MULT = 1.25
	)

/obj/item/weapon/tool_upgrade/productivity/diamond_blade
	name = "Asters \"Gleaming Edge\": Diamond blade"
	desc = "An adaptable industrial grade cutting disc, with diamond dust worked into the metal. Exceptionally durable."
	icon_state = "diamond_blade"
	price_tag = 300
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_DIAMOND = 4)


/obj/item/weapon/tool_upgrade/productivity/diamond_blade/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.25,
	UPGRADE_DEGRADATION_MULT = 0.85,
	UPGRADE_FORCE_MULT = 1.10,
	)
	I.required_qualities = list(QUALITY_CUTTING, QUALITY_SHOVELING, QUALITY_SAWING, QUALITY_WIRE_CUTTING, QUALITY_PRYING)
	I.negative_qualities = list(QUALITY_WELDING, QUALITY_LASER_CUTTING)
	I.prefix = "diamond-edged"

// High-version of the diamond_blade
/obj/item/weapon/tool_upgrade/productivity/diamond_blade/hightech
	name = "high-tech diamond blade"
	desc = "An adaptable high-tech cutting disc, with diamond dust worked into the metal. Exceptionally durable."

/obj/item/weapon/tool_upgrade/productivity/diamond_blade/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.35,
	UPGRADE_DEGRADATION_MULT = 0.75,
	UPGRADE_FORCE_MULT = 1.20,
	)

/obj/item/weapon/tool_upgrade/productivity/oxyjet
	name = "oxyjet canister"
	desc = "A canister of pure, compressed oxygen with adapters for mounting onto a welding tool. Used alongside fuel, it allows for higher burn temperatures."
	icon_state = "oxyjet"
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_PLASTIC = 1)


/obj/item/weapon/tool_upgrade/productivity/oxyjet/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.20,
	UPGRADE_FORCE_MULT = 1.15,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_HEALTH_THRESHOLD = -10
	)
	I.required_qualities = list(QUALITY_WELDING)
	I.prefix = "oxyjet"

// High-tech version of the oxyjet
/obj/item/weapon/tool_upgrade/productivity/oxyjet/hightech
	name = "high-tech oxyjet canister"
	desc = "A high-tech canister of pure, compressed oxygen with adapters for mounting onto a welding tool. Used alongside fuel, it allows for higher burn temperatures."

/obj/item/weapon/tool_upgrade/productivity/oxyjet/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.30,
	UPGRADE_FORCE_MULT = 1.25,
	UPGRADE_DEGRADATION_MULT = 1.1,
	UPGRADE_HEALTH_THRESHOLD = -10
	)

//Enhances power tools majorly, but also increases costs
/obj/item/weapon/tool_upgrade/productivity/motor
	name = "high power motor"
	desc = "A motor for power tools with a higher horsepower than usually expected. Significantly enhances productivity and lifespan, but more expensive to run and harder to control."
	icon_state = "motor"
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTEEL = 4)

/obj/item/weapon/tool_upgrade/productivity/motor/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.5,
	UPGRADE_FORCE_MULT = 1.15,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_POWERCOST_MULT = 1.35,
	UPGRADE_FUELCOST_MULT = 1.35,
	UPGRADE_PRECISION = -10,
	UPGRADE_HEALTH_THRESHOLD = -10
	)
	I.required_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_DRILLING, QUALITY_SAWING, QUALITY_DIGGING, QUALITY_EXCAVATION, QUALITY_HAMMERING)
	I.prefix = "high-power"
	I.req_fuel_cell = REQ_FUEL_OR_CELL

// High-tech version of the motor
/obj/item/weapon/tool_upgrade/productivity/motor/hightech
	name = "high-tech high power motor"
	desc = "A high-tech motor for power tools with a higher horsepower than usually expected. Significantly enhances productivity and lifespan, but more expensive to run and harder to control."

/obj/item/weapon/tool_upgrade/productivity/motor/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.6,
	UPGRADE_FORCE_MULT = 1.25,
	UPGRADE_DEGRADATION_MULT = 1.1,
	UPGRADE_POWERCOST_MULT = 1.25,
	UPGRADE_FUELCOST_MULT = 1.25,
	UPGRADE_PRECISION = -10,
	UPGRADE_HEALTH_THRESHOLD = -10
	)

// 	 REFINEMENT: INCREASES PRECISION
//------------------------------------------------
/obj/item/weapon/tool_upgrade/refinement/laserguide
	name = "Asters \"Guiding Light\" laser guide"
	desc = "A small visible laser which can be strapped onto any tool, giving an accurate representation of its target. Helps improve precision."
	icon_state = "laser_guide"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_URANIUM = 1)

/obj/item/weapon/tool_upgrade/refinement/laserguide/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 10)
	I.weapon_upgrades = list(
	GUN_UPGRADE_RECOIL = 0.9)
	I.prefix = "laser-guided"

// High-tech version of the laserguide
/obj/item/weapon/tool_upgrade/refinement/laserguide/hightech
	name = "high-tech laser guide"
	desc = "A small high-tech visible laser which can be strapped onto any tool, giving an accurate representation of its target. Helps improve precision."

/obj/item/weapon/tool_upgrade/refinement/laserguide/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 20)
	I.weapon_upgrades = list(
	GUN_UPGRADE_RECOIL = 0.8)

//Fits onto generally small tools that require precision, especially surgical tools
//Doesn't work onlarger things like crowbars and drills
/obj/item/weapon/tool_upgrade/refinement/stabilized_grip
	name = "gyrostabilized grip"
	desc = "A fancy mechanical grip that partially floats around a tool, absorbing tremors and shocks. Allows precise work with a shaky hand."
	icon_state = "stabilizing"
	matter = list(MATERIAL_PLASTIC = 3)

/obj/item/weapon/tool_upgrade/refinement/stabilized_grip/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 10,
	UPGRADE_HEALTH_THRESHOLD = 10)
	I.required_qualities = list(QUALITY_CUTTING,QUALITY_WIRE_CUTTING, QUALITY_SCREW_DRIVING, QUALITY_WELDING,QUALITY_PULSING, QUALITY_CLAMPING, QUALITY_CAUTERIZING, QUALITY_BONE_SETTING, QUALITY_LASER_CUTTING)
	I.prefix = "stabilized"

// High-tech version of the stabilized grip
/obj/item/weapon/tool_upgrade/refinement/stabilized_grip/hightech
	name = "high-tech gyrostabilized grip"
	desc = "A fancy high-tech mechanical grip that partially floats around a tool, absorbing tremors and shocks. Allows precise work with a shaky hand."

/obj/item/weapon/tool_upgrade/refinement/stabilized_grip/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 20,
	UPGRADE_HEALTH_THRESHOLD = 10)

/obj/item/weapon/tool_upgrade/refinement/magbit
	name = "magnetic bit"
	desc = "Magnetises tools used for handling small objects, reducing instances of dropping screws and bolts."
	icon_state = "magnetic"
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTEEL = 2)

/obj/item/weapon/tool_upgrade/refinement/magbit/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 10
	)
	I.required_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_BOLT_TURNING, QUALITY_CLAMPING, QUALITY_BONE_SETTING)
	I.prefix = "magnetic"

// High-tech version of the magbit
/obj/item/weapon/tool_upgrade/refinement/magbit/hightech
	name = "high-tech magnetic bit"
	desc = "Magnetises tools used for handling small objects, reducing instances of dropping screws and bolts."

/obj/item/weapon/tool_upgrade/refinement/magbit/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 20
	)

/obj/item/weapon/tool_upgrade/refinement/ported_barrel
	name = "ported barrel"
	desc = "A barrel extension for a welding tool which helps manage gas pressure and keep the torch steady."
	icon_state = "ported_barrel"

/obj/item/weapon/tool_upgrade/refinement/ported_barrel/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 12,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_BULK = 1,
	UPGRADE_HEALTH_THRESHOLD = 10
	)
	I.required_qualities = list(QUALITY_WELDING)
	I.prefix = "ported"

// High-tech version of the ported barrel
/obj/item/weapon/tool_upgrade/refinement/ported_barrel/hightech
	name = "high-tech ported barrel"
	desc = "A high-tech barrel extension for a welding tool which helps manage gas pressure and keep the torch steady."

/obj/item/weapon/tool_upgrade/refinement/ported_barrel/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 20,
	UPGRADE_DEGRADATION_MULT = 1.1,
	UPGRADE_BULK = 1,
	UPGRADE_HEALTH_THRESHOLD = 10
	)

// 		AUGMENTS: MISCELLANEOUS AND UTILITY
//------------------------------------------------

//Allows the tool to use a cell one size category larger than it currently uses. Small to medium, medium to large, etc
/obj/item/weapon/tool_upgrade/augment/cell_mount
	name = "heavy cell mount"
	icon_state = "cell_mount"
	desc = "A bulky adapter which allows oversized power cells to be installed into small tools."
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTEEL = 2, MATERIAL_PLASTIC = 1)

/obj/item/weapon/tool_upgrade/augment/cell_mount/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_BULK = 1,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_CELLPLUS = 1
	)
	I.prefix = "medium-cell"
	I.req_fuel_cell = REQ_CELL

// High-tech version of the cell mount
/obj/item/weapon/tool_upgrade/augment/cell_mount/hightech
	name = "high-tech heavy cell mount"
	desc = "A high-tech adapter which allows oversized power cells to be installed into small tools."

/obj/item/weapon/tool_upgrade/augment/cell_mount/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_BULK = 1,
	UPGRADE_DEGRADATION_MULT = 1.05,
	UPGRADE_HEALTH_THRESHOLD = -5,
	UPGRADE_CELLPLUS = 1
	)

//Stores moar fuel!
/obj/item/weapon/tool_upgrade/augment/fuel_tank
	name = "Expanded fuel tank"
	desc = "An auxiliary tank which stores 100 extra units of fuel at the cost of degradation."
	icon_state = "canister"
	matter = list(MATERIAL_PLASTEEL = 4, MATERIAL_PLASTIC = 1)

/obj/item/weapon/tool_upgrade/augment/fuel_tank/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_BULK = 1,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_MAXFUEL = 100)
	I.prefix = "expanded"
	I.req_fuel_cell = REQ_FUEL

// High-tech version of the fuel tank
/obj/item/weapon/tool_upgrade/augment/fuel_tank/hightech
	name = "high-tech expanded fuel tank"
	desc = "An auxiliary tank which stores 150 extra units of fuel at the cost of degradation."

/obj/item/weapon/tool_upgrade/augment/fuel_tank/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_BULK = 1,
	UPGRADE_DEGRADATION_MULT = 1.1,
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_MAXFUEL = 150)

//OneStar fuel mod
/obj/item/weapon/tool_upgrade/augment/holding_tank
	name = "Expanded fuel tank of holding"
	desc = "Rare relic of OneStar uses the bluetech space to store additional 600 units of fuel at the cost of degradation."
	icon_state = "canister_holding"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 4, MATERIAL_PLATINUM = 4)

/obj/item/weapon/tool_upgrade/augment/holding_tank/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_BULK = 1,
	UPGRADE_DEGRADATION_MULT = 1.30,
	UPGRADE_HEALTH_THRESHOLD = -20,
	UPGRADE_MAXFUEL = 600
	)
	I.prefix = "holding"
	I.req_fuel_cell = REQ_FUEL


//Penalises the tool, but unlocks several more augment slots.
/obj/item/weapon/tool_upgrade/augment/expansion
	name = "expansion port"
	icon_state = "expand"
	desc = "A bulky adapter which more modifications to be attached to the tool.  A bit fragile but you can compensate."
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 1)

/obj/item/weapon/tool_upgrade/augment/expansion/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_BULK = 2,
	UPGRADE_DEGRADATION_MULT = 1.3,
	UPGRADE_PRECISION = -10,
	UPGRADE_HEALTH_THRESHOLD = -20,
	UPGRADE_MAXUPGRADES = 3
	)
	I.prefix = "custom"

// High-tech version of the expansion
/obj/item/weapon/tool_upgrade/augment/expansion/hightech
	name = "high-tech expansion port"
	desc = "A high-tech adapter which more modifications to be attached to the tool.  A bit fragile but you can compensate."

/obj/item/weapon/tool_upgrade/augment/expansion/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_BULK = 2,
	UPGRADE_DEGRADATION_MULT = 1.2,
	UPGRADE_PRECISION = -5,
	UPGRADE_HEALTH_THRESHOLD = -20,
	UPGRADE_MAXUPGRADES = 3
	)

/obj/item/weapon/tool_upgrade/augment/spikes
	name = "spikes"
	icon_state = "spike"
	desc = "An array of sharp bits of plasteel, seemingly adapted for easy affixing to a tool. Would make it into a better weapon, but won't do much for productivity."
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_STEEL = 2)

/obj/item/weapon/tool_upgrade/augment/spikes/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_FORCE_MOD = 4,
	UPGRADE_PRECISION = -5,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_WORKSPEED = -0.15,
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_SHARP = TRUE
	)
	I.prefix = "spiked"

// High-tech version of spikes
/obj/item/weapon/tool_upgrade/augment/spikes/hightech
	name = "high-tech spikes"
	desc = "A high-tech array of sharp bits of plasteel, seemingly adapted for easy affixing to a tool. Would make it into a better weapon, but won't do much for productivity."

/obj/item/weapon/tool_upgrade/augment/spikes/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_FORCE_MOD = 4,
	UPGRADE_PRECISION = -5,
	UPGRADE_DEGRADATION_MULT = 1.05,
	UPGRADE_WORKSPEED = -0.05,
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_SHARP = TRUE
	)

/obj/item/weapon/tool_upgrade/augment/hammer_addon
	name = "Flat surface"
	icon_state = "hammer_addon"
	desc = "An attachment that fits on almost everything, that gives a simple flat surface to employ the tool for hammering."
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_STEEL = 2)

/obj/item/weapon/tool_upgrade/augment/hammer_addon/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = -0.1,
	UPGRADE_HEALTH_THRESHOLD = 5,
	tool_qualities = list(QUALITY_HAMMERING = 10)
	)
	I.prefix = "flattened"

// High-tech version of hammer addon
/obj/item/weapon/tool_upgrade/augment/hammer_addon/hightech
	name = "high-tech flat surface"
	desc = "A high-tech attachment that fits on almost everything, that gives a simple flat surface to employ the tool for hammering."

/obj/item/weapon/tool_upgrade/augment/hammer_addon/hightech/New()
	..()
	var/datum/component/item_upgrade/I = (GetComponents(/datum/component/item_upgrade))[1]
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = -0.05,
	UPGRADE_HEALTH_THRESHOLD = 5,
	tool_qualities = list(QUALITY_HAMMERING = 20)
	)

//Vastly reduces tool sounds, for stealthy hacking
/obj/item/weapon/tool_upgrade/augment/dampener
	name = "aural dampener"
	desc = "This aural dampener is a cutting edge tool attachment which mostly nullifies sound waves within a tiny radius. It minimises the noise created during use, perfect for stealth operations."
	icon_state = "dampener"
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_PLASTEEL = 1, MATERIAL_PLATINUM = 1)


/obj/item/weapon/tool_upgrade/augment/dampener/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_COLOR = "#AAAAAA",
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_ITEMFLAGPLUS = SILENT
	)
	I.prefix = "silenced"

/obj/item/weapon/tool_upgrade/augment/ai_tool
	name = "Nanointegrated AI"
	desc = "A forgotten One Star tech. Due to its unique installation method of \"slapping it hard enough onto anything should do the trick\", it is highly sought after. \
			A powerful AI will integrate itself into this tool with the aid of nanotechnology, and improve it in every way possible."
	icon_state = "ai_tool"
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_PLASTEEL = 1, MATERIAL_PLATINUM = 1)

/obj/item/weapon/tool_upgrade/augment/ai_tool/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_POWERCOST_MULT = 1.20,
	UPGRADE_PRECISION = 14,
	UPGRADE_WORKSPEED = 14,
	UPGRADE_HEALTH_THRESHOLD = -10,
	)
	I.prefix = "intelligent"
	I.req_fuel_cell = REQ_CELL
	I.weapon_upgrades = list(
	GUN_UPGRADE_RECOIL = 0.8,
	GUN_UPGRADE_DAMAGE_MULT = 1.2,
	GUN_UPGRADE_PEN_MULT = 1.2,
	GUN_UPGRADE_FIRE_DELAY_MULT = 0.8,
	GUN_UPGRADE_MOVE_DELAY_MULT = 0.8,
	GUN_UPGRADE_MUZZLEFLASH = 0.8,
	GUN_UPGRADE_CHARGECOST = 0.8,
	GUN_UPGRADE_OVERCHARGE_MAX = 0.8,
	GUN_UPGRADE_OVERCHARGE_RATE = 1.2)

/obj/item/weapon/tool_upgrade/augment/repair_nano
	name = "repair nano"
	desc = "Very rare tool mod from OneStar powered by their nanomachines. It repairs the tool while in use and makes it near unbreakable."
	icon_state = "repair_nano"
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_PLASTEEL = 1, MATERIAL_PLATINUM = 1)

/obj/item/weapon/tool_upgrade/augment/repair_nano/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.01,
	UPGRADE_HEALTH_THRESHOLD = 10
	)
	I.prefix = "self-healing"
