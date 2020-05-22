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

/obj/structure/closet/emcloset/populate_contents()
	switch(pickweight(list("small" = 55, "aid" = 25, "tank" = 10, "both" = 10)))
		if ("small")
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/space/emergency(src)
		if ("aid")
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/weapon/storage/toolbox/emergency(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/storage/firstaid/o2(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/space/emergency(src)
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
			new /obj/item/clothing/head/space/emergency(src)
			new /obj/item/clothing/head/space/emergency(src)

/obj/structure/closet/emcloset/legacy/populate_contents()
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
	new /obj/item/weapon/storage/firstaid/fire(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/storage/backpack/duffelbag/firesafety(src)
	new /obj/item/device/lighting/toggleable/flashlight(src)

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "eng"
	icon_door = "eng_tool"

/obj/structure/closet/toolcloset/populate_contents()
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
	if(prob(50))
		new /obj/item/weapon/tool/wirecutters(src)
	if(prob(50))
		new /obj/item/weapon/tool/wirecutters/pliers(src)
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
	if(prob(5))
		new /obj/item/weapon/storage/pouch/engineering_tools(src)
	if(prob(1))
		new /obj/item/weapon/storage/pouch/engineering_supply(src)
	if(prob(40))
		new /obj/item/clothing/head/hardhat(src)
	new /obj/random/tool_upgrade(src)
	new /obj/random/tool_upgrade(src)
	//Every tool closet contains a couple guaranteed toolmods

/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	icon_state = "eng"
	icon_door = "eng_rad"

/obj/structure/closet/radiation/populate_contents()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective space suits."
	icon_state = "bomb"

/obj/structure/closet/bombcloset/populate_contents()
	new /obj/item/clothing/suit/space/bomb(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/space/bomb(src)

/obj/structure/closet/bombcloset/security/populate_contents()
	new /obj/item/clothing/suit/space/bomb/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/shoes/color/brown(src)
	new /obj/item/clothing/head/space/bomb/security(src)

/obj/structure/closet/self_pacification
	name = "\improper Anti-Depressive Self-Pacification Treatment Utility closet"
	desc = "The last things you will ever need!"
	icon_state = "syndicate"
	icon_door = "syndicate_skull"
	anchored = TRUE

/obj/structure/closet/self_pacification/populate_contents()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency_oxygen/nitrogen(src)
	new /obj/item/weapon/tank/emergency_oxygen/nitrogen(src)
	new /obj/item/weapon/paper/self_pacification(src)
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/pen(src)
