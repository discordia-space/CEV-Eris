//crime scene kit
/obj/item/weapon/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	item_state = "case"
	storage_slots = 14
	price_tag = 50
	rarity_value = 20
	spawn_frequency = 10
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_BOX//CUIDADO

/obj/item/weapon/storage/briefcase/crimekit/populate_contents()
	new /obj/item/weapon/storage/box/swabs(src)
	new /obj/item/weapon/storage/box/fingerprints(src)
	new /obj/item/weapon/reagent_containers/spray/luminol(src)
	new /obj/item/device/uv_light(src)
	new /obj/item/weapon/forensics/sample_kit(src)
	new /obj/item/weapon/forensics/sample_kit/powder(src)