/*
 * Contains
 * /obj/item/rig_module/grenade_launcher
 * /obj/item/rig_module/mounted
 * /obj/item/rig_module/mounted/taser
 * /obj/item/rig_module/shield
 * /obj/item/rig_module/fabricator
 * /obj/item/rig_module/device/flash
 */

/obj/item/rig_module/device/flash
	name = "mounted flash"
	desc = "You are the law."
	icon_state = "flash"
	use_power_cost = 2
	interface_name = "Mounted flash"
	interface_desc = "Stuns your target by blinding them with a bright light."
	device_type = /obj/item/device/flash
	spawn_tags = SPAWN_TAG_RIG_MODULE_COMMON

/obj/item/rig_module/grenade_launcher
	name = "mounted grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser."
	selectable = 1
	icon_state = "grenadelauncher"

	interface_name = "Integrated grenade launcher"
	interface_desc = "Discharges loaded grenades against the wearer's location."
	rarity_value = 20

	var/fire_force = 30
	var/fire_distance = 10

	charges = list(
		list("flashbang",   "flashbang",   /obj/item/grenade/flashbang,  3),
		list("smoke bomb",  "smoke bomb",  /obj/item/grenade/smokebomb,  3),
		list("EMP grenade", "EMP grenade", /obj/item/grenade/empgrenade, 3),
		)

/obj/item/rig_module/grenade_launcher/accepts_item(var/obj/item/input_device, var/mob/living/user)

	if(!istype(input_device) || !istype(user))
		return 0

	var/datum/rig_charge/accepted_item
	for(var/charge in charges)
		var/datum/rig_charge/charge_datum = charges[charge]
		if(input_device.type == charge_datum.product_type)
			accepted_item = charge_datum
			break

	if(!accepted_item)
		return 0

	if(accepted_item.charges >= 5)
		to_chat(user, SPAN_DANGER("Another grenade of that type will not fit into the module."))
		return 0

	to_chat(user, "<font color='blue'><b>You slot \the [input_device] into the suit module.</b></font>")
	user.drop_from_inventory(input_device)
	qdel(input_device)
	accepted_item.charges++
	return 1

/obj/item/rig_module/grenade_launcher/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, SPAN_DANGER("You have not selected a grenade type."))
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	if(charge.charges <= 0)
		to_chat(H, SPAN_DANGER("Insufficient grenades!"))
		return 0

	charge.charges--
	var/obj/item/grenade/new_grenade = new charge.product_type(get_turf(H))
	H.visible_message(SPAN_DANGER("[H] launches \a [new_grenade]!"))
	new_grenade.activate(H)
	new_grenade.throw_at(target,fire_force,fire_distance)

/obj/item/rig_module/mounted
	name = "mounted laser cannon"
	desc = "A shoulder-mounted battery-powered laser cannon mount."
	selectable = 1
	usable = 1
	module_cooldown = 1
	
	icon_state = "lcannon"

	engage_string = "Configure"

	interface_name = "Mounted laser cannon"
	interface_desc = "A shoulder-mounted cell-powered laser cannon."
	rarity_value = 100
	var/gun_type = /obj/item/gun/energy/lasercannon/mounted
	var/obj/item/gun/gun

/obj/item/rig_module/mounted/New()
	..()
	gun = new gun_type(src)

/obj/item/rig_module/mounted/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		gun.attack_self(holder.wearer)
		return

	gun.Fire(target,holder.wearer)
	return 1

/obj/item/rig_module/mounted/egun
	name = "mounted energy gun"
	desc = "A forearm-mounted energy projector."
	icon_state = "egun"



	interface_name = "Mounted energy gun"
	interface_desc = "A forearm-mounted suit-powered energy gun."

	gun_type = /obj/item/gun/energy/gun/mounted
	rarity_value = 50

/obj/item/rig_module/mounted/taser

	name = "mounted taser"
	desc = "A palm-mounted nonlethal energy projector."
	icon_state = "taser"


	usable = 0

	suit_overlay_active = "mounted-taser"
	suit_overlay_inactive = "mounted-taser"

	interface_name = "Mounted taser"
	interface_desc = "A shoulder-mounted cell-powered taser."

	gun_type = /obj/item/gun/energy/taser/mounted
	spawn_tags = SPAWN_TAG_RIG_MODULE_COMMON

