/******************************
	UPGRADE TYPES
******************************/
// 	 REINFORCEMENT: REDUCES TOOL DEGRADATION
//------------------------------------------------

//This can be attached to basically any long tool
//This includes69ost69echanical ones
/obj/item/tool_upgrade/reinforcement
	bad_type = /obj/item/tool_upgrade/reinforcement

/obj/item/tool_upgrade/reinforcement/stick
	name = "brace bar"
	desc = "A sturdy pole69ade of fiber tape and plasteel rods. Can be used to reinforce the shaft of69any tools."
	icon_state = "brace_bar"

	price_tag = 120
	matter = list(MATERIAL_PLASTEEL = 5,69ATERIAL_PLASTIC = 1)

//list/tool_upgrades, list/re69uired_69ualities, list/negative_69ualities, prefix, re69_fuel, re69_cell

/obj/item/tool_upgrade/reinforcement/stick/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.65,
		UPGRADE_FORCE_MOD = 1,
		)

	I.re69uired_69ualities = list(69UALITY_BOLT_TURNING,69UALITY_PRYING, 69UALITY_SAWING,69UALITY_SHOVELING,69UALITY_DIGGING,69UALITY_EXCAVATION)
	I.prefix = "braced"

//Heatsink can be attached to any tool that uses fuel or power
/obj/item/tool_upgrade/reinforcement/heatsink
	name = "heatsink"
	desc = "An array of plasteel fins which dissipates heat, reducing damage and extending the lifespan of power tools."
	icon_state = "heatsink"
	matter = list(MATERIAL_PLASTEEL = 5,69ATERIAL_PLASTIC = 1)

/obj/item/tool_upgrade/reinforcement/heatsink/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.65,
		UPGRADE_HEALTH_THRESHOLD = 10
		)
	I.prefix = "heatsunk"
	I.re69_fuel_cell = RE69_FUEL_OR_CELL

/obj/item/tool_upgrade/reinforcement/plating
	name = "reinforced plating"
	desc = "A sturdy bit of plasteel that can be bolted onto any tool to protect it. Tough, but bulky."
	icon_state = "plate"
	matter = list(MATERIAL_PLASTEEL = 5,69ATERIAL_STEEL = 2) //steel to compensate for69etal rods used in crafting

/obj/item/tool_upgrade/reinforcement/plating/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.55,
	UPGRADE_FORCE_MOD = 1,
	UPGRADE_PRECISION = -5,
	UPGRADE_BULK = 1,
	UPGRADE_HEALTH_THRESHOLD = 10)
	I.prefix = "reinforced"

/obj/item/tool_upgrade/reinforcement/guard
	name = "metal guard"
	desc = "A bent piece of69etal that wraps around sensitive parts of a tool, protecting it from impacts, debris, and stray fingers."
	icon_state = "guard"
	rarity_value = 20
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE
	matter = list(MATERIAL_PLASTEEL = 5)

/obj/item/tool_upgrade/reinforcement/guard/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.75,
	UPGRADE_PRECISION = 5,
	UPGRADE_HEALTH_THRESHOLD = 10
	)
	I.re69uired_69ualities = list(69UALITY_CUTTING,69UALITY_DRILLING, 69UALITY_SAWING, 69UALITY_DIGGING, 69UALITY_EXCAVATION, 69UALITY_WELDING, 69UALITY_HAMMERING)
	I.prefix = "shielded"

// Plasmablock can be attached to any tool that uses fuel or power
/obj/item/tool_upgrade/reinforcement/plasmablock
	name = "plasmablock"
	desc = "A plasmablock is way69ore efficient to dissipate heat than classic heatsinks or waterblocks thanks to the tremendous heat-transfer capacity of li69uid plasma. The fluid that is actively pumped through a radiator and cooled by fans. It greatly extends the lifespan of power tools."
	icon_state = "plasmablock"
	matter = list(MATERIAL_PLASTEEL = 5,69ATERIAL_PLASTIC = 2,69ATERIAL_PLASMA = 1)

/obj/item/tool_upgrade/reinforcement/plasmablock/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.45,
		UPGRADE_HEALTH_THRESHOLD = 10,
		UPGRADE_POWERCOST_MULT = 1.05,
		UPGRADE_FUELCOST_MULT = 1.05
		)
	I.prefix = "plasma-cooled"
	I.re69_fuel_cell = RE69_FUEL_OR_CELL

