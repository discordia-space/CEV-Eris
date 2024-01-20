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
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/emergency(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/emergency(NULLSPACE))
		if ("aid")
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/storage/toolbox/emergency(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/storage/firstaid/o2(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/emergency(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/emergency(NULLSPACE))
		if ("tank")
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/engi(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/engi(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
		if ("both")
			spawnedAtoms.Add(new /obj/item/storage/toolbox/emergency(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/engi(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/storage/firstaid/o2(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/emergency(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/suit/space/emergency(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/emergency(NULLSPACE))
			spawnedAtoms.Add(new /obj/item/clothing/head/space/emergency(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/emcloset/legacy/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tank/oxygen(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
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

	spawnedAtoms.Add(new /obj/item/clothing/gloves/thick(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/fire(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/hardhat/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tank/oxygen/red(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/extinguisher(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/extinguisher(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/lighting/toggleable/flashlight(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
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
		spawnedAtoms.Add(new /obj/item/clothing/suit/storage/hazardvest(NULLSPACE))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/device/lighting/toggleable/flashlight(NULLSPACE))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/tool/screwdriver(NULLSPACE))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/tool/wrench(NULLSPACE))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/tool/weldingtool(NULLSPACE))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/tool/crowbar(NULLSPACE))
	if(prob(50))
		spawnedAtoms.Add(new /obj/item/tool/wirecutters(NULLSPACE))
	if(prob(50))
		spawnedAtoms.Add(new /obj/item/tool/wirecutters/pliers(NULLSPACE))
	if(prob(70))
		spawnedAtoms.Add(new /obj/item/device/t_scanner(NULLSPACE))
	if(prob(20))
		spawnedAtoms.Add(new /obj/item/storage/belt/utility(NULLSPACE))
	if(prob(30))
		spawnedAtoms.Add(new /obj/item/stack/cable_coil/random(NULLSPACE))
	if(prob(30))
		spawnedAtoms.Add(new /obj/item/stack/cable_coil/random(NULLSPACE))
	if(prob(30))
		spawnedAtoms.Add(new /obj/item/stack/cable_coil/random(NULLSPACE))
	if(prob(20))
		spawnedAtoms.Add(new /obj/item/tool/multitool(NULLSPACE))
	if(prob(5))
		spawnedAtoms.Add(new /obj/item/clothing/gloves/insulated(NULLSPACE))
	if(prob(5))
		spawnedAtoms.Add(new /obj/item/storage/pouch/engineering_tools(NULLSPACE))
	if(prob(1))
		spawnedAtoms.Add(new /obj/item/storage/pouch/engineering_supply(NULLSPACE))
	if(prob(1))
		spawnedAtoms.Add(new /obj/item/storage/pouch/engineering_material(NULLSPACE))
	if(prob(40))
		spawnedAtoms.Add(new /obj/item/clothing/head/hardhat(NULLSPACE))
	new /obj/spawner/tool_upgrade(src)
	new /obj/spawner/tool_upgrade(src)
	for(var/atom/movable/a in spawnedAtoms)
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

	spawnedAtoms.Add(new /obj/item/clothing/suit/radiation(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/radiation(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/suit/radiation(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/radiation(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
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

	spawnedAtoms.Add(new /obj/item/clothing/suit/space/bomb(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/black(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/space/bomb(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/bombcloset/security
	rarity_value = 50

/obj/structure/closet/bombcloset/security/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/suit/space/bomb(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/security(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/color/brown(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/head/space/bomb(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
/obj/structure/closet/self_pacification
	name = "\improper Anti-Depressive Self-Pacification Treatment Utility closet"
	desc = "The last things you will ever need!"
	icon_state = "syndicate"
	icon_door = "syndicate_skull"
	anchored = TRUE

/obj/structure/closet/self_pacification/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/breath(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/nitrogen(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tank/emergency_oxygen/nitrogen(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/paper/self_pacification(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/paper(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/pen(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
