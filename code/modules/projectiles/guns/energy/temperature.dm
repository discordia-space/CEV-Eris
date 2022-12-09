/obj/item/gun/energy/temperature
	name = "temperature gun"
	icon = 'icons/obj/guns/energy/freezegun.dmi'
	icon_state = "freezegun"
	item_state = "freezegun"
	item_charge_meter = TRUE
	fire_sound = 'sound/weapons/pulse3.ogg'
	desc = "A gun that changes temperatures. It has a small label on the side, \"Rapid freezing might cause shock.\""
	var/temperature = T20C
	var/current_temperature = T20C
	charge_cost = 50
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	slot_flags = SLOT_BELT|SLOT_BACK
	matter = list(MATERIAL_STEEL = 20)
	price_tag = 1500
	projectile_type = /obj/item/projectile/beam/heat
	zoom_factors = list(2)

	gun_parts = list(/obj/item/stack/material/steel = 4)
	init_recoil = HANDGUN_RECOIL(1)
	serial_type = "ML"

	init_firemodes = list(
		list(mode_name="Heat ray", mode_desc="A ray that rapidly raises the temperature of anything hit", projectile_type=/obj/item/projectile/beam/heat, fire_delay=6, charge_cost=50, icon="kill", projectile_color = "#ff8c00"),
		list(mode_name="Freeze ray", mode_desc="A ray that rapidly freezes anything hit", projectile_type=/obj/item/projectile/beam/cold, fire_delay=6, charge_cost=50, icon="stun", projectile_color = "#ADD8E6"),
		list(mode_name="Heatwave", mode_desc="A ray that rapidly heats anything hit in a radius", projectile_type=/obj/item/projectile/beam/heatwave, fire_delay=12, charge_cost=150, icon="destroy", projectile_color = "#ff8c00")
	)
