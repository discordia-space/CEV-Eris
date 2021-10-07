/obj/item/storage/hcases //probably should rename
	name = "hard case"
	desc = "A hardcase that can hold a lot of various things. Alt+click to open and close."
	icon = 'icons/obj/cases.dmi'
	icon_state = "hcase"
	var/sticker_name = "hcase"
	//item_state = "case_small" //TODO

	w_class = ITEM_SIZE_NORMAL
	//storage_slots = null
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_SMALL_STORAGE * 1.5 //a better fancy box
	matter = list(MATERIAL_STEEL = 20)
	spawn_blacklisted = TRUE //This shouldn't spawn randomly
	rarity_value = 10
	spawn_tags = SPAWN_TAG_POUCH
	bad_type = /obj/item/storage
	var/sticker = null
	var/closed = TRUE

/obj/item/storage/hcases/verb/apply_sticker()
	set name = "Apply Sticker"
	set category = "Object"
	set src in view(1)

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return
	sticker(usr)

/obj/item/storage/hcases/proc/sticker(usr)
	var/list/options = list()
	options["Orange"] = "[sticker_name]_sticker_o"
	options["Blue"] = "[sticker_name]_sticker_b"
	options["Red"] = "[sticker_name]_sticker_r"
	options["Green"] = "[sticker_name]_sticker_g"
	options["Purple"] = "[sticker_name]_sticker_p"
	options["IH Blue"] = "[sticker_name]_sticker_ih"


	var/choice = input(usr,"What color do you want?") as null|anything in options

	sticker = options[choice]
	update_icon()

/obj/item/storage/hcases/on_update_icon()
	icon_state = "[initial(icon_state)][closed ? "" : "_open"]"
	cut_overlays()
	if(sticker)
		add_overlays("[sticker][closed ? "" : "_open"]")

/obj/item/storage/hcases/open(mob/user)
	if(closed)
		to_chat(usr, SPAN_NOTICE("The lid is closed."))
		return
//		if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained()) //removed because it doesn't play nicely with bags
//			return
//		open_close(usr)

	. = ..()

/obj/item/storage/hcases/verb/quick_open_close()
	set name = "Close Lid"
	set category = "Object"
	set src in view(1)

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return

	open_close(usr)

/obj/item/storage/hcases/AltClick(mob/user)

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return

	if(istype(src.loc, /obj/item/storage))
		to_chat(usr, SPAN_NOTICE("The lid on the [src] gets caught on the bag."))
		return

	open_close(usr)

/obj/item/storage/hcases/proc/open_close(usr)
	close_all()
	if(closed)
		to_chat(usr, SPAN_NOTICE("You open the lid on the [src]."))
		w_class = ITEM_SIZE_BULKY
		closed = FALSE
	else
		to_chat(usr, SPAN_NOTICE("You close the lid on the [src]."))
		w_class = ITEM_SIZE_NORMAL
		closed = TRUE

	playsound(src.loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
	update_icon()


obj/item/storage/hcases/attackby(obj/item/W, mob/user)
	if(closed)
		to_chat(usr, SPAN_NOTICE("You try but the lid is closed."))
		return
	. = ..()


/obj/item/storage/hcases/scrap	//Scrap isn't worse beyond poor shaming
	icon_state = "scrap"
	sticker_name = "scrap"
	desc = "A lacquer coated hardcase that can hold a lot of various things. Alt+click to open and close."

//////////////////////////////////////////Ammo//////////////////////////////////////////

/obj/item/storage/hcases/ammo
	name = "ammo hard case"
	desc = "A generic ammo can. Can hold ammo magazines, boxes, and bullets. Alt+click to open and close."
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
	desc = "An ammo can for Ironhammer. Can hold ammo magazines, boxes, and bullets. Alt+click to open and close."

/obj/item/storage/hcases/ammo/serb
	icon_state = "ammo_case_serb"
	desc = "An ammo can made by the Serbs. Can hold ammo magazines, boxes, and bullets. Alt+click to open and close."

/obj/item/storage/hcases/ammo/blackmarket
	icon_state = "ammo_case_blackmarket"
	desc = "A shady looking ammo can. Can hold ammo magazines, boxes, and bullets. Alt+click to open and close."

/obj/item/storage/hcases/ammo/excel
	icon_state = "ammo_case_excel"
	desc = "A communist ammo can! Can hold ammo magazines, boxes, and bullets. Alt+click to open and close."


/obj/item/storage/hcases/ammo/scrap
	icon_state = "ammo_case_scrap"
	desc = "A lacquer coated ammo can. Can hold ammo magazines, boxes, and bullets. Alt+click to open and close."
	rarity_value = 30


//////////////////////////////////////////Parts//////////////////////////////////////////

/obj/item/storage/hcases/parts
	name = "parts hard case"
	desc = "A hard case that can hold weapon, armor, machine, and electronic parts. Alt+click to open and close."
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
	desc = "A lacquer coated hard case that can hold weapon, armor, machine, and electronic parts. Alt+click to open and close."
	rarity_value = 30

//////////////////////////////////////////Medical//////////////////////////////////////////

/obj/item/storage/hcases/med
	name = "medical hard case"
	desc = "A hardcase with medical markings that can hold a lot of medical supplies. Alt+click to open and close."
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
		/obj/item/clothing/glasses/hud/health,
		)

/obj/item/storage/hcases/med/scrap
	icon_state = "scrap_medi"
	sticker_name = "scrap"
	desc = "A lacquer coated hardcase with medical markings that can hold a lot of medical supplies. Alt+click to open and close."
	rarity_value = 30

//////////////////////////////////////////Engineering//////////////////////////////////////////

/obj/item/storage/hcases/engi
	name = "tool hard case"
	desc = "A hardcase with engineering markings that can hold a variaty of different tools and materials. Alt+click to open and close."
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
	desc = "An old lacquer coated hardcase with engineering markings that can hold a variaty of different tools and materials. Alt+click to open and close."
	rarity_value = 30
