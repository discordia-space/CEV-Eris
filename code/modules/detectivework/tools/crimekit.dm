//crime scene kit
/obj/item/storage/briefcase/crimekit
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

/obj/item/storage/briefcase/crimekit/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/box/swabs(NULL))
	spawnedAtoms.Add(new  /obj/item/storage/box/fingerprints(NULL))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/spray/luminol(NULL))
	spawnedAtoms.Add(new  /obj/item/device/uv_light(NULL))
	spawnedAtoms.Add(new  /obj/item/forensics/sample_kit(NULL))
	spawnedAtoms.Add(new  /obj/item/forensics/sample_kit/powder(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
