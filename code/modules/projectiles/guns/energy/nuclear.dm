/obj/item/weapon/gun/energy/gun/nuclear
	name = "Prototype: advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon = 'icons/obj/guns/energy/nucgun.dmi'
	icon_state = "nucgun"
	item_charge_meter = TRUE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_PAINFUL //looks heavier than a pistol
	self_recharge = 1
	modifystate = null
	matter = list(MATERIAL_STEEL = 20, MATERIAL_URANIUM = 10)
	price_tag = 4000

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg', icon="stun"),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg', icon="kill"),
		)

	var/lightfail = 0

//override for failcheck behaviour
/obj/item/weapon/gun/energy/gun/nuclear/Process()
	charge_tick++
	if(charge_tick < 4) return 0
	charge_tick = 0
	if(!cell) return 0
	if((cell.charge / cell.maxcharge) != 1)
		cell.give(charge_cost)
		update_icon()
	return 1

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_charge()
	var/ratio = cell.charge / cell.maxcharge
	ratio = round(ratio, 0.25) * 100
	overlays += "nucgun-[ratio]"
	set_item_state("-[ratio]")

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_reactor()
	if(lightfail)
		overlays += "nucgun-medium"
	else if ((cell.charge/cell.maxcharge) <= 0.5)
		overlays += "nucgun-light"
	else
		overlays += "nucgun-clean"

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun") overlays += "nucgun-stun"
		if("lethal") overlays += "nucgun-kill"

/obj/item/weapon/gun/energy/gun/nuclear/update_icon()
	overlays.Cut()
	if(cell)
		update_charge()
		update_reactor()
	update_mode()
