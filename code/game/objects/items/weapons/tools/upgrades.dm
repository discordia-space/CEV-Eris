/*
	A tool upgrade is a little attachment for a tool that improves it in some way
	Tool upgrades are generally permanant

	Some upgrades have multiple bonuses. Some have drawbacks in addition to boosts
*/

/*/client/verb/debugupgrades()
	for (var/t in subtypesof(/obj/item/weapon/tool_upgrade))
		new t(usr.loc)
*/

/obj/item/weapon/tool_upgrade
	name = "tool upgrade"
	icon = 'icons/obj/tool_upgrades.dmi'
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL

	var/prefix = "upgraded" //Added to the tool's name

	//The upgrade can be applied to a tool that has any of these qualities
	var/list/required_qualities = list()

	//If true, can only be applied to tools that use fuel
	var/req_fuel = FALSE

	//If true, can only be applied to tools that use a power cell
	var/req_cell = FALSE

	var/obj/item/weapon/tool/holder = null //The tool we're installed into
	matter = list(MATERIAL_STEEL = 1)

	//Actual effects of upgrades
	var/precision = 0
	var/workspeed = 0
	var/degradation_mult = 1
	var/force_mult = 1	//Multiplies weapon damage
	var/force_mod = 0	//Adds a flat value to weapon damage
	var/powercost_mult = 1
	var/fuelcost_mult = 1
	var/bulk_mod = 0

/obj/item/weapon/tool_upgrade/examine(var/mob/user)
	.=..()
	if (precision > 0)
		user << SPAN_NOTICE("Enhances precision by [precision]")
	else if (precision < 0)
		user << SPAN_WARNING("Reduces precision by [abs(precision)]")
	if (workspeed)
		user << SPAN_NOTICE("Enhances workspeed by [workspeed*100]%")

	if (degradation_mult < 1)
		user << SPAN_NOTICE("Reduces tool degradation by [(1-degradation_mult)*100]%")
	else if	(degradation_mult > 1)
		user << SPAN_WARNING("Increases tool degradation by [(degradation_mult-1)*100]%")

	if (force_mult != 1)
		user << SPAN_NOTICE("Increases tool damage by [(force_mult-1)*100]%")
	if (force_mod)
		user << SPAN_NOTICE("Increases tool damage by [force_mod]")
	if (powercost_mult != 1)
		user << SPAN_WARNING("Modifies power usage by [(powercost_mult-1)*100]%")
	if (fuelcost_mult != 1)
		user << SPAN_WARNING("Modifies fuel usage by [(fuelcost_mult-1)*100]%")
	if (bulk_mod)
		user << SPAN_WARNING("Increases tool size by [bulk_mod]")

	if (required_qualities.len)
		user << SPAN_WARNING("Requires a tool with one of the following qualities:")
		user << english_list(required_qualities, and_text = " or ")

/******************************
	UPGRADE TYPES
******************************/
// 	 REINFORCEMENT: REDUCES TOOL DEGRADATION
//------------------------------------------------

//This can be attached to basically any long tool
//This includes most mechanical ones
/obj/item/weapon/tool_upgrade/reinforcement/stick
	name = "brace bar"
	desc = "A sturdy pole made of fiber tape and metal rods. Can be used to reinforce the shaft of many tools"
	icon_state = "brace_bar"
	required_qualities = list(QUALITY_BOLT_TURNING,QUALITY_PRYING, QUALITY_SAWING,QUALITY_SHOVELING,QUALITY_DIGGING,QUALITY_EXCAVATION)
	prefix = "braced"
	degradation_mult = 0.65



//Heatsink can be attached to any tool that uses fuel or power
/obj/item/weapon/tool_upgrade/reinforcement/heatsink
	name = "heatsink"
	desc = "An array of aluminium fins which dissipates heat, reducing damage and extending the lifespan of power tools."
	icon_state = "heatsink"
	prefix = "heatsunk"
	degradation_mult = 0.65

/obj/item/weapon/tool_upgrade/reinforcement/heatsink/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	.=..()
	if (.)
		if (T.use_fuel_cost || T.use_power_cost)
			return TRUE
		return FALSE