/obj/item/tool_upgrade/reinforcement/rubbermesh
	name = "rubber69esh"
	desc = "A rubber69esh that can wrapped around sensitive parts of a tool, protecting them from impacts and debris."
	icon_state = "rubbermesh"
	matter = list(MATERIAL_PLASTIC = 3)

/obj/item/tool_upgrade/reinforcement/rubbermesh/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.7,
	UPGRADE_HEALTH_THRESHOLD = 5
	)
	I.re69uired_69ualities = list(69UALITY_CUTTING,69UALITY_DRILLING, 69UALITY_SAWING, 69UALITY_DIGGING, 69UALITY_EXCAVATION, 69UALITY_WELDING, 69UALITY_HAMMERING)
	I.prefix = "rubber-wrapped"

// 	 PRODUCTIVITY: INCREASES WORKSPEED
//------------------------------------------------
/obj/item/tool_upgrade/productivity
	bad_type = /obj/item/tool_upgrade/productivity

/obj/item/tool_upgrade/productivity/ergonomic_grip
	name = "ergonomic grip"
	desc = "A replacement grip for a tool which allows it to be69ore precisely controlled with one hand."
	icon_state = "ergonomic"
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 5)
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE

/obj/item/tool_upgrade/productivity/ergonomic_grip/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.15
	)
	I.weapon_upgrades = list(
		GUN_UPGRADE_RECOIL = 0.9,
	)
	I.gun_loc_tag = GUN_GRIP
	I.re69_gun_tags = list(GUN_GRIP)

	I.prefix = "ergonomic"

/obj/item/tool_upgrade/productivity/ratchet
	name = "ratcheting69echanism"
	desc = "A69echanical upgrade for wrenches and screwdrivers which allows the tool to only turn in one direction."
	icon_state = "ratchet"
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_PLASTEEL = 4,69ATERIAL_PLASTIC = 1)

/obj/item/tool_upgrade/productivity/ratchet/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.25
	)
	I.re69uired_69ualities = list(69UALITY_BOLT_TURNING,69UALITY_SCREW_DRIVING)
	I.prefix = "ratcheting"

/obj/item/tool_upgrade/productivity/red_paint
	name = "red paint"
	desc = "Do red tools really work faster, or is the effect purely psychological?"
	icon_state = "paint_red"
	rarity_value = 20
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLASTIC = 1)

/obj/item/tool_upgrade/productivity/red_paint/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.20,
	UPGRADE_PRECISION = -10,
	UPGRADE_COLOR = "#FF4444"
	)
	I.prefix = "red"

/obj/item/tool_upgrade/productivity/whetstone
	name = "sharpening block"
	desc = "A rough single-use block to sharpen a blade. The honed edge cuts smoothly."
	icon_state = "whetstone"
	rarity_value = 30
	matter = list(MATERIAL_PLASTEEL = 5,69ATERIAL_DIAMOND = 3)

/obj/item/tool_upgrade/productivity/whetstone/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.15,
	UPGRADE_PRECISION = 5,
	UPGRADE_FORCE_MULT = 1.15
	)
	I.re69uired_69ualities = list(69UALITY_CUTTING,69UALITY_SAWING, 69UALITY_SHOVELING, 69UALITY_WIRE_CUTTING)
	I.negative_69ualities = list(69UALITY_WELDING, 69UALITY_LASER_CUTTING)
	I.prefix = "sharpened"

/obj/item/tool_upgrade/productivity/diamond_blade
	name = "Asters \"Gleaming Edge\": Diamond blade"
	desc = "An adaptable industrial grade cutting disc, with diamond dust worked into the69etal. Exceptionally durable."
	icon_state = "diamond_blade"
	price_tag = 300
	rarity_value = 60
	matter = list(MATERIAL_PLASTEEL = 3,69ATERIAL_DIAMOND = 4)
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE

/obj/item/tool_upgrade/productivity/diamond_blade/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.25,
	UPGRADE_DEGRADATION_MULT = 0.85,
	UPGRADE_FORCE_MULT = 1.10,
	)
	I.re69uired_69ualities = list(69UALITY_CUTTING, 69UALITY_SHOVELING, 69UALITY_SAWING, 69UALITY_WIRE_CUTTING, 69UALITY_PRYING)
	I.negative_69ualities = list(69UALITY_WELDING, 69UALITY_LASER_CUTTING)
	I.prefix = "diamond-edged"

