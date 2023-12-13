/obj/structure/closet/syndicate
	name = "armory closet"
	desc = "Why is this here?"
	icon_state = "syndicate"
	bad_type = /obj/structure/closet/syndicate
	rarity_value = 100


/obj/structure/closet/syndicate/personal
	desc = "A storage unit for operative gear."

/obj/structure/closet/syndicate/personal/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tank/jetpack/oxygen(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/syndicate(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/syndicate(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/space/void/merc(NULL))
	spawnedAtoms.Add(new /obj/item/tool/crowbar(NULL))
	spawnedAtoms.Add(new /obj/item/cell/large/high(NULL))
	spawnedAtoms.Add(new /obj/item/card/id/syndicate(NULL))
	spawnedAtoms.Add(new /obj/item/tool/multitool(NULL))
	spawnedAtoms.Add(new /obj/item/shield/buckler/energy(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/magboots(NULL))
	spawnedAtoms.Add(new /obj/item/storage/pouch/holster(NULL)) // Perhaps this may encourage actually buying pistols.
	spawnedAtoms.Add(new /obj/item/storage/pouch/ammo(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/syndicate/suit
	desc = "A storage unit for voidsuits."

/obj/structure/closet/syndicate/suit/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tank/jetpack/oxygen(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/magboots(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/space/void/merc(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/syndicate(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/syndicate/nuclear
	desc = "A storage unit for nuclear-operative gear."
	spawn_blacklisted = TRUE

/obj/structure/closet/syndicate/nuclear/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULL))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULL))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULL))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULL))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULL))
	spawnedAtoms.Add(new /obj/item/storage/box/handcuffs(NULL))
	spawnedAtoms.Add(new /obj/item/storage/box/flashbangs(NULL))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULL))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULL))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULL))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULL))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULL))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULL))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULL))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULL))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULL))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULL))
	var/obj/item/device/radio/uplink/U = new(NULL)
	spawnedAtoms.Add(U)
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
	U.hidden_uplink.uses = 40
