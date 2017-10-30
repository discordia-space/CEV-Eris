/obj/item/weapon/gun/projectile/revolver/consul
	name = "FS REV .44 \"Consul\""
	desc = "When you need this case closed realy bad. Uses .44 ammo."
	icon_state = "inspector"
	item_state = "revolver"
	drawChargeMeter = FALSE
	caliber = ".44"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/cl44r
