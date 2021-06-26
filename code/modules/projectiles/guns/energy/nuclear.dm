/obj/item/gun/energy/gun/nuclear
	name = "Prototype: advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon = 'icons/obj/guns/energy/nucgun.dmi'
	icon_state = "nucgun"
	item_charge_meter = TRUE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_PAINFUL //looks heavier than a pistol
	self_recharge = TRUE
	modifystate = null
	matter = list(MATERIAL_STEEL = 20, MATERIAL_URANIUM = 10)
	price_tag = 4000
	spawn_blacklisted = TRUE

	init_firemodes = list(
		STUNBOLT,
		LETHAL
		)

	var/lightfail = 0

//override for failcheck behaviour
/obj/item/gun/energy/gun/nuclear/Process()
	charge_tick++
	if(charge_tick < 4) return 0
	charge_tick = 0
	if(!cell) return 0
	if((cell.charge / cell.maxcharge) != 1)
		cell.give(charge_cost)
		update_icon()
	return 1

/obj/item/gun/energy/gun/nuclear/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun") overlays += "nucgun-stun"
		if("lethal") overlays += "nucgun-kill"

/obj/item/gun/energy/gun/nuclear/on_update_icon()
	cut_overlays()
	update_mode()
