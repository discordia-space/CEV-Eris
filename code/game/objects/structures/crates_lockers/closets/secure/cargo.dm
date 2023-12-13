/obj/structure/closet/secure_closet/personal/cargotech
	name = "guild technician's locker"
	req_access = list(access_merchant)
	access_occupy = list(access_cargo)
	icon_state = "cargo"

/obj/structure/closet/secure_closet/personal/cargotech/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/cargotech(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/cargo_jacket/black/old(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/cargo_jacket/black(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/storage/cargo_jacket(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_cargo(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/soft(NULL))
	spawnedAtoms.Add(new  /obj/item/device/scanner/price(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/reinforced/quartermaster
	name = "guild merchant's locker"
	req_access = list(access_merchant)
	icon_state = "qm"

/obj/structure/closet/secure_closet/reinforced/quartermaster/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/rank/cargotech(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/brown(NULL))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset/headset_cargo(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/suit/fire(NULL))
	spawnedAtoms.Add(new  /obj/item/tank/emergency_oxygen(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/mask/gas(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/glasses/powered/meson(NULL))
	spawnedAtoms.Add(new  /obj/item/clothing/head/soft(NULL))
	spawnedAtoms.Add(new  /obj/item/gun/projectile/shotgun/pump(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_casing/shotgun/beanbag(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_casing/shotgun/beanbag(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_casing/shotgun/beanbag(NULL))
	spawnedAtoms.Add(new  /obj/item/ammo_casing/shotgun/beanbag(NULL))
	spawnedAtoms.Add(new  /obj/item/device/scanner/price(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/artist
	name = "club artist's locker"
	req_access = list(access_change_club)
	access_occupy = list(access_artist)
	icon_state = "cargo"
	spawn_frequency = 0

/obj/structure/closet/secure_closet/personal/artist/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/artist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/artist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/artist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/artist_shoes(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret/artist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/artist(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/artist_hat(NULL))
	spawnedAtoms.Add(new /obj/item/device/radio/headset/headset_service(NULL))
	spawnedAtoms.Add(new /obj/item/electronics/circuitboard/artist_bench(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/wardrobe/color/pink/artist

/obj/structure/closet/wardrobe/color/pink/artist/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/under/mime(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/color/white(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/mime(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/beret(NULL))
	spawnedAtoms.Add(new /obj/item/pen/crayon/mime(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/bottleofnothing(NULL))
	spawnedAtoms.Add(new /obj/item/bikehorn(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/glasses/monocle(NULL))
	spawnedAtoms.Add(new /obj/item/storage/fancy/crayons(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/spray/waterflower(NULL))
	spawnedAtoms.Add(new /obj/item/device/pda/clown(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/plaguedoctor(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/color/green(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/gloves/color/rainbow(NULL))
	spawnedAtoms.Add(new /obj/item/storage/backpack/clown(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/clown_shoes(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/clown(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/clown_hat(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/gnome(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gnome(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/collectable/gnome(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/joker_19(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/joker(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

