/obj/structure/closet/secure_closet/personal/cargotech
	name = "guild technician's locker"
	req_access = list(access_merchant)
	access_occupy = list(access_cargo)
	icon_state = "cargo"

/obj/structure/closet/secure_closet/personal/cargotech/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/cargotech(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/cargo_jacket/black/old(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/cargo_jacket/black(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/cargo_jacket(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_cargo(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/soft(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/scanner/price(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/reinforced/quartermaster
	name = "guild merchant's locker"
	req_access = list(access_merchant)
	icon_state = "qm"

/obj/structure/closet/secure_closet/reinforced/quartermaster/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/cargotech(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/brown(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_cargo(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/fire(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/tank/emergency_oxygen(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/powered/meson(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/head/soft(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/shotgun/pump(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_casing/shotgun/beanbag(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_casing/shotgun/beanbag(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_casing/shotgun/beanbag(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/ammo_casing/shotgun/beanbag(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/scanner/price(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/artist
	name = "club artist's locker"
	req_access = list(access_change_club)
	access_occupy = list(access_artist)
	icon_state = "cargo"
	spawn_frequency = 0

/obj/structure/closet/secure_closet/personal/artist/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/artist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/artist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/artist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/artist_shoes(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/artist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/artist(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/artist_hat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/electronics/circuitboard/artist_bench(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/color/pink/artist

/obj/structure/closet/wardrobe/color/pink/artist/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/mime(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/color/white(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/mime(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/pen/crayon/mime(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/bottleofnothing(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/bikehorn(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/monocle(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/fancy/crayons(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/spray/waterflower(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/pda/clown(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/plaguedoctor(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/color/green(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/color/rainbow(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/backpack/clown(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/clown_shoes(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/clown(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/clown_hat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/gnome(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gnome(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/collectable/gnome(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/joker_19(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/joker(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

