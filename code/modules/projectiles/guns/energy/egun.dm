/obj/item/weapon/gun/energy/gun
	name = "FS PDW E \"Spider Rose\""
	desc = "Spider Rose is a versatile energy based sidearm, capable of switching between low and high capacity projectile settings. In other words: Stun or Kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	max_shots = 10

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="energystun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="energykill", fire_sound='sound/weapons/Laser.ogg'),
		)

/obj/item/weapon/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/gun/martin
	name = "FS PDW E \"Martin\""
	desc = "Last chance gun."
	icon_state = "PDW"
	item_state = "gun"
	max_shots = 2
	charge_meter = 0
	w_class = 2
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = null

/obj/item/weapon/gun/energy/gun/martin/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun") overlays += "taser_pdw"
		if("lethal") overlays += "lazer_pdw"

/obj/item/weapon/gun/energy/gun/martin/update_icon()
	overlays.Cut()
	update_mode()