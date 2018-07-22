/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFULL
	throwforce = WEAPON_FORCE_NORMAL
	throw_speed = 1
	throw_range = 7
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 14 //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

	New()
		..()
		new /obj/item/weapon/tool/crowbar(src)
		new /obj/item/weapon/extinguisher/mini(src)
		if(prob(50))
			new /obj/item/device/lighting/toggleable/flashlight(src)
		else
			new /obj/item/device/lighting/glowstick/flare(src)
		new /obj/item/device/radio(src)

/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

	New()
		..()
		new /obj/item/weapon/tool/screwdriver(src)
		new /obj/item/weapon/tool/wrench(src)
		new /obj/item/weapon/tool/weldingtool(src)
		new /obj/item/weapon/tool/crowbar(src)
		new /obj/item/device/scanner/analyzer(src)
		new /obj/item/weapon/tool/wirecutters(src)

/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

	New()
		..()
		var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
		new /obj/item/weapon/tool/screwdriver(src)
		new /obj/item/weapon/tool/wirecutters(src)
		new /obj/item/device/t_scanner(src)
		new /obj/item/weapon/tool/crowbar(src)
		new /obj/item/stack/cable_coil(src,30,color)
		new /obj/item/stack/cable_coil(src,30,color)
		if(prob(5))
			new /obj/item/clothing/gloves/insulated(src)
		else
			new /obj/item/stack/cable_coil(src,30,color)

/obj/item/weapon/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	force = WEAPON_FORCE_DANGEROUS

	New()
		..()
		new /obj/item/clothing/gloves/insulated(src)
		new /obj/item/weapon/tool/screwdriver(src)
		new /obj/item/weapon/tool/wrench(src)
		new /obj/item/weapon/tool/weldingtool(src)
		new /obj/item/weapon/tool/crowbar(src)
		new /obj/item/weapon/tool/wirecutters(src)
		new /obj/item/weapon/tool/multitool(src)
