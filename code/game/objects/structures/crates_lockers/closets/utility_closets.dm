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
	desc = "A storage unit for emergency breathmasks and o2 tanks."
	icon_state = "emergency"
	rarity_value = 3
	spawn_tags = SPAWN_TAG_CLOSET_TECHNICAL

/obj/structure/closet/emcloset/populate_contents()
	var/list/spawnedAtoms = list()

	switch(pickweight(list("small" = 55, "aid" = 25, "tank" = 10, "both" = 10)))
		if ("small")
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULL))
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/emergency(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/emergency(NULL))
		if ("aid")
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULL))
			spawnedAtoms.Add(new /obj/item/storage/toolbox/emergency(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
			spawnedAtoms.Add(new /obj/item/storage/firstaid/o2(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/emergency(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/emergency(NULL))
		if ("tank")
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/engi(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/engi(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
		if ("both")
			spawnedAtoms.Add(new /obj/item/storage/toolbox/emergency(NULL))
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/engi(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
			spawnedAtoms.Add(new /obj/item/storage/firstaid/o2(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/emergency(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/emergency(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/emergency(NULL))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/emergency(NULL))

	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/emcloset/legacy/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tank/oxygen(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "fire-safety closet"
	desc = "A storage unit for fire-fighting supplies."
	icon_state = "fire"
	rarity_value = 1.5
	spawn_tags = SPAWN_TAG_CLOSET_TECHNICAL


/obj/structure/closet/firecloset/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/fire(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat/red(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas(NULL))
	spawnedAtoms.Add(new /obj/item/tank/oxygen/red(NULL))
	spawnedAtoms.Add(new /obj/item/extinguisher(NULL))
	spawnedAtoms.Add(new /obj/item/extinguisher(NULL))
	spawnedAtoms.Add(new /obj/item/device/lighting/toggleable/flashlight(NULL))

	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "A storage unit for tools."
	icon_state = "eng"
	icon_door = "eng_tool"
	rarity_value = 1.5
	spawn_tags = SPAWN_TAG_CLOSET_TECHNICAL

/obj/structure/closet/toolcloset/populate_contents()
	var/list/spawnedAtoms = list()

	if(prob(40))
		spawnedAtoms.Add(new /obj/item/clothing/suit/storage/hazardvest(NULL))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/device/lighting/toggleable/flashlight(NULL))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/tool/screwdriver(NULL))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/tool/wrench(NULL))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/tool/weldingtool(NULL))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/tool/crowbar(NULL))
	if(prob(50))
		spawnedAtoms.Add(new /obj/item/tool/wirecutters(NULL))
	if(prob(50))
		spawnedAtoms.Add(new /obj/item/tool/wirecutters/pliers(NULL))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/device/t_scanner(NULL))
	if(prob(20))
		spawnedAtoms.Add(new /obj/item/storage/belt/utility(NULL))
	if(prob(30))
		spawnedAtoms.Add(new /obj/item/stack/cable_coil/random(NULL))
	if(prob(30))
		spawnedAtoms.Add(new /obj/item/stack/cable_coil/random(NULL))
	if(prob(30))
		spawnedAtoms.Add(new /obj/item/stack/cable_coil/random(NULL))
	if(prob(20))
		spawnedAtoms.Add(new /obj/item/tool/multitool(NULL))
	if(prob(5))
		spawnedAtoms.Add(new /obj/item/clothing/gloves/insulated(NULL))
	if(prob(5))
		spawnedAtoms.Add(new /obj/item/storage/pouch/engineering_tools(NULL))
	if(prob(1))
		spawnedAtoms.Add(new /obj/item/storage/pouch/engineering_supply(NULL))
	if(prob(1))
		spawnedAtoms.Add(new /obj/item/storage/pouch/engineering_material(NULL))
	if(prob(40))
		spawnedAtoms.Add(new /obj/item/clothing/head/hardhat(NULL))
	spawnedAtoms.Add(new /obj/spawner/tool_upgrade(NULL))
	spawnedAtoms.Add(new /obj/spawner/tool_upgrade(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
	//Every tool closet contains a couple guaranteed toolmods

/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "A storage unit for rad-protective suits."
	icon_state = "eng"
	icon_door = "eng_rad"

/obj/structure/closet/radiation/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/radiation(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/radiation(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/suit/radiation(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/radiation(NULL))

	or(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "A storage unit for explosion-protective space suits."
	icon_state = "bomb"
	rarity_value = 14.28
	spawn_tags = SPAWN_TAG_CLOSET_BOMB


/obj/structure/closet/bombcloset/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/space/bomb(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/space/bomb(NULL))

	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/bombcloset/security
	rarity_value = 50

/obj/structure/closet/bombcloset/security/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/space/bomb(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/security(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/brown(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/head/space/bomb(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
/obj/structure/closet/self_pacification
	name = "\improper Anti-Depressive Self-Pacification Treatment Utility closet"
	desc = "The last things you will ever need!"
	icon_state = "syndicate"
	icon_door = "syndicate_skull"
	anchored = TRUE

/obj/structure/closet/self_pacification/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULL))
	spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/nitrogen(NULL))
	spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/nitrogen(NULL))
	spawnedAtoms.Add(new /obj/item/paper/self_pacification(NULL))
	spawnedAtoms.Add(new /obj/item/paper(NULL))
	spawnedAtoms.Add(new /obj/item/pen(NULL))

	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
