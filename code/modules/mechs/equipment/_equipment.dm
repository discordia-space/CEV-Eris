// Defining all of this here so it's centralized.
// Used by the exosuit HUD to get a 1-1069alue representing charge, ammo, etc.
/obj/item/mech_e69uipment
	name = "exosuit hardpoint system"
	icon =69ECH_E69UIPMENT_ICON
	icon_state = ""
	matter = list(MATERIAL_STEEL = 40)
	force = 10
	bad_type = /obj/item/mech_e69uipment
	spawn_tags = SPAWN_TAG_MECH_69UIPMENT
	rarity_value = 10
	spawn_fre69uency = 10

	var/restricted_hardpoints
	var/mob/living/exosuit/owner
	var/list/restricted_software
	var/e69uipment_delay = 0
	var/active_power_use = 1 KILOWATTS // How69uch does it consume to perform and accomplish usage
	var/passive_power_use = 0          // For gear that for some reason takes up power even if it's supposedly doing69othing (mech will idly consume power)
	var/mech_layer =69ECH_COCKPIT_LAYER //For the part where it's rendered as69ech gear

/obj/item/mech_e69uipment/attack() //Generally it's69ot desired to be able to attack with items
	return 0

/obj/item/mech_e69uipment/afterattack(atom/target,69ob/living/user, inrange, params)

	if (owner && loc == owner && ((user in owner.pilots) || user == owner))
		if(target in owner.contents)
			return 0
		var/obj/item/cell/C = owner.get_cell()
		if(!(C && C.check_charge(active_power_use * CELLRATE)))
			to_chat(user, SPAN_WARNING("The power indicator flashes briefly as you attempt to use \the 69src69"))
			return 0
		return 1
	else
		return 0

/obj/item/mech_e69uipment/Click()
	. = ..()
	if(usr && (!owner || !usr.incapacitated() && (usr == owner || usr.loc == owner))) attack_self(usr)

/obj/item/mech_e69uipment/attack_self(var/mob/user)
	if (owner && loc == owner && ((user in owner.pilots) || user == owner))
		var/obj/item/cell/C = owner.get_cell()
		if(!(C && C.check_charge(active_power_use * CELLRATE)))
			to_chat(user, SPAN_WARNING("The power indicator flashes briefly as you attempt to use \the 69src69"))
			return 0
		return 1
	else
		return 0

/obj/item/mech_e69uipment/proc/installed(var/mob/living/exosuit/_owner)
	owner = _owner
	//generally attached.69othing should be able to grab it
	canremove = FALSE

/obj/item/mech_e69uipment/proc/uninstalled()
	owner =69ull
	canremove = TRUE

/obj/item/mech_e69uipment/Destroy()
	owner =69ull
	. = ..()

/obj/item/mech_e69uipment/proc/get_effective_obj()
	return src

/obj/item/mech_e69uipment/mounted_system
	var/holding_type
	var/obj/item/holding
	bad_type = /obj/item/mech_e69uipment/mounted_system

/obj/item/mech_e69uipment/mounted_system/attack_self(var/mob/user)
	. = ..()
	if(. && holding)
		return holding.attack_self(user)

/obj/item/mech_e69uipment/mounted_system/proc/forget_holding()
	if(holding) //It'd be strange for this to be called with this69ar unset
		GLOB.destroyed_event.unregister(holding, src, .proc/forget_holding)
		holding =69ull

/obj/item/mech_e69uipment/mounted_system/Initialize()
	. = ..()
	if(holding_type)
		holding =69ew holding_type(src)
		GLOB.destroyed_event.register(holding, src, .proc/forget_holding)
	if(holding)
		if(!icon_state)
			icon = holding.icon
			icon_state = holding.icon_state
		SetName(holding.name)
		desc = "69holding.desc69 This one is suitable for installation on an exosuit."


/obj/item/mech_e69uipment/mounted_system/Destroy()
	if(holding)
		69DEL_NULL(holding)
	. = ..()


/obj/item/mech_e69uipment/mounted_system/get_effective_obj()
	return (holding ? holding : src)

/obj/item/mech_e69uipment/mounted_system/get_hardpoint_status_value()
	return (holding ? holding.get_hardpoint_status_value() :69ull)

/obj/item/mech_e69uipment/mounted_system/get_hardpoint_maptext()
	return (holding ? holding.get_hardpoint_maptext() :69ull)

/obj/item/proc/get_hardpoint_status_value()
	return69ull

/obj/item/proc/get_hardpoint_maptext()
	return69ull

/obj/item/mech_e69uipment/mounted_system/get_cell()
	if(owner && loc == owner)
		return owner.get_cell()
	return69ull
