/obj/item/storage/hcases //probably should rename
	name = "hard case"
	desc = "A hardcase that can hold a lot of69arious things. Alt+click to open and close."
	icon = 'icons/obj/cases.dmi'
	icon_state = "hcase"
	var/sticker_name = "hcase"

	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_SMALL_STORAGE * 1.5 //a better fancy box
	matter = list(MATERIAL_STEEL = 20)
	spawn_blacklisted = TRUE //This shouldn't spawn randomly
	rarity_value = 10
	spawn_tags = SPAWN_TAG_POUCH
	bad_type = /obj/item/storage
	var/sticker = null
	var/closed = TRUE

/obj/item/storage/hcases/proc/can_interact(mob/user)
	if((!ishuman(user) && (loc != user)) || user.stat || user.restrained())
		return 1
	if(istype(loc, /obj/item/storage))
		return 2
	return 0

/obj/item/storage/hcases/verb/apply_sticker(mob/user)
	set name = "Apply Sticker"
	set category = "Object"
	set src in69iew(1)

	if(can_interact(user) == 1)
		return
	sticker(user)

/obj/item/storage/hcases/proc/sticker(mob/user)
	var/list/options = list()
	options69"Orange"69 = "69sticker_name69_sticker_o"
	options69"Blue"69 = "69sticker_name69_sticker_b"
	options69"Red"69 = "69sticker_name69_sticker_r"
	options69"Green"69 = "69sticker_name69_sticker_g"
	options69"Purple"69 = "69sticker_name69_sticker_p"
	options69"IH Blue"69 = "69sticker_name69_sticker_ih"


	var/choice = input(user,"Which color do you want?") as null|anything in options

	if(!choice)
		return

	sticker = options69choice69
	update_icon()

/obj/item/storage/hcases/update_icon()
	icon_state = "69initial(icon_state)6969closed ? "" : "_open"69"
	cut_overlays()
	if(sticker)
		overlays += "69sticker6969closed ? "" : "_open"69"

/obj/item/storage/hcases/open(mob/user)
	if(closed)
		to_chat(user, SPAN_NOTICE("The lid is closed."))
		return

	. = ..()

/obj/item/storage/hcases/verb/69uick_open_close(mob/user)
	set name = "Close Lid"
	set category = "Object"
	set src in69iew(1)

	if(can_interact(user) == 1)	//can't use right click69erbs inside bags so only need to check for ablity
		return

	open_close(user)

/obj/item/storage/hcases/AltClick(mob/user)

	var/able = can_interact(user)

	if(able == 1)
		return

	if(able == 2)
		to_chat(user, SPAN_NOTICE("You cannot open the lid of \the 69src69 while it\'s in a container."))
		return

	open_close(user)

/obj/item/storage/hcases/proc/open_close(user)
	close_all()
	if(closed)
		to_chat(user, SPAN_NOTICE("You open the lid of the 69src69."))
		w_class = ITEM_SIZE_BULKY
		closed = FALSE
	else
		to_chat(user, SPAN_NOTICE("You close the lid of the 69src69."))
		w_class = ITEM_SIZE_NORMAL
		closed = TRUE

	playsound(loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
	update_icon()

obj/item/storage/hcases/attackby(obj/item/W,69ob/user)
	if(closed)
		to_chat(user, SPAN_NOTICE("You try to access \the 69src69 but its lid is closed!"))
		return
	. = ..()

/obj/item/storage/hcases/scrap	//Scrap isn't worse beyond poor shaming
	icon_state = "scrap"
	sticker_name = "scrap"
	desc = "A lac69uer coated hardcase that can hold a lot of69arious things. Alt+click to open and close."

//////////////////////////////////////////Ammo//////////////////////////////////////////

/obj/item/storage/hcases/ammo
	name = "ammo hard case"
	desc = "A generic ammo can. Can hold ammo69agazines, boxes, and bullets. Alt+click to open and close."
	icon_state = "ammo_case"
	sticker_name = "ammo"
	matter = list(MATERIAL_STEEL = 20)
	spawn_blacklisted = FALSE
	rarity_value = 60

	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/ammo_magazine/ammobox
		)