/obj/item/tool_upgrade/productivity/oxyjet
	name = "oxyjet canister"
	desc = "A canister of pure, compressed oxygen with adapters for69ounting onto a welding tool. Used alongside fuel, it allows for higher burn temperatures."
	icon_state = "oxyjet"
	rarity_value = 20
	matter = list(MATERIAL_PLASTEEL = 5,69ATERIAL_PLASTIC = 1)

/obj/item/tool_upgrade/productivity/oxyjet/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.20,
	UPGRADE_FORCE_MULT = 1.15,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_HEALTH_THRESHOLD = -10
	)
	I.re69uired_69ualities = list(69UALITY_WELDING)
	I.prefix = "oxyjet"

//Enhances power tools69ajorly, but also increases costs
/obj/item/tool_upgrade/productivity/motor
	name = "high power69otor"
	desc = "A69otor for power tools with a higher horsepower than usually expected. Significantly enhances productivity and lifespan, but69ore expensive to run and harder to control."
	icon_state = "motor"
	rarity_value = 20
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_PLASTEEL = 4)

/obj/item/tool_upgrade/productivity/motor/New()
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
	I.re69uired_69ualities = list(69UALITY_SCREW_DRIVING, 69UALITY_DRILLING, 69UALITY_SAWING, 69UALITY_DIGGING, 69UALITY_EXCAVATION, 69UALITY_HAMMERING)
	I.prefix = "high-power"
	I.re69_fuel_cell = RE69_FUEL_OR_CELL

/obj/item/tool_upgrade/productivity/antistaining
	name = "anti-staining paint"
	desc = "Applying a thin coat of this paint on a tool prevents stains, dirt or dust to adhere to its surface. Everyone works better and faster with clean tools."
	icon_state = "antistaining"
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLASTIC = 2)

/obj/item/tool_upgrade/productivity/antistaining/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.30,
	UPGRADE_PRECISION = 5,
	UPGRADE_ITEMFLAGPLUS = NOBLOODY
	)
	I.prefix = "anti-stain coated"

/obj/item/tool_upgrade/productivity/booster
	name = "booster"
	desc = "When you do not care about energy comsumption and just want to get shit done 69uickly. This device shunts the power safeties of your tool whether it uses fuel or electricity."
	icon_state = "booster"
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLASTIC = 2,69ATERIAL_GOLD = 1)

/obj/item/tool_upgrade/productivity/booster/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.35,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_POWERCOST_MULT = 1.25,
	UPGRADE_FUELCOST_MULT = 1.25
	)
	I.prefix = "boosted"
	I.re69_fuel_cell = RE69_FUEL_OR_CELL

/obj/item/tool_upgrade/productivity/injector
	name = "plasma injector"
	desc = "If the words \"safety regulations\" do not69ean anything to you, you69ay consider installing this fine piece of technology on your tool. It injects small amounts of plasma in the fuel69ix before combustion to greatly increase its power output,69aking all kinds of tasks easier to perform."
	icon_state = "injector"
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLASTIC = 2,69ATERIAL_PLASMA = 2)

/obj/item/tool_upgrade/productivity/injector/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.75,
	UPGRADE_DEGRADATION_MULT = 1.3,
	UPGRADE_POWERCOST_MULT = 1.3,
	UPGRADE_FUELCOST_MULT = 1.3,
	UPGRADE_HEALTH_THRESHOLD = -10
	)
	I.prefix = "plasma-fueled"
	I.re69_fuel_cell = RE69_FUEL

// 	 REFINEMENT: INCREASES PRECISION
//------------------------------------------------
/obj/item/tool_upgrade/refinement
	bad_type = /obj/item/tool_upgrade/refinement

/obj/item/tool_upgrade/refinement/laserguide
	name = "Asters \"Guiding Light\" laser guide"
	desc = "A small69isible laser which can be strapped onto any tool, giving an accurate representation of its target. Helps improve precision."
	icon_state = "laser_guide"
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_URANIUM = 1)

/obj/item/tool_upgrade/refinement/laserguide/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 10)
	I.weapon_upgrades = list(
	GUN_UPGRADE_RECOIL = 0.9)
	I.prefix = "laser-guided"

