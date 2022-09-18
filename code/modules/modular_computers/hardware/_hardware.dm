/obj/item/computer_hardware
	name = "Hardware"
	desc = "Unknown Hardware."
	icon = 'icons/obj/modular_components.dmi'
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_SILVER = 1)
	price_tag = 50
	spawn_tags = SPAWN_TAG_COMPUTER_HARDWERE
	bad_type = /obj/item/computer_hardware
	rarity_value = 25
	var/obj/item/modular_computer/attached_computer
	var/power_usage = 0 			// If the hardware uses extra power, change this.
	var/enabled = TRUE				// If the hardware is turned off set this to 0.
	var/critical = FALSE			// Prevent disabling for important component, like the HDD.
	var/hardware_size = MODCOMP_SIZE_SMALL			// Limits which devices can contain this component.
	var/usage_flags = PROGRAM_ALL
	var/component_flags = list(MODCOMP_PROCESSOR = 1)

/obj/item/computer_hardware/attackby(obj/item/W, mob/living/user)
	// Multitool. Runs diagnostics
	if(QUALITY_PULSING in W.tool_qualities)
		if(W.use_tool(user, src, WORKTIME_LONG, QUALITY_PULSING, FAILCHANCE_HARD, required_stat = STAT_COG))
			to_chat(user, "***** DIAGNOSTICS REPORT *****")
			diagnostics(user)
			to_chat(user, "******************************")
			return 1
	// Nanopaste. Repair all damage if present for a single unit.
	var/obj/item/stack/S = W
	if(istype(S, /obj/item/stack/nanopaste))
		if(!damage)
			to_chat(user, "\The [src] doesn't seem to require repairs.")
			return 1
		if(S.use(1))
			to_chat(user, "You apply a bit of \the [W] to \the [src]. It immediately repairs all damage.")
			damage = 0
		return 1
	// Cable coil. Works as repair method, but will probably require multiple applications and more cable.
	if(isCoil(S))
		if(!damage)
			to_chat(user, "\The [src] doesn't seem to require repairs.")
			return 1
		if(S.use(1))
			to_chat(user, "You patch up \the [src] with a bit of \the [W].")
			take_damage(-10)
		return 1
	return ..()


// Called on multitool click, prints diagnostic information to the user.
/obj/item/computer_hardware/proc/diagnostics(mob/user)
	to_chat(user, "Hardware Integrity Test... (Corruption: [damage]/[max_damage]) [damage > damage_failure ? "FAIL" : damage > damage_malfunction ? "WARN" : "PASS"]")

/obj/item/computer_hardware/Initialize()
	. = ..()
	w_class = hardware_size
	if(istype(loc, /obj/item/modular_computer))
		holder2 = loc

/obj/item/computer_hardware/Destroy()
	if(holder2)
		holder2.uninstall_component(src)
	return ..()

// Handles damage checks
/obj/item/computer_hardware/proc/check_functionality()
	// Turned off
	if(!enabled)
		return FALSE
	// Too damaged to work at all.
	if(damage >= damage_failure)
		return FALSE
	// Still working. Well, sometimes...
	if(damage >= damage_malfunction)
		if(prob(malfunction_probability))
			return FALSE
	// Good to go.
	return TRUE

/obj/item/computer_hardware/examine(mob/user)
	. = ..()
	if(damage > damage_failure)
		to_chat(user, SPAN_WARNING("It seems to be severely damaged!"))
	else if(damage > damage_malfunction)
		to_chat(user, SPAN_WARNING("It seems to be damaged!"))
	else if(damage)
		to_chat(user, SPAN_NOTICE("It seems to be slightly damaged."))

// Damages the component. Contains necessary checks. Negative damage "heals" the component.
/obj/item/computer_hardware/proc/take_damage(amount)
	damage += round(amount) 					// We want nice rounded numbers here.
	damage = between(0, damage, max_damage)		// Clamp the value.

//Called when the component turned on
/obj/item/computer_hardware/proc/enabled()

//Called when the component turned off
/obj/item/computer_hardware/proc/disabled()

//Called when the component is installed
/obj/item/computer_hardware/proc/install(obj/item/modular_computer/new_home)
	attached_computer = new_home

//Called when the component is uninstalled
/obj/item/computer_hardware/proc/uninstall(mob/living/carbon/human/uninstaller)
	if(uninstaller)
		to_chat(uninstaller, SPAN_NOTICE("You remove \the [H] from \the [src]."))
	if(!istype(uninstaller))
		forceMove(get_turf(attached_computer))
		attached_computer = null
		return TRUE
	if(!uninstaller.l_hand)
		uninstaller.put_in_l_hand(src)
	else if(!uninstaller.r_hand)
		uninstaller.put_in_r_hand(src)
	else
		forceMove(get_turf(attached_computer))
	attached_computer = null
	return TRUE