/obj/item/weapon/tool_upgrade/reinforcement/plating
	name = "metal plating"
	desc = "A sturdy bit of metal that can be bolted onto any tool to protect it. Tough, but bulky"
	icon_state = "plate"
	prefix = "reinforced"
	degradation_mult = 0.55
	precision = -5
	bulk_mod = 1


/obj/item/weapon/tool_upgrade/reinforcement/guard
	name = "metal guard"
	desc = "A bent piece of metal that wraps around sensitive parts of a tool, protecting it from impacts, debris, and stray fingers."
	icon_state = "guard"
	required_qualities = list(QUALITY_CUTTING,QUALITY_DRILLING, QUALITY_SAWING, QUALITY_DIGGING, QUALITY_EXCAVATION, QUALITY_WELDING)
	prefix = "shielded"
	degradation_mult = 0.75
	precision = 5


// 	 PRODUCTIVITY: INCREASES WORKSPEED
//------------------------------------------------
/obj/item/weapon/tool_upgrade/productivity/ergonomic_grip
	name = "ergonomic grip"
	desc = "A replacement grip for a tool which allows it to be more precisely controlled with one hand"
	icon_state = "ergonomic"
	prefix = "ergonomic"
	workspeed = 0.15


/obj/item/weapon/tool_upgrade/productivity/ratchet
	name = "ratcheting mechanism"
	desc = "A mechanical upgrade for wrenches and screwdrivers which allows the tool to only turn in one direction"
	icon_state = "ratchet"
	required_qualities = list(QUALITY_BOLT_TURNING,QUALITY_SCREW_DRIVING)
	prefix = "ratcheting"
	workspeed = 0.25

/obj/item/weapon/tool_upgrade/productivity/red_paint
	name = "red paint"
	desc = "Do red tools really work faster, or is the effect purely psychological"
	icon_state = "paint_red"
	prefix = "red"
	workspeed = 0.20
	precision = -10

/obj/item/weapon/tool_upgrade/productivity/red_paint/apply_values()
	if (..())
		holder.color = "#FF4444"

/obj/item/weapon/tool_upgrade/productivity/whetstone
	name = "sharpening block"
	desc = "A rough single-use block to sharpen a blade. The honed edge cuts smoothly"
	icon_state = "whetstone"
	required_qualities = list(QUALITY_CUTTING,QUALITY_SAWING, QUALITY_WIRE_CUTTING)
	prefix = "sharpened"
	workspeed = 0.15
	precision = 5
	force_mult = 1.15


/obj/item/weapon/tool_upgrade/productivity/diamond_blade
	name = "Asters \"Gleaming Edge\": Diamond blade"
	desc = "An adaptable industrial grade cutting disc, with diamond dust worked into the metal. Exceptionally durable"
	icon_state = "diamond_blade"
	required_qualities = list(QUALITY_CUTTING,QUALITY_SAWING, QUALITY_WIRE_CUTTING, QUALITY_PRYING)
	prefix = "diamond-edged"
	workspeed = 0.25
	degradation_mult = 0.85
	matter = list(MATERIAL_STEEL = 1, MATERIAL_DIAMOND = 1)


/obj/item/weapon/tool_upgrade/productivity/oxyjet
	name = "oxyjet canister"
	desc = "A canister of pure, compressed oxygen with adapters for mounting onto a welding tool. Used alongside fuel, it allows for higher burn temperatures"
	icon_state = "oxyjet"
	required_qualities = list(QUALITY_WELDING)
	prefix = "oxyjet"
	workspeed = 0.20
	force_mult = 1.15


//Enhances power tools majorly, but also increases costs
/obj/item/weapon/tool_upgrade/productivity/motor
	name = "high power motor"
	desc = "A motor for power tools with a higher horsepower than usually expected. Significantly enhances productivity and lifespan, but more expensive to run and harder to control"
	icon_state = "motor"
	required_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_DRILLING, QUALITY_SAWING, QUALITY_DIGGING, QUALITY_EXCAVATION)
	prefix = "high-power"
	workspeed = 0.50
	degradation_mult = 0.75
	force_mult = 1.15

	powercost_mult = 1.5
	fuelcost_mult = 1.5
	precision = -10