/obj/item/storage/hcases/ammo/ih
	icon_state = "ammo_case_ih"
	desc = "An ammo can for Ironhammer. Can hold ammo69agazines, boxes, and bullets. Alt+click to open and close."

/obj/item/storage/hcases/ammo/serb
	icon_state = "ammo_case_serb"
	desc = "An ammo can69ade by the Serbs. Can hold ammo69agazines, boxes, and bullets. Alt+click to open and close."

/obj/item/storage/hcases/ammo/blackmarket
	icon_state = "ammo_case_blackmarket"
	desc = "A shady looking ammo can. Can hold ammo69agazines, boxes, and bullets. Alt+click to open and close."

/obj/item/storage/hcases/ammo/excel
	icon_state = "ammo_case_excel"
	desc = "A communist ammo can! Can hold ammo69agazines, boxes, and bullets. Alt+click to open and close."

/obj/item/storage/hcases/ammo/scrap
	icon_state = "ammo_case_scrap"
	desc = "A lac69uer coated ammo can. Can hold ammo69agazines, boxes, and bullets. Alt+click to open and close."
	rarity_value = 30

//////////////////////////////////////////Parts//////////////////////////////////////////

/obj/item/storage/hcases/parts
	name = "parts hard case"
	desc = "A hard case that can hold weapon, armor,69achine, and electronic parts. Alt+click to open and close."
	icon_state = "hcase_parts"
	matter = list(MATERIAL_STEEL = 20)
	spawn_blacklisted = FALSE
	rarity_value = 60

	storage_slots = 20
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/part,
		/obj/item/stock_parts,
		/obj/item/electronics
		)

/obj/item/storage/hcases/parts/scrap
	icon_state = "scrap_parts"
	sticker_name = "scrap"
	desc = "A lac69uer coated hard case that can hold weapon, armor,69achine, and electronic parts. Alt+click to open and close."
	rarity_value = 30

//////////////////////////////////////////Medical//////////////////////////////////////////

/obj/item/storage/hcases/med
	name = "medical hard case"
	desc = "A hardcase with69edical69arkings that can hold a lot of69edical supplies. Alt+click to open and close."
	icon_state = "hcase_medi"
	matter = list(MATERIAL_STEEL = 20)
	spawn_blacklisted = FALSE
	rarity_value = 60

	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/device/scanner/health,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/hypospray,
		/obj/item/clothing/glasses/hud/health
		)

/obj/item/storage/hcases/med/scrap
	icon_state = "scrap_medi"
	sticker_name = "scrap"
	desc = "A lac69uer coated hardcase with69edical69arkings that can hold a lot of69edical supplies. Alt+click to open and close."
	rarity_value = 30

//////////////////////////////////////////Engineering//////////////////////////////////////////

/obj/item/storage/hcases/engi
	name = "tool hard case"
	desc = "A hardcase with engineering69arkings that can hold a69ariety of different tools and69aterials. Alt+click to open and close."
	icon_state = "hcase_engi"
	matter = list(MATERIAL_STEEL = 20)
	spawn_blacklisted = FALSE
	rarity_value = 60

	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/cell,
		/obj/item/electronics/circuitboard,
		/obj/item/stack/material,
		/obj/item/material,
		/obj/item/tool,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/device/radio/headset,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/taperoll/engineering,
		/obj/item/device/robotanalyzer,
		/obj/item/tool/minihoe,
		/obj/item/tool/hatchet,
		/obj/item/device/scanner/plant,
		/obj/item/extinguisher/mini,
		/obj/item/hand_labeler,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses,
		/obj/item/flame/lighter,
		/obj/item/cell/small,
		/obj/item/cell/medium
		)

/obj/item/storage/hcases/engi/scrap
	icon_state = "scrap_engi"
	sticker_name = "scrap"
	desc = "An old lac69uer coated hardcase with engineering69arkings that can hold a69ariety of different tools and69aterials. Alt+click to open and close."
	rarity_value = 30
