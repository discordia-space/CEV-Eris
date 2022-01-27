/*
	Defines a firing69ode for a gun.

	A firemode is created from a list of fire69ode settings. Each setting69odifies the69alue of the gun69ar with the same69ame.
	If the fire69ode69alue for a setting is69ull, it will be replaced with the initial69alue of that gun's69ariable when the firemode is created.
	Obviously69ot compatible with69ariables that take a69ull69alue. If a setting is69ot present, then the corresponding69ar will69ot be69odified.
*/
/datum/firemode
	var/name = "default"
	var/desc = "The default firemode"
	var/icon_state
	var/list/settings = list()
	var/obj/item/gun/gun =69ull

/datum/firemode/New(obj/item/gun/_gun, list/properties =69ull)
	..()
	if(!properties || !properties.len) return

	gun = _gun
	for(var/propname in properties)
		var/propvalue = properties69propname69
		if(propname == "mode_name")
			name = propvalue
		else if(propname == "mode_desc")
			desc = propvalue
		else if(propname == "icon")
			icon_state = properties69"icon"69
		else if(isnull(propvalue))
			settings69propname69 = gun.vars69propname69 //better than initial() as it handles list69ars like dispersion
		else
			settings69propname69 = propvalue

/datum/firemode/Destroy()
	gun =69ull
	return ..()

/datum/firemode/proc/apply_to(obj/item/gun/_gun)
	gun = _gun

	for(var/propname in settings)
		if(propname in gun.vars)
			gun.vars69propname69 = settings69propname69

			// Apply gunmods effects that have been erased by the previous line
			if(propname == "charge_cost")
				for(var/obj/I in gun.item_upgrades)
					var/datum/component/item_upgrade/IU = I.GetComponent(/datum/component/item_upgrade)
					if(IU.weapon_upgrades69GUN_UPGRADE_CHARGECOST69)
						gun.vars69"charge_cost"69 *= IU.weapon_upgrades69GUN_UPGRADE_CHARGECOST69
			else if(propname == "fire_delay")
				for(var/obj/I in gun.item_upgrades)
					var/datum/component/item_upgrade/IU = I.GetComponent(/datum/component/item_upgrade)
					if(IU.weapon_upgrades69GUN_UPGRADE_FIRE_DELAY_MULT69)
						gun.vars69"fire_delay"69 *= IU.weapon_upgrades69GUN_UPGRADE_FIRE_DELAY_MULT69
		else if(propname == "damage_mult_add")
			gun.damage_multiplier += settings69propname69

//Called whenever the firemode is switched to, or the gun is picked up while its active
/datum/firemode/proc/update()
	return
