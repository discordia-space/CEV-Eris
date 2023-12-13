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

	spawnedAtoms.Add(new  /obj/item/storage/box/swabs(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/storage/box/fingerprints(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/spray/luminol(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/uv_light(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/forensics/sample_kit(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/forensics/sample_kit/powder(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
