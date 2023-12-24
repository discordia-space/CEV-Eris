/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = CONDUCT
	melleDamages = list(
		ARMOR_BLUNT = list(
			DELEM(BRUTE,12)
		)
	)
	wieldedMultiplier = 2
	WieldedattackDelay = 8
	structure_damage_factor = STRUCTURE_DAMAGE_BLUNT
	throwforce = WEAPON_FORCE_NORMAL
	throw_speed = 1
	throw_range = 7
	volumeClass = ITEM_SIZE_BULKY
	matter = list(MATERIAL_STEEL = 6)
	max_volumeClass = ITEM_SIZE_NORMAL
	max_storage_space = 14 //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")
	spawn_blacklisted = FALSE
	rarity_value = 10
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_TOOLBOX
	bad_type = /obj/item/storage/toolbox

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"
	rarity_value = 30

/obj/item/storage/toolbox/emergency/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tool/crowbar(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/extinguisher/mini(NULLSPACE))
	if(prob(40))
		spawnedAtoms.Add(new /obj/item/device/lighting/toggleable/flashlight(NULLSPACE))
	else if(prob(30))
		spawnedAtoms.Add(new /obj/item/gun/projectile/flare_gun(NULLSPACE))
		spawnedAtoms.Add(new /obj/item/ammo_casing/flare(NULLSPACE))
	else
		spawnedAtoms.Add(new /obj/item/device/lighting/glowstick/flare(NULLSPACE))
	if (prob(40))
		spawnedAtoms.Add(new /obj/item/tool/tape_roll(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/radio(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

/obj/item/storage/toolbox/mechanical/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/tool/screwdriver(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/wrench(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/weldingtool(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/crowbar(NULLSPACE))
	if(prob(50))
		spawnedAtoms.Add(new /obj/item/tool/wirecutters(NULLSPACE))
	else
		spawnedAtoms.Add(new /obj/item/tool/wirecutters/pliers(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/scanner/gas(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	rarity_value = 20

/obj/item/storage/toolbox/electrical/populate_contents()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	var/list/spawnedAtoms = list()


	spawnedAtoms.Add(new /obj/item/tool/screwdriver(NULLSPACE))
	if(prob(50))
		spawnedAtoms.Add(new /obj/item/tool/wirecutters(NULLSPACE))
	else
		spawnedAtoms.Add(new /obj/item/tool/wirecutters/pliers(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/device/t_scanner(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/crowbar(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stack/cable_coil(NULLSPACE,30,color))
	spawnedAtoms.Add(new /obj/item/stack/cable_coil(NULLSPACE,30,color))

	if(prob(5))
		spawnedAtoms.Add(new /obj/item/clothing/gloves/insulated(NULLSPACE))
	else if(prob(10))
		spawnedAtoms.Add(new /obj/item/tool/multitool(NULLSPACE))
	else
		spawnedAtoms.Add(new /obj/item/stack/cable_coil(NULLSPACE,30,color))

	if(prob(60))
		spawnedAtoms.Add(new /obj/item/tool/tape_roll(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(TECH_COMBAT = 1, TECH_COVERT = 1)
	melleDamages = list(
		ARMOR_BLUNT = list(
			DELEM(BRUTE,13)
		)
	)
	wieldedMultiplier = 2
	WieldedattackDelay = 7
	spawn_blacklisted = TRUE

/obj/item/storage/toolbox/syndicate/populate_contents()

	var/list/spawnedAtoms = list()

	var/obj/item/tool/cell_tool

	spawnedAtoms.Add(new /obj/item/clothing/gloves/insulated(NULLSPACE))

	cell_tool = new /obj/item/tool/screwdriver/combi_driver(NULLSPACE)
	spawnedAtoms.Add(cell_tool)
	qdel(cell_tool.cell)
	cell_tool.cell = new /obj/item/cell/small/super(cell_tool)
	cell_tool = new /obj/item/tool/crowbar/pneumatic(NULLSPACE)
	spawnedAtoms.Add(cell_tool)
	qdel(cell_tool.cell)
	cell_tool.cell = new /obj/item/cell/medium/super(cell_tool)

	spawnedAtoms.Add(new /obj/item/tool/weldingtool/advanced(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/wirecutters/armature(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/tool/multitool(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/cell/medium/super(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/cell/small/super(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

