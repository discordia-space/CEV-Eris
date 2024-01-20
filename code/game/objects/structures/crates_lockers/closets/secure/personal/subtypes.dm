/obj/structure/closet/secure_closet/personal/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(50))
		spawnedAtoms.Add(new  /obj/item/storage/backpack(NULLSPACE))
	else
		spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/clothing/under/color/white(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/clothing/shoes/color/white(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	icon_lock = "cabinet"

/obj/structure/closet/secure_closet/personal/cabinet/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/storage/backpack/satchel/leather/withwallet(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/device/radio/headset(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

// Used for ID locking trade orders
/obj/structure/closet/secure_closet/personal/trade
	name = "order crate"
	desc = "A secure crate."
	icon = 'icons/obj/crate.dmi'
	icon_state = "securecrate"
	open_sound = 'sound/machines/click.ogg'
	close_sound = 'sound/machines/click.ogg'
	locked = FALSE
	climbable = TRUE
	dense_when_open = TRUE
	bad_type = /obj/structure/closet/secure_closet/personal/trade	// Snowflake crate for trade orders

/obj/structure/closet/secure_closet/personal/trade/populate_contents()
	return
