/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/icon_state
	var/list/settings = list()
	var/obj/item/weapon/gun/gun = null

/datum/firemode/New(obj/item/weapon/gun/_gun, list/properties = null)
	..()
	if(!properties) return

	// Special var, controls mode button icon_state
	if(properties["icon"])
		icon_state = properties["icon"]
		properties -= "icon"

	gun = _gun
	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like dispersion
		else
			settings[propname] = propvalue

/datum/firemode/Destroy()
	gun = null
	return ..()

/datum/firemode/proc/apply_to(obj/item/weapon/gun/_gun)
	gun = _gun

	for(var/propname in settings)
		if(propname in gun.vars)
			gun.vars[propname] = settings[propname]

//Called whenever the firemode is switched to, or the gun is picked up while its active
/datum/firemode/proc/update()
	return
