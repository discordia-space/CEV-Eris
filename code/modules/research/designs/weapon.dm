// Weapons
/datum/design/research/item/weapon/AssembleDesignDesc()
	if(!desc && build_path)
		var/obj/item/I = build_path
		desc = initial(I.desc)
	else
		..()

/datum/design/research/item/weapon/stunrevolver
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TAAAA"

/datum/design/research/item/weapon/nuclear_gun
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)

	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	sort_string = "TAAAB"

/datum/design/research/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	sort_string = "TAAAC"

/datum/design/research/item/weapon/plasmapistol
	req_tech = list(TECH_COMBAT = 5, TECH_PLASMA = 4)
	build_path = /obj/item/weapon/gun/energy/toxgun
	sort_string = "TAAAD"

/datum/design/research/item/weapon/decloner
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	build_path = /obj/item/weapon/gun/energy/decloner
	sort_string = "TAAAE"

/datum/design/research/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TABAA"

/datum/design/research/item/weapon/rapidsyringe
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TABAB"

/datum/design/research/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)

	build_path = /obj/item/weapon/gun/energy/temperature
	sort_string = "TABAC"

/datum/design/research/item/weapon/large_grenade
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TACAA"

/datum/design/research/item/weapon/flora_gun
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	build_path = /obj/item/weapon/gun/energy/floragun
	sort_string = "TBAAA"


// Ammo
/datum/design/research/item/ammo
	name_category = "ammunition"

/datum/design/research/item/ammo/shotgun_stun
	name = "shotgun, stun"
	desc = "A stunning shell for a shotgun."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TAACB"
