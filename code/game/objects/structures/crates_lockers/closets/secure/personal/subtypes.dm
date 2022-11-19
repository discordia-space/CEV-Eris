/obj/structure/closet/secure_closet/personal/populate_contents()
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel(src)
	new /obj/item/device/radio/headset(src)


/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/populate_contents()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	icon_lock = "cabinet"

/obj/structure/closet/secure_closet/personal/cabinet/populate_contents()
	new /obj/item/storage/backpack/satchel/leather/withwallet(src)
	new /obj/item/device/radio/headset(src)

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