//Fits onto generally small tools that re69uire precision, especially surgical tools
//Doesn't work onlarger things like crowbars and drills
/obj/item/tool_upgrade/refinement/stabilized_grip
	name = "gyrostabilized grip"
	desc = "A fancy69echanical grip that partially floats around a tool, absorbing tremors and shocks. Allows precise work with a shaky hand, or shooting69ore precisely with one hand if the gun isn't intended for one-handed use."
	icon_state = "stabilizing"
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE
	matter = list(MATERIAL_PLASTIC = 3)

/obj/item/tool_upgrade/refinement/stabilized_grip/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.weapon_upgrades = list(
		GUN_UPGRADE_PEN_MULT = 0.6,
		GUN_UPGRADE_ONEHANDPENALTY = 0.3
		)
	I.gun_loc_tag = GUN_GRIP
	I.re69_gun_tags = list(GUN_PROJECTILE, GUN_GRIP)

/obj/item/tool_upgrade/refinement/stabilized_grip/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 10,
	UPGRADE_HEALTH_THRESHOLD = 10)
	I.re69uired_69ualities = list(69UALITY_CUTTING,69UALITY_WIRE_CUTTING, 69UALITY_SCREW_DRIVING, 69UALITY_WELDING,69UALITY_PULSING, 69UALITY_CLAMPING, 69UALITY_CAUTERIZING, 69UALITY_BONE_SETTING, 69UALITY_LASER_CUTTING)
	I.prefix = "stabilized"

/obj/item/tool_upgrade/refinement/magbit
	name = "magnetic bit"
	desc = "Magnetises tools used for handling small objects, reducing instances of dropping screws and bolts."
	icon_state = "magnetic"
	rarity_value = 20
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTEEL = 2)

/obj/item/tool_upgrade/refinement/magbit/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 10
	)
	I.re69uired_69ualities = list(69UALITY_SCREW_DRIVING, 69UALITY_BOLT_TURNING, 69UALITY_CLAMPING, 69UALITY_BONE_SETTING)
	I.prefix = "magnetic"

/obj/item/tool_upgrade/refinement/ported_barrel
	name = "ported barrel"
	desc = "A barrel extension for a welding tool which helps69anage gas pressure and keep the torch steady."
	icon_state = "ported_barrel"
	rarity_value = 30
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTEEL = 2)

/obj/item/tool_upgrade/refinement/ported_barrel/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 12,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_BULK = 1,
	UPGRADE_HEALTH_THRESHOLD = 10
	)
	I.re69uired_69ualities = list(69UALITY_WELDING)
	I.prefix = "ported"

/obj/item/tool_upgrade/refinement/compensatedbarrel
	name = "gravity compensated barrel"
	desc = "A barrel extension for welding tools that integrates a69iniaturized gravity generator that help keep the torch steady by compensating the weight of the tool."
	icon_state = "compensatedbarrel"
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTEEL = 1,69ATERIAL_PLASTIC = 1,69ATERIAL_GOLD = 1)

/obj/item/tool_upgrade/refinement/compensatedbarrel/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 20,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_POWERCOST_MULT = 1.05,
	UPGRADE_FUELCOST_MULT = 1.05,
	UPGRADE_BULK = 1
	)
	I.re69uired_69ualities = list(69UALITY_WELDING)
	I.prefix = "gravity-compensated"
	I.re69_fuel_cell = RE69_FUEL_OR_CELL

/obj/item/tool_upgrade/refinement/vibcompensator
	name = "vibration compensator"
	desc = "A ground-breaking innovation that dampens the69ibration of a tool by emitting sound waves in a specific pattern. It does not69ake any sense but neither do you by installing that on your tool."
	icon_state = "vibcompensator"
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 1,69ATERIAL_GOLD = 1)

/obj/item/tool_upgrade/refinement/vibcompensator/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_PRECISION = 15,
	UPGRADE_HEALTH_THRESHOLD = 5,
	UPGRADE_ITEMFLAGPLUS = HONKING
	)
	I.re69uired_69ualities = list(69UALITY_CUTTING,69UALITY_WIRE_CUTTING, 69UALITY_SCREW_DRIVING, 69UALITY_WELDING,69UALITY_PULSING, 69UALITY_CLAMPING, 69UALITY_CAUTERIZING, 69UALITY_BONE_SETTING, 69UALITY_LASER_CUTTING)
	I.prefix = "vibration-compensated"