/obj/item/weapon/tool_upgrade/productivity/motor/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	.=..()
	if (.)
		if (T.use_fuel_cost || T.use_power_cost)
			return TRUE
		return FALSE






// 	 REFINEMENT: INCREASES PRECISION
//------------------------------------------------
/obj/item/weapon/tool_upgrade/refinement/laserguide
	name = "Asters \"Guiding Light\" laser guide"
	desc = "A small visible laser which can be strapped onto any tool, giving an accurate representation of its target. Helps improve precision"
	icon_state = "laser_guide"
	prefix = "laser-guided"
	precision = 5


//Fits onto generally small tools that require precision, especially surgical tools
//Doesn't work onlarger things like crowbars and drills
/obj/item/weapon/tool_upgrade/refinement/stabilized_grip
	name = "gyrostabilized grip"
	desc = "A fancy mechanical grip that partially floats around a tool, absorbing tremors and shocks. Allows precise work with a shaky hand"
	icon_state = "stabilizing"
	required_qualities = list(QUALITY_CUTTING,QUALITY_WIRE_CUTTING, QUALITY_SCREW_DRIVING, QUALITY_WELDING,
	QUALITY_PULSING, QUALITY_CLAMPING, QUALITY_CAUTERIZING, QUALITY_BONE_SETTING, QUALITY_LASER_CUTTING)
	prefix = "stabilized"
	precision = 10

/obj/item/weapon/tool_upgrade/refinement/magbit
	name = "magnetic bit"
	desc = "Magnetises tools used for handling small objects, reducing instances of dropping screws and bolts."
	icon_state = "magnetic"
	required_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_BOLT_TURNING, QUALITY_CLAMPING, QUALITY_BONE_SETTING)
	prefix = "magnetic"
	precision = 10


/obj/item/weapon/tool_upgrade/refinement/ported_barrel
	name = "ported barrel"
	desc = "A barrel extension for a welding tool which helps manage gas pressure and keep the torch steady."
	icon_state = "ported_barrel"
	required_qualities = list(QUALITY_WELDING)
	prefix = "ported"
	precision = 12
	bulk_mod = 1









// 		AUGMENTS: MISCELLANEOUS AND UTILITY
//------------------------------------------------

//Allows the tool to use a cell one size category larger than it currently uses. Small to medium, medium to large, etc
/obj/item/weapon/tool_upgrade/augment/cell_mount
	name = "heavy cell mount"
	icon_state = "cell_mount"
	desc = "A bulky adapter which allows oversized power cells to be installed into small tools"
	req_cell = TRUE
	prefix = "medium-cell"
	bulk_mod = 1

/obj/item/weapon/tool_upgrade/augment/cell_mount/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	.=..()
	if (.)
		if (T.suitable_cell == /obj/item/weapon/cell/medium || T.suitable_cell == /obj/item/weapon/cell/small)
			if (T.cell)
				user << SPAN_DANGER("You'll need to remove the power cell before installing this upgrade. It won't be compatible afterwards")
				return FALSE
			return TRUE
		else
			return FALSE

/obj/item/weapon/tool_upgrade/augment/cell_mount/apply_values()
	if (!holder)
		return
	if (holder.suitable_cell == /obj/item/weapon/cell/medium)
		holder.suitable_cell = /obj/item/weapon/cell/large
		prefix = "large-cell"
	else if (holder.suitable_cell == /obj/item/weapon/cell/small)
		holder.suitable_cell = /obj/item/weapon/cell/medium
		prefix = "medium-cell"
	..()




//Stores moar fuel!
/obj/item/weapon/tool_upgrade/augment/fuel_tank
	name = "Expanded fuel tank"
	desc = "An auxiliary tank which stores 30 extra units of fuel"
	icon_state = "canister"
	req_fuel = TRUE
	prefix = "expanded"
	bulk_mod = 1

/obj/item/weapon/tool_upgrade/augment/fuel_tank/apply_values()
	if (..())
		holder.max_fuel += 30


//Penalises the tool, but unlocks several more augment slots.
/obj/item/weapon/tool_upgrade/augment/expansion
	name = "expansion port"
	icon_state = "expand"
	desc = "A bulky adapter which more modifications to be attached to the tool.  A bit fragile but you can compensate"
	prefix = "custom"
	bulk_mod = 2
	degradation_mult = 1.3
	precision = -10

