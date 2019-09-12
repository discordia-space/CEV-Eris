/datum/design/research/item/weapon
	category = CAT_WEAPON

// Weapons
/datum/design/research/item/weapon/AssembleDesignDesc()
	if(!desc && build_path)
		var/obj/item/I = build_path
		desc = initial(I.desc)
	else
		..()

/datum/design/research/item/weapon/stunrevolver
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TAAAA"

/datum/design/research/item/weapon/nuclear_gun
	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	sort_string = "TAAAB"

/datum/design/research/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	build_path = /obj/item/weapon/gun/energy/lasercannon
	sort_string = "TAAAC"

/datum/design/research/item/weapon/c20r
	name = "C20R-prototype"
	desc = "The C-20r is a lightweight and rapid-firing SMG. Uses 10mm rounds."
	build_path = /obj/item/weapon/gun/projectile/automatic/c20r
	sort_string = "TAAAF"

/datum/design/research/item/weapon/plasmapistol
	build_path = /obj/item/weapon/gun/energy/toxgun
	sort_string = "TAAAD"

/datum/design/research/item/weapon/decloner
	build_path = /obj/item/weapon/gun/energy/decloner
	sort_string = "TAAAE"

/datum/design/research/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TABAA"

/datum/design/research/item/weapon/rapidsyringe
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TABAB"

/datum/design/research/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	build_path = /obj/item/weapon/gun/energy/temperature
	sort_string = "TABAC"

/datum/design/research/item/weapon/large_grenade
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TACAA"

/datum/design/research/item/weapon/flora_gun
	build_path = /obj/item/weapon/gun/energy/floragun
	sort_string = "TBAAA"

/datum/design/research/item/weapon/bluespace_harpoon
	build_path = /obj/item/weapon/bluespace_harpoon
	sort_string = "TBAAB"

// Ammo
/datum/design/research/item/ammo
	name_category = "ammunition"
	category = CAT_WEAPON

/datum/design/research/item/ammo/shotgun_stun
	name = "shotgun, stun"
	desc = "A stunning shell for a shotgun."
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TAACB"
