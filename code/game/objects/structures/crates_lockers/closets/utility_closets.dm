/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and o2 tanks."
	icon_state = "emergency"

/obj/structure/closet/emcloset/New()
	..()

	switch (pickweight(list("small" = 55, "aid" = 25, "tank" = 10, "both" = 10)))
		if ("small")
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
		if ("aid")
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/weapon/storage/toolbox/emergency(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/storage/firstaid/o2(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
		if ("tank")
			new /obj/item/weapon/tank/emergency_oxygen/engi(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/tank/emergency_oxygen/engi(src)
			new /obj/item/clothing/mask/breath(src)
		if ("both")
			new /obj/item/weapon/storage/toolbox/emergency(src)
			new /obj/item/weapon/tank/emergency_oxygen/engi(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/storage/firstaid/o2(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)

/obj/structure/closet/emcloset/legacy/populate_contents()
	..()
	new /obj/item/weapon/tank/oxygen(src)
	new /obj/item/clothing/mask/gas(src)

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "fire"

/obj/structure/closet/firecloset/populate_contents()
	..()

	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/oxygen/red(src)
	new /obj/item/weapon/extinguisher(src)
	new /obj/item/clothing/head/hardhat/red(src)

/obj/structure/closet/firecloset/full/New()
	..()
	sleep(4)
	contents = list()

	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/device/lighting/toggleable/flashlight(src)
	new /obj/item/weapon/tank/oxygen/red(src)
	new /obj/item/weapon/extinguisher(src)
	new /obj/item/clothing/head/hardhat/red(src)

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "eng"
	icon_door = "eng_tool"

/obj/structure/closet/toolcloset/populate_contents()
	..()
	if(prob(40))
		new /obj/item/clothing/suit/storage/hazardvest(src)
	if(prob(70))
		new /obj/item/device/lighting/toggleable/flashlight(src)
	if(prob(70))
		new /obj/item/weapon/tool/screwdriver(src)
	if(prob(70))
		new /obj/item/weapon/tool/wrench(src)
	if(prob(70))
		new /obj/item/weapon/tool/weldingtool(src)
	if(prob(70))
		new /obj/item/weapon/tool/crowbar(src)
	if(prob(70))
		new /obj/item/weapon/tool/wirecutters(src)
	if(prob(70))
		new /obj/item/device/t_scanner(src)
	if(prob(20))
		new /obj/item/weapon/storage/belt/utility(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(20))
		new /obj/item/weapon/tool/multitool(src)
	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	if(prob(40))
		new /obj/item/clothing/head/hardhat(src)


/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	icon_state = "eng"
	icon_door = "eng_rad"

/obj/structure/closet/radiation/populate_contents()
	..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bomb"

/obj/structure/closet/bombcloset/populate_contents()
	..()
	new /obj/item/clothing/suit/bomb_suit( src )
	new /obj/item/clothing/under/color/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/head/bomb_hood( src )


/obj/structure/closet/bombclosetsecurity
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bomb"

/obj/structure/closet/bombclosetsecurity/populate_contents()
	..()
	new /obj/item/clothing/suit/bomb_suit/security( src )
	new /obj/item/clothing/under/rank/security( src )
	new /obj/item/clothing/shoes/color/brown( src )
	new /obj/item/clothing/head/bomb_hood/security( src )