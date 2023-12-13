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

	spawnedAtoms.Add(new /obj/item/tank/jetpack/oxygen(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/syndicate(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/syndicate(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/space/void/merc(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/crowbar(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/cell/large/high(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/card/id/syndicate(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/multitool(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/shield/buckler/energy(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/magboots(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/pouch/holster(NULLSPACE)) // Perhaps this may encourage actually buying pistols.
	spawnedAtoms.Add(new /obj/item/storage/pouch/ammo(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/syndicate/suit
	desc = "A storage unit for voidsuits."

/obj/structure/closet/syndicate/suit/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tank/jetpack/oxygen(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/magboots(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/space/void/merc(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/syndicate(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/syndicate/nuclear
	desc = "A storage unit for nuclear-operative gear."
	spawn_blacklisted = TRUE

/obj/structure/closet/syndicate/nuclear/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/ammo_magazine/smg(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/handcuffs(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/flashbangs(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/gun(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/pinpointer/nukeop(NULLSPACE))
	var/obj/item/device/radio/uplink/U = new(NULLSPACE)
	spawnedAtoms.Add(U)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	U.hidden_uplink.uses = 40