/obj/item/weapon/tool_upgrade/augment/expansion/apply_values()
	if (..())
		holder.max_upgrades += 3


/obj/item/weapon/tool_upgrade/augment/spikes
	name = "spikes"
	icon_state = "spike"
	desc = "An array of sharp bits of metal, seemingly adapted for easy affixing to a tool. Would make it into a better weapon, but won't do much for productivity."
	prefix = "spiked"
	force_mod = 4
	precision = -10


/obj/item/weapon/tool_upgrade/augment/spikes/apply_values()
	if (..())
		holder.sharp = TRUE

//Vastly reduces tool sounds, for stealthy hacking
/obj/item/weapon/tool_upgrade/augment/dampener
	name = "aural dampener"
	desc = "This aural dampener is a cutting edge tool attachment which mostly nullifies sound waves within a tiny radius. It minimises the noise created during use, perfect for stealth operations"
	icon_state = "dampener"
	prefix = "silenced"


/obj/item/weapon/tool_upgrade/augment/dampener/apply_values()
	if (..())
		holder.silenced = TRUE



/******************************
	CORE CODE
******************************/


/obj/item/weapon/tool_upgrade/afterattack(obj/O, mob/user, proximity)

	if(!proximity) return
	try_apply(O, user)

/obj/item/weapon/tool_upgrade/proc/try_apply(var/obj/item/weapon/tool/O, var/mob/user)
	if (!can_apply(O, user))
		return

	apply(O, user)


/obj/item/weapon/tool_upgrade/proc/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	if (!istool(T))
		user << SPAN_WARNING("This can only be applied to a tool!")
		return

	if (T.upgrades.len >= T.max_upgrades)
		user << SPAN_WARNING("This tool can't fit anymore modifications!")
		return

	if (required_qualities.len)
		var/qmatch = FALSE
		for (var/q in required_qualities)
			if (T.ever_has_quality(q))
				qmatch = TRUE
				break

		if (!qmatch)
			user << SPAN_WARNING("This tool lacks the required qualities!")
			return

	if (req_fuel && !T.use_fuel_cost)
		user << SPAN_WARNING("This tool doesn't use fuel!")
		return

	if (req_cell && !T.use_power_cost)
		user << SPAN_WARNING("This tool doesn't use power!")
		return

	//No using multiples of the same upgrade
	for (var/obj/item/weapon/tool_upgrade/U in T.upgrades)
		if (U.type == type)
			user << SPAN_WARNING("An upgrade of this type is already installed!")
			return

	return TRUE


//Applying an upgrade to a tool is a mildly difficult process
/obj/item/weapon/tool_upgrade/proc/apply(var/obj/item/weapon/tool/T, var/mob/user)

	if (user)
		user.visible_message(SPAN_NOTICE("[user] starts applying the [src] to [T]"), SPAN_NOTICE("You start applying the [src] to [T]"))
		if (!use_tool(user = user, target =  T, base_time = WORKTIME_NORMAL, required_quality = null, fail_chance = FAILCHANCE_EASY+T.unreliability, required_stat = STAT_MEC, forced_sound = WORKSOUND_WRENCHING))
			return
		user << SPAN_NOTICE("You have successfully installed [src] in [T]")
		user.drop_from_inventory(src)
	//If we get here, we succeeded in the applying
	holder = T
	forceMove(T)
	T.upgrades.Add(src)
	T.refresh_upgrades()


//This does the actual numerical changes.
//The tool itself asks us to call this, and it resets itself before doing so
/obj/item/weapon/tool_upgrade/proc/apply_values()
	if (!holder)
		return

	holder.precision += precision
	holder.workspeed += workspeed
	holder.degradation *= degradation_mult
	holder.force *= force_mult
	holder.switched_on_force *= force_mult
	holder.force += force_mod
	holder.switched_on_force += force_mod
	holder.use_fuel_cost *= fuelcost_mult
	holder.use_power_cost *= powercost_mult
	holder.extra_bulk += bulk_mod
	holder.prefixes |= prefix
	return TRUE