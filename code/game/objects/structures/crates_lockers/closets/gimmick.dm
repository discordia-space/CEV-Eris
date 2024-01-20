/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet"
	bad_type = /obj/structure/closet/cabinet

/obj/structure/closet/gimmick
	name = "administrative supply closet"
	desc = "A storage unit for things that have no right being here."
	icon_state = "syndicate"
	anchored = FALSE
	bad_type = /obj/structure/closet/gimmick

/obj/structure/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	icon_state = "syndicate"
	anchored = TRUE
	spawn_blacklisted = TRUE

/obj/structure/closet/thunderdome/New()
	..()

/obj/structure/closet/thunderdome/tdred
	name = "red-team Thunderdome closet"

/obj/structure/closet/thunderdome/tdred/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/armor/heavy/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/armor/heavy/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/armor/heavy/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/energy/sword(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/energy/sword(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/energy/sword(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/laser(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/laser(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/laser(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/baton(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/baton(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/baton(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/flashbangs(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/flashbangs(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/flashbangs(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/armor/helmet/thunderdome(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/armor/helmet/thunderdome(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/armor/helmet/thunderdome(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "green-team Thunderdome closet"
	icon_state = "syndicate"

/obj/structure/closet/thunderdome/tdgreen/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/armor/heavy/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/armor/heavy/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/armor/heavy/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/energy/sword(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/energy/sword(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/energy/sword(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/laser(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/laser(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/gun/energy/laser(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/baton(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/baton(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/melee/baton(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/flashbangs(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/flashbangs(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/box/flashbangs(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/armor/helmet/thunderdome(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/armor/helmet/thunderdome(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/armor/helmet/thunderdome(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/oldstyle
	name = "old closet"
	desc = "Old and rusty, this closet is probably older than you."
	icon_state = "oldstyle"