// 		AUGMENTS:69ISCELLANEOUS AND UTILITY
//------------------------------------------------

//Allows the tool to use a cell one size category larger than it currently uses. Small to69edium,69edium to large, etc
/obj/item/tool_upgrade/augment
	bad_type = /obj/item/tool_upgrade/augment

/obj/item/tool_upgrade/augment/cell_mount
	name = "heavy cell69ount"
	icon_state = "cell_mount"
	desc = "A bulky adapter which allows oversized power cells to be installed into small tools."
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_PLASTEEL = 2,69ATERIAL_PLASTIC = 1)
	rarity_value = 20

/obj/item/tool_upgrade/augment/cell_mount/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_BULK = 1,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_CELLPLUS = 1
	)
	I.prefix = "medium-cell"
	I.re69_fuel_cell = RE69_CELL

//Stores69oar fuel!
/obj/item/tool_upgrade/augment/fuel_tank
	name = "Expanded fuel tank"
	desc = "An auxiliary tank which stores 100 extra units of fuel at the cost of degradation."
	icon_state = "canister"
	matter = list(MATERIAL_PLASTEEL = 4,69ATERIAL_PLASTIC = 1)

/obj/item/tool_upgrade/augment/fuel_tank/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_BULK = 1,
	UPGRADE_DEGRADATION_MULT = 1.15,
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_MAXFUEL = 100)
	I.prefix = "expanded"
	I.re69_fuel_cell = RE69_FUEL

//OneStar fuel69od
/obj/item/tool_upgrade/augment/holding_tank
	name = "Expanded fuel tank of holding"
	desc = "Rare relic of OneStar uses the bluetech space to store additional 600 units of fuel at the cost of degradation."
	icon_state = "canister_holding"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_PLASTEEL = 4,69ATERIAL_PLATINUM = 4)
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE_OS
	spawn_blacklisted = TRUE

/obj/item/tool_upgrade/augment/holding_tank/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_BULK = 1,
	UPGRADE_DEGRADATION_MULT = 1.30,
	UPGRADE_HEALTH_THRESHOLD = -20,
	UPGRADE_MAXFUEL = 600
	)
	I.prefix = "holding"
	I.re69_fuel_cell = RE69_FUEL
	bluespace_entropy(5, get_turf(src))

//Penalises the tool, but unlocks several69ore augment slots.
/obj/item/tool_upgrade/augment/expansion
	name = "expansion port"
	icon_state = "expand"
	desc = "A bulky adapter which allows69ore69odifications to be attached to the tool. A bit fragile but you can compensate."
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTEEL = 3,69ATERIAL_PLASTIC = 1)
	rarity_value = 60
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE

/obj/item/tool_upgrade/augment/expansion/New()
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

/obj/item/tool_upgrade/augment/spikes
	name = "spikes"
	icon_state = "spike"
	desc = "An array of sharp bits of plasteel, seemingly adapted for easy affixing to a tool. Would69ake it into a better weapon, but won't do69uch for productivity."
	matter = list(MATERIAL_PLASTEEL = 3,69ATERIAL_STEEL = 2)

/obj/item/tool_upgrade/augment/spikes/New()
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

/obj/item/tool_upgrade/augment/sanctifier
	name = "NT 'Sanctifier' tool blessing"
	icon_state = "sanctifier"
	desc = "This odd piece of e69uipment can be applied to any tool or69elee weapon, causing the object to deal extra burn damage to69utants and carrions."
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_BIOMATTER = 3,69ATERIAL_STEEL = 2)

/obj/item/tool_upgrade/augment/sanctifier/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_SANCTIFY = TRUE
	)
	I.prefix = "sanctified"

/obj/item/tool_upgrade/augment/hammer_addon
	name = "Flat surface"
	icon_state = "hammer_addon"
	desc = "An attachment that fits on almost everything, that gives a simple flat surface to employ the tool for hammering."
	matter = list(MATERIAL_PLASTEEL = 3,69ATERIAL_STEEL = 2)
	rarity_value = 20

/obj/item/tool_upgrade/augment/hammer_addon/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = -0.1,
	UPGRADE_HEALTH_THRESHOLD = 5,
	tool_69ualities = list(69UALITY_HAMMERING = 10)
	)
	I.prefix = "flattened"