/obj/item/rig_module/held
	spawn_blacklisted = TRUE

/obj/item/rig_module/held/energy_blade
	name = "energy blade projector"
	desc = "A powerful cutting beam projector."
	icon_state = "eblade"

	activate_string = "Project Blade"
	deactivate_string = "Cancel Blade"

	interface_name = "Spider fang blade"
	interface_desc = "A lethal energy projector that can shape a blade projected from the hand of the wearer."

	usable = 0
	selectable = 1
	toggleable = 1
	use_power_cost = 50
	active_power_cost = 10
	passive_power_cost = 0
	rarity_value = 100
	spawn_blacklisted = FALSE

/obj/item/rig_module/held/energy_blade/Process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/melee/energy/blade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/held/energy_blade/activate()

	..()

	var/mob/living/M = holder.wearer

	if(M.l_hand && M.r_hand)
		to_chat(M, SPAN_DANGER("Your hands are full."))
		deactivate()
		return

	var/obj/item/melee/energy/blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

/obj/item/rig_module/held/energy_blade/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/melee/energy/blade/blade in M.contents)
		M.drop_from_inventory(blade)
		qdel(blade)

/obj/item/rig_module/held/shield
	name = "rig shield module"
	desc = "A heavy deployable shield installable on a hardsuit."

	activate_string = "Deploy Shield"
	deactivate_string = "Retract Shield"

	interface_name = "Frozen star shield"
	interface_desc = "A reinforced ballistic shield for use against high-velocity projectiles and energy weapons."

	usable = 0
	selectable = 1
	toggleable = 1
	use_power_cost = 0
	active_power_cost = 0
	passive_power_cost = 0
	rarity_value = 50
	spawn_blacklisted = FALSE

/obj/item/rig_module/held/shield/Process()
	if(active)
		if(holder && holder.wearer)
			if(!(locate(/obj/item/shield/hardsuit) in holder.wearer))
				deactivate()
				return 0

	return ..()

/obj/item/rig_module/held/shield/activate()

	var/mob/living/M = holder.wearer

	if((src == M.l_hand) || (src == M.r_hand))
		return FALSE

	if(M.l_hand && M.r_hand)
		to_chat(M, SPAN_DANGER("Your hands are full."))
		return FALSE

	if(!do_after(M, 1.5 SECONDS, src))
		to_chat(M, SPAN_DANGER("You have to stand still to deploy the shield!"))
		return FALSE

	..()

	var/obj/item/shield/hardsuit/shield = new(M)
	shield.creator = M
	M.put_in_hands(shield)
	M.visible_message(SPAN_WARNING("\The [M] deploys \his [shield]!"))

/obj/item/rig_module/held/shield/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/shield/hardsuit/shield in M.contents)
		M.drop_from_inventory(shield)
		qdel(shield)
	
	to_chat(M, "The shield retracts into the hardsuit.")

/obj/item/rig_module/fabricator
	name = "matter fabricator"
	desc = "A self-contained microfactory system for hardsuit integration."
	selectable = 1
	usable = 1
	use_power_cost = 15
	icon_state = "enet"

	engage_string = "Fabricate Star"

	interface_name = "Death blossom launcher"
	interface_desc = "An integrated microfactory that produces poisoned throwing stars from thin air and electricity."
	rarity_value = 100
	var/fabrication_type = /obj/item/material/star/ninja
	var/fire_force = 30
	var/fire_distance = 10

/obj/item/rig_module/fabricator/engage(atom/target)

	if(!..())
		return 0

	var/mob/living/H = holder.wearer

	if(target)
		var/obj/item/firing = new fabrication_type()
		firing.forceMove(get_turf(src))
		H.visible_message(SPAN_DANGER("[H] launches \a [firing]!"))
		firing.throw_at(target,fire_force,fire_distance)
	else
		if(H.l_hand && H.r_hand)
			to_chat(H, SPAN_DANGER("Your hands are full."))
		else
			var/obj/item/new_weapon = new fabrication_type()
			new_weapon.forceMove(H)
			to_chat(H, "<font color='blue'><b>You quickly fabricate \a [new_weapon].</b></font>")
			H.put_in_hands(new_weapon)

	return 1
