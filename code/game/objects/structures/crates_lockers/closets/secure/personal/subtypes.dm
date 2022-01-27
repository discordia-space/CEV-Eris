/obj/structure/closet/secure_closet/personal/populate_contents()
	if(prob(50))
		new /obj/item/stora69e/backpack(src)
	else
		new /obj/item/stora69e/backpack/satchel(src)
	new /obj/item/device/radio/headset(src)


/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/populate_contents()
	new /obj/item/clothin69/under/color/white(src)
	new /obj/item/clothin69/shoes/color/white(src)

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	icon_lock = "cabinet"

/obj/structure/closet/secure_closet/personal/cabinet/populate_contents()
	new /obj/item/stora69e/backpack/satchel/leather/withwallet(src)
	new /obj/item/device/radio/headset(src)