//Vastly reduces tool sounds, for stealthy hacking
/obj/item/tool_upgrade/augment/dampener
	name = "aural dampener"
	desc = "This aural dampener is a cutting edge tool attachment which69ostly nullifies sound waves within a tiny radius. It69inimises the noise created during use, perfect for stealth operations."
	icon_state = "dampener"
	matter = list(MATERIAL_PLASTIC = 1,69ATERIAL_PLASTEEL = 1,69ATERIAL_PLATINUM = 1)
	rarity_value = 30
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE

/obj/item/tool_upgrade/augment/dampener/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_COLOR = "#AAAAAA",
	UPGRADE_HEALTH_THRESHOLD = -10,
	UPGRADE_ITEMFLAGPLUS = SILENT
	)
	I.prefix = "silenced"

/obj/item/tool_upgrade/augment/ai_tool
	name = "Nanointegrated AI"
	desc = "A forgotten One Star tech. Due to its uni69ue installation69ethod of \"slapping it hard enough onto anything should do the trick\", it is highly sought after. \
			A powerful AI will integrate itself into this tool with the aid of nanotechnology, and improve it in every way possible."
	icon_state = "ai_tool"
	matter = list(MATERIAL_PLASTIC = 1,69ATERIAL_PLASTEEL = 1,69ATERIAL_PLATINUM = 1)
	spawn_blacklisted = TRUE
	rarity_value = 50
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE_OS

/obj/item/tool_upgrade/augment/ai_tool/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_POWERCOST_MULT = 1.20,
	UPGRADE_PRECISION = 14,
	UPGRADE_WORKSPEED = 14,
	UPGRADE_HEALTH_THRESHOLD = -10,
	)
	I.prefix = "intelligent"
	I.re69_fuel_cell = RE69_CELL
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

/obj/item/tool_upgrade/augment/repair_nano
	name = "repair nano"
	desc = "Very rare tool69od from OneStar powered by their nanomachines. It repairs the tool while in use and69akes it near unbreakable."
	icon_state = "repair_nano"
	matter = list(MATERIAL_PLASTIC = 1,69ATERIAL_PLASTEEL = 1,69ATERIAL_PLATINUM = 1)
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE_OS
	spawn_blacklisted = TRUE

/obj/item/tool_upgrade/augment/repair_nano/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = 0.01,
	UPGRADE_HEALTH_THRESHOLD = 10
	)
	I.prefix = "self-healing"

/obj/item/tool_upgrade/augment/hydraulic
	name = "hydraulic circuits"
	desc = "A complex set of hydraulic circuits that can be installed on a tool to greatly improve its functions. It's loud as hell though so do not plan on being stealthy."
	icon_state = "hydraulic"
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLASTEEL = 3,69ATERIAL_PLASTIC = 3)
	spawn_blacklisted = TRUE

/obj/item/tool_upgrade/augment/hydraulic/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 1,
	UPGRADE_PRECISION = 10,
	UPGRADE_ITEMFLAGPLUS = LOUD
	)
	I.prefix = "hydraulic"

// Randomizes a bunch of weapon stats on application - stats are set on creation of the item to prevent people from re-rolling until they get what they want
/obj/item/tool_upgrade/augment/randomizer
	name = "BSL \"Randomizer\" tool polish"
	desc = "This unidentified tar-like li69uid warps and bends reality around it. Applying it to a tool69ay have unexpected results."
	icon_state = "randomizer"
	matter = list(MATERIAL_PLASMA = 4,69ATERIAL_URANIUM = 4)
	rarity_value = 80
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE_RARE

/obj/item/tool_upgrade/augment/randomizer/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_DEGRADATION_MULT = rand(-1,10),
	UPGRADE_HEALTH_THRESHOLD = rand(-10,10),
	UPGRADE_WORKSPEED = rand(-1,3),
	UPGRADE_PRECISION = rand(-20,20),
	UPGRADE_FORCE_MOD = rand(-5,5),
	UPGRADE_BULK = rand(-1,2),
	UPGRADE_COLOR = "#3366ff"
	)
	I.prefix = "theoretical"

/obj/item/tool_upgrade/artwork_tool_mod
	name = "Weird Revolver"
	desc = "This is an artistically-made tool69od."
	icon_state = "artmod_1"
	spawn_fre69uency = 0
	price_tag = 200

