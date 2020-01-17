/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	structure_damage_factor = STRUCTURE_DAMAGE_BLUNT
	throwforce = WEAPON_FORCE_NORMAL
	throw_speed = 1
	throw_range = 7
	w_class = ITEM_SIZE_BULKY
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 14 //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

/obj/item/weapon/storage/toolbox/emergency/populate_contents()
	new /obj/item/weapon/tool/crowbar(src)
	new /obj/item/weapon/extinguisher/mini(src)
	if(prob(50))
		new /obj/item/device/lighting/toggleable/flashlight(src)
	else
		new /obj/item/device/lighting/glowstick/flare(src)
	if (prob(40))
		new /obj/item/weapon/tool/tape_roll(src)
	new /obj/item/device/radio(src)

/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

/obj/item/weapon/storage/toolbox/mechanical/populate_contents()
	new /obj/item/weapon/tool/screwdriver(src)
	new /obj/item/weapon/tool/wrench(src)
	new /obj/item/weapon/tool/weldingtool(src)
	new /obj/item/weapon/tool/crowbar(src)
	if(prob(50))
		new /obj/item/weapon/tool/wirecutters(src)
	else
		new /obj/item/weapon/tool/wirecutters/pliers(src)
	new /obj/item/device/scanner/gas(src)

/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

/obj/item/weapon/storage/toolbox/electrical/populate_contents()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")

	new /obj/item/weapon/tool/screwdriver(src)
	if(prob(50))
		new /obj/item/weapon/tool/wirecutters(src)
	else
		new /obj/item/weapon/tool/wirecutters/pliers(src)
	new /obj/item/device/t_scanner(src)
	new /obj/item/weapon/tool/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/stack/cable_coil(src,30,color)

	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	else if(prob(10))
		new /obj/item/weapon/tool/multitool(src)
	else
		new /obj/item/stack/cable_coil(src,30,color)

	if(prob(60))
		new /obj/item/weapon/tool/tape_roll(src)

/obj/item/weapon/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	force = WEAPON_FORCE_DANGEROUS

/obj/item/weapon/storage/toolbox/syndicate/populate_contents()
	var/obj/item/weapon/tool/cell_tool

	new /obj/item/clothing/gloves/insulated(src)

	cell_tool = new /obj/item/weapon/tool/screwdriver/combi_driver(src)
	qdel(cell_tool.cell)
	cell_tool.cell = new /obj/item/weapon/cell/small/super(cell_tool)

	cell_tool = new /obj/item/weapon/tool/crowbar/pneumatic(src)
	qdel(cell_tool.cell)
	cell_tool.cell = new /obj/item/weapon/cell/medium/super(cell_tool)

	new /obj/item/weapon/tool/weldingtool/advanced(src)
	new /obj/item/weapon/tool/wirecutters/armature(src)
	new /obj/item/weapon/tool/multitool(src)
	new /obj/item/weapon/cell/medium/super(src)
	new /obj/item/weapon/cell/small/super(src)