/obj/item/tool_upgrade/artwork_tool_mod/Initialize(mapload, prob_rare = 33)
	. = ..()
	name = get_weapon_name(capitalize = TRUE)
	icon_state = "artmod_69rand(1,16)69"
	var/sanity_value = 0.2 + pick(0,0.1,0.2)
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
	var/obj/randomcatcher/CATCH = new(src)
	var/obj/item/tool_upgrade/spawn_type = pickweight(list(/obj/spawner/tool_upgrade =69ax(100-prob_rare,0), /obj/spawner/tool_upgrade/rare = prob_rare), 0)
	spawn_type = CATCH.get_item(spawn_type)
	spawn_type.TransferComponents(src)
	GET_COMPONENT(tool_comp, /datum/component/item_upgrade)
	for(var/upgrade in (tool_comp.tool_upgrades - GLOB.tool_aspects_blacklist))
		if(isnum(tool_comp.tool_upgrades69upgrade69))
			tool_comp.tool_upgrades69upgrade69 = tool_comp.tool_upgrades69upgrade69 * rand(5,15)/10
	tool_comp.tool_upgrades69UPGRADE_BULK69 = rand(-1,2)
	69DEL_NULL(spawn_type)
	69DEL_NULL(CATCH)
	price_tag += rand(0, 1000)

/obj/item/tool_upgrade/artwork_tool_mod/get_item_cost(export)
	. = ..()
	GET_COMPONENT(comp_sanity, /datum/component/atom_sanity)
	. += comp_sanity.affect * 100

/obj/item/tool_upgrade/pai
	name = "Integrated P-AI"
	desc = "A P-AI integrated within the architecture of the tool, helping the user in utilizing it."
	spawn_blacklisted = TRUE
	price_tag = 200

/obj/item/tool_upgrade/pai/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.3,
	UPGRADE_PRECISION = 10
	)
	I.destroy_on_removal = TRUE
	I.prefix = "assisted"

/obj/item/tool_upgrade/flow_mechanism
	name = "Flowing69etal system"
	desc = "This tool69akes use of li69uid69etal within its architecture."
	spawn_blacklisted = TRUE
	price_tag = 300

/obj/item/tool_upgrade/flow_mechanism/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.2,
		UPGRADE_FORCE_MULT = 1.3,
		UPGRADE_MAXUPGRADES = 2
	)
	I.destroy_on_removal = TRUE
	I.prefix = "flowing"

/obj/item/tool_upgrade/magni_grip
	name = "Waved69agnetic grip"
	desc = "A wavy69etallic sheet that attaches to69ost gloves automatically."
	spawn_blacklisted = TRUE
	price_tag = 200

/obj/item/tool_upgrade/magni_grip/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
	UPGRADE_WORKSPEED = 0.2,
	UPGRADE_PRECISION = 15
	)
	I.destroy_on_removal = TRUE
	I.prefix = "magnetized"

/obj/item/tool_upgrade/resonator
	name = "Resonator sink"
	desc = "A special69odule which prevents the tool from resonating."
	spawn_blacklisted = TRUE
	price_tag = 400

/obj/item/tool_upgrade/resonator/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_WORKSPEED = 0.1,
		UPGRADE_ITEMFLAGPLUS = SILENT
	)
	I.destroy_on_removal = TRUE
	I.prefix = "still"

/obj/item/tool_upgrade/plasma_coating
	name = "Plasma coating"
	desc = "This tool is coated with plasma, granting it69ore durability."
	spawn_blacklisted = TRUE
	price_tag = 600

/obj/item/tool_upgrade/plasma_coating/New()
	..()
	var/datum/component/item_upgrade/I = AddComponent(/datum/component/item_upgrade)
	I.tool_upgrades = list(
		UPGRADE_DEGRADATION_MULT = 0.1,
		UPGRADE_MAXUPGRADES = 3
	)
	I.destroy_on_removal = TRUE
	I.prefix = "plasma coated"


#define GREAT_TOOLMODS list(/obj/item/tool_upgrade/pai, /obj/item/tool_upgrade/flow_mechanism, /obj/item/tool_upgrade/magni_grip, \
	/obj/item/tool_upgrade/resonator, /obj/item/tool_upgrade/plasma_coating)
