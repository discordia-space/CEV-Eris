//*****************
//**Cham Jumpsuit**
//*****************

/obj/item/proc/disguise(newtype, mob/user)
	if(!user || user.incapacitated())
		return
	//this is necessary, unfortunately, as initial() does not play well with list vars
	var/obj/item/copy = new newtype(null) //so that it is GCed once we exit

	desc = copy.desc
	name = copy.name
	icon = copy.icon
	icon_state = copy.icon_state
	item_state = copy.item_state
	body_parts_covered = copy.body_parts_covered
	flags_inv = copy.flags_inv

	item_icons = copy.item_icons.Copy()
	item_state_slots = copy.item_state_slots.Copy()
	//copying sprite_sheets_obj should be unnecessary as chameleon items are not refittable.
	update_wear_icon()

	return copy //for inheritance
obj/item/clothing/disguise(newtype, mob/user)
	. = ..()
	var/obj/item/clothing/copy = .
	if (istype(copy))
		style_coverage = copy.style_coverage

/proc/generate_chameleon_choices(basetype)
	. = list()

	var/i = 1 //in case there is a collision with both name AND icon_state
	var/is_item = FALSE
	if(istype(basetype, /obj/item))
		is_item = TRUE
	for(var/typepath in typesof(basetype))
		if(is_item)
			var/obj/item/K = typepath
			if(K.chameleon_slot)
				return
		var/obj/O = typepath
		if(initial(O.icon) && initial(O.icon_state))
			var/name = initial(O.name)
			if(name in .)
				name += " ([initial(O.icon_state)])"
			if(name in .)
				name += " \[[i++]\]"
			.[name] = typepath

/obj/item/clothing/under/chameleon
//starts off as black
	name = "black jumpsuit"
	desc = "A plain jumpsuit. It seems to have a small dial on the wrist."
	icon_state = "black"
	item_state = "bl_suit"
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_CLOTHING_UNDER_CHAMALEON
	chameleon_slot = "uniform"

	origin_tech = list(TECH_COVERT = 3)
	var/global/list/clothing_choices
	var/list/loadout_1 = list(uniform = /obj/item/clothing/under/rank/assistant,
	hat = /obj/item/clothing/head/hardhat,
	suit = /obj/item/clothing/suit/storage/ass_jacket,
	shoes = /obj/item/clothing/shoes/reinforced,
	back = /obj/item/storage/backpack/satchel,
	gloves = /obj/item/clothing/gloves/thick,
	mask = /obj/item/clothing/mask/smokable/cigarette,
	glasses = /obj/item/clothing/glasses/sunglasses,
	gun = /obj/item/gun/projectile/boltgun/serbian,
	headset = /obj/item/device/radio/headset)

	var/list/loadout_2 = list(uniform = /obj/item/clothing/under/rank/security,
	hat = /obj/item/clothing/head/armor/helmet/ironhammer,
	suit = /obj/item/clothing/suit/armor/vest/full/ironhammer,
	shoes = /obj/item/clothing/shoes/jackboots/ironhammer,
	back = /obj/item/storage/backpack/satchel/security,
	gloves = /obj/item/clothing/gloves/stungloves,
	mask = /obj/item/clothing/mask/balaclava/tactical,
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical,
	gun = /obj/item/gun/projectile/automatic/sol,
	headset = /obj/item/device/radio/headset/headset_sec)

	var/list/loadout_3 = list(uniform = /obj/item/clothing/under/rank/scientist,
	hat = /obj/item/clothing/head/bandana/orange,
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science,
	shoes = /obj/item/clothing/shoes/jackboots,
	back = /obj/item/storage/backpack/satchel/purple/scientist,
	gloves = /obj/item/clothing/gloves/thick,
	mask = /obj/item/clothing/mask/gas,
	glasses = /obj/item/clothing/glasses/powered/science,
	gun = /obj/item/gun/energy/lasercannon,
	headset =/obj/item/device/radio/headset/headset_sci)

	var/list/loadout_4 = list(uniform = /obj/item/clothing/under/rank/acolyte,
	hat = /obj/item/clothing/head/armor/acolyte,
	suit = /obj/item/clothing/suit/armor/acolyte,
	shoes = /obj/item/clothing/shoes/reinforced,
	back = /obj/item/storage/backpack/satchel/neotheology,
	gloves = /obj/item/clothing/gloves/thick,
	mask = /obj/item/clothing/mask/scarf/red,
	glasses = /obj/item/clothing/glasses/sunglasses,
	gun = /obj/item/gun/energy/laser,
	headset = /obj/item/device/radio/headset/church)

/obj/item/clothing/under/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/under)

/obj/item/clothing/under/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/clothing/under/chameleon/emp_act(severity)
	name = "psychedelic"
	desc = "Groovy!"
	icon_state = "psyche"
	item_state_slots[slot_w_uniform_str] = "psyche"
	update_icon()
	update_wear_icon()

/obj/item/clothing/under/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Jumpsuit Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//********************************************
//**Chameleon Jumpsuit loadout functionality**
//********************************************

/obj/item/clothing/under/chameleon/proc/set_single_loadout_slot(slot, loadout)
	var/chameleon_choices
	var/obj/item/item_to_disguise
	switch(slot)
		if("uniform")
			chameleon_choices = generate_chameleon_choices(/obj/item/clothing/under)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["uniform"] = chameleon_choices[item_to_disguise]
		if("hat")
			chameleon_choices = generate_chameleon_choices(/obj/item/clothing/head)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["hat"] = chameleon_choices[item_to_disguise]
		if("suit")
			chameleon_choices = generate_chameleon_choices(/obj/item/clothing/suit)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["suit"] = chameleon_choices[item_to_disguise]
		if("shoes")
			chameleon_choices = generate_chameleon_choices(/obj/item/clothing/shoes)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["shoes"] = chameleon_choices[item_to_disguise]
		if("back")
			chameleon_choices = generate_chameleon_choices(/obj/item/storage/backpack)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["back"] = chameleon_choices[item_to_disguise]
		if("gloves")
			chameleon_choices = generate_chameleon_choices(/obj/item/clothing/gloves)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["gloves"] = chameleon_choices[item_to_disguise]
		if("mask")	
			chameleon_choices = generate_chameleon_choices(/obj/item/clothing/mask)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["mask"] = chameleon_choices[item_to_disguise]
		if("glasses")
			chameleon_choices = generate_chameleon_choices(/obj/item/clothing/glasses)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["glasses"] = chameleon_choices[item_to_disguise]
		if("gun")
			chameleon_choices = generate_chameleon_choices(/obj/item/gun)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["gun"] = chameleon_choices[item_to_disguise]
		if("headset")
			chameleon_choices = generate_chameleon_choices(/obj/item/device/radio/headset)
			item_to_disguise = input("","Choose a disguise") in chameleon_choices
			loadout["headset"] = chameleon_choices[item_to_disguise]

/obj/item/clothing/under/chameleon/proc/disguise_as_loadout(mob/user, loadout)
	var/list/user_chameleon_items = list()
	for(var/obj/item/A in user.get_contents())
		if(A.chameleon_slot)
			user_chameleon_items += A
	var/list/ordered_list = list() //sadly neccessary because the suit and glasses need to be disguised before all other items, otherwise shoes and glasses will appear invisible.
	for(var/obj/item/I in user_chameleon_items)
		if(istype(obj/item/clothing/suit/chameleon))
			ordered_list += I
		else if(istype(obj/item/clothing/glasses_chameleon))
			ordered_list += I
	user_chameleon_items -= ordered_list
	ordered_list += user_chameleon_items
	for(var/obj/item/U in ordered_list)
		disguise(loadout[U.chameleon_slot], user)

/obj/item/clothing/under/chameleon/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = list()

	var/list/loadouts = list()
	loadouts += list(loadout_1, loadout_2, loadout_3, loadout_4)

	var/list/clothes_in_loadout = list()
	var/current_loadout = 1
	for(var/I in loadouts)
		var/list/S = I
		for(var/G in S)
			var/K = S[G]
			var/obj/item/copy = new K (null)
			clothes_in_loadout += list(
				list(
					"name" = copy.name,
					"slot" = G,
					"loadout" = current_loadout
				)
			)
		current_loadout++
	data["clothes_in_loadout"] = clothes_in_loadout

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chameleon.tmpl", "Chameleon clothing", 1000, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/item/clothing/under/chameleon/Topic(href, href_list)
	var/list/loadouts = list()
	var/slot
	loadouts += list(loadout_1, loadout_2, loadout_3, loadout_4)
	if(href_list["set_clothing_1"])
		slot = href_list["set_clothing_1"]
		set_single_loadout_slot(slot, loadout_1)
	if(href_list["set_clothing_2"])
		slot = href_list["set_clothing_2"]
		set_single_loadout_slot(slot, loadout_2)
	if(href_list["set_clothing_3"])
		slot = href_list["set_clothing_3"]
		set_single_loadout_slot(slot, loadout_3)
	if(href_list["set_clothing_4"])
		slot = href_list["set_clothing_4"]
		set_single_loadout_slot(slot, loadout_4)
	SSnano.update_uis(src)
	..()

/obj/item/clothing/under/chameleon/verb/configure_loadouts()
	set name = "Configure loadouts"
	set category = "Chameleon Items"
	set src in usr.contents

	ui_interact(usr)

/obj/item/clothing/under/chameleon/verb/disguise_as_loadout_1()
	set name = "Disguise as loadout 1"
	set category = "Chameleon Items"
	set src in usr.contents

	disguise_as_loadout(usr, loadout_1)


/obj/item/clothing/under/chameleon/verb/disguise_as_loadout_2()
	set name = "Disguise as loadout 2"
	set category = "Chameleon Items"
	set src in usr.contents

	disguise_as_loadout(usr, loadout_2)

/obj/item/clothing/under/chameleon/verb/disguise_as_loadout_3()
	set name = "Disguise as loadout 3"
	set category = "Chameleon Items"
	set src in usr.contents

	disguise_as_loadout(usr, loadout_3)

/obj/item/clothing/under/chameleon/verb/disguise_as_loadout_4()
	set name = "Disguise as loadout 4"
	set category = "Chameleon Items"
	set src in usr.contents

	disguise_as_loadout(usr, loadout_4)


//*****************
//**Chameleon Hat**
//*****************

/obj/item/clothing/head/chameleon
	name = "grey cap"
	icon_state = "greysoft"
	desc = "It looks like a plain hat, but upon closer inspection, there's an advanced holographic array installed inside. It seems to have a small dial inside."
	origin_tech = list(TECH_COVERT = 3)
	body_parts_covered = 0
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_CLOTHING_HEAD_CHAMALEON
	chameleon_slot = "hat"
	var/global/list/clothing_choices

/obj/item/clothing/head/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/head)

/obj/item/clothing/head/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/clothing/head/chameleon/emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
	name = "grey cap"
	desc = "A baseball hat in a tasteful grey colour."
	icon_state = "greysoft"
	update_icon()
	update_wear_icon()

/obj/item/clothing/head/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Hat/Helmet Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//******************
//**Chameleon Suit**
//******************

/obj/item/clothing/suit/chameleon
	name = "armor"
	icon_state = "armor"
	item_state = "armor"
	desc = "It appears to be a vest of standard armor, except this is embedded with a hidden holographic cloaker, allowing it to change it's appearance, but offering no protection.. It seems to have a small dial inside."
	origin_tech = list(TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	chameleon_slot = "suit"
	var/global/list/clothing_choices

/obj/item/clothing/suit/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/suit)

/obj/item/clothing/suit/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/clothing/suit/chameleon/emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
	name = "armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	update_icon()
	update_wear_icon()

/obj/item/clothing/suit/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Oversuit Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//*******************
//**Chameleon Shoes**
//*******************
/obj/item/clothing/shoes/chameleon
	name = "black shoes"
	icon_state = "black"
	item_state = "black"
	desc = "They're comfy black shoes, with clever cloaking technology built in. It seems to have a small dial on the back of each shoe."
	origin_tech = list(TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_SHOES_CHAMALEON
	chameleon_slot = "shoes"
	var/global/list/clothing_choices

/obj/item/clothing/shoes/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/shoes)

/obj/item/clothing/shoes/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/clothing/shoes/chameleon/emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
	name = "black shoes"
	desc = "A pair of black shoes."
	icon_state = "black"
	item_state = "black"
	update_icon()
	update_wear_icon()

/obj/item/clothing/shoes/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Footwear Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//**********************
//**Chameleon Backpack**
//**********************
/obj/item/storage/backpack/chameleon
	name = "grey backpack"
	icon_state = "backpack"
	item_state = "backpack"
	desc = "A backpack outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	origin_tech = list(TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_BACKPACK_CHAMALEON
	rarity_value = 50
	chameleon_slot = "back"
	var/global/list/clothing_choices

/obj/item/storage/backpack/chameleon/New()
	. = ..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/storage/backpack)

/obj/item/storage/backpack/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/storage/backpack/chameleon/emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
	name = "grey backpack"
	desc = "A backpack outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	icon_state = "backpack"
	item_state = "backpack"
	update_icon()
	update_wear_icon()

/obj/item/storage/backpack/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Backpack Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//**********************
//**Chameleon Satchel**
//**********************
/obj/item/storage/backpack/satchel/chameleon
	name = "grey satchel"
	icon_state = "satchel"
	desc = "A satchel outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	origin_tech = list(TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_BACKPACK_CHAMALEON
	rarity_value = 50
	chameleon_slot = "back"
	var/global/list/clothing_choices

/obj/item/storage/backpack/satchel/chameleon/New()
	. = ..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/storage/backpack)

/obj/item/storage/backpack/satchel/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/storage/backpack/satchel/chameleon/emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
	name = "grey satchel"
	desc = "A satchel outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	icon_state = "backpack"
	item_state = "backpack"
	update_icon()
	update_wear_icon()

/obj/item/storage/backpack/satchel/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Satchel Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//********************
//**Chameleon Gloves**
//********************

/obj/item/clothing/gloves/chameleon
	name = "black gloves"
	icon_state = "black"
	item_state = "bgloves"
	desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
	origin_tech = list(TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_GLOVES_CHAMALEON
	chameleon_slot = "gloves"
	var/global/list/clothing_choices

/obj/item/clothing/gloves/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/gloves)

/obj/item/clothing/gloves/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/clothing/gloves/chameleon/emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
	name = "black gloves"
	desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
	icon_state = "black"
	update_icon()
	update_wear_icon()

/obj/item/clothing/gloves/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Gloves Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//******************
//**Chameleon Mask**
//******************

/obj/item/clothing/mask/chameleon
	name = "gas mask"
	icon_state = "gas_alt"
	item_state = "gas_alt"
	desc = "It looks like a plain gask mask, but on closer inspection, it seems to have a small dial inside."
	origin_tech = list(TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_MASK_CONTRABAND
	flags_inv = HIDEEYES|HIDEFACE
	chameleon_slot = "mask"
	var/global/list/clothing_choices
	style_coverage = COVERS_WHOLE_FACE//default state

/obj/item/clothing/mask/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/mask)

/obj/item/clothing/mask/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/clothing/mask/chameleon/emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
	name = "gas mask"
	desc = "A gas mask."
	icon_state = "gas_alt"
	update_icon()
	update_wear_icon()

/obj/item/clothing/mask/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Mask Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//*********************
//**Chameleon Glasses**
//*********************

/obj/item/clothing/glasses/chameleon
	name = "Optical Meson Scanner"
	icon_state = "meson"
	item_state = "glasses"
	desc = "It looks like a plain set of mesons, but on closer inspection, it seems to have a small dial inside."
	origin_tech = list(TECH_COVERT = 3)
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_GLASSES_CHAMALEON
	chameleon_slot = "glasses"
	var/list/global/clothing_choices

/obj/item/clothing/glasses/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/glasses)

/obj/item/clothing/glasses/chameleon/Initialize(mapload, ...)
	. = ..()
	matter = list()
	matter.Add(list(MATERIAL_PLASTIC = 2 * w_class))

/obj/item/clothing/glasses/chameleon/emp_act(severity) //Because we don't have psych for all slots right now but still want a downside to EMP.  In this case your cover's blown.
	name = "Optical Meson Scanner"
	desc = "A set of mesons."
	icon_state = "meson"
	update_icon()
	update_wear_icon()

/obj/item/clothing/glasses/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Glasses Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

//*****************
//**Chameleon Gun**
//*****************
/obj/item/gun/energy/chameleon
	name = "FS HG .40 Magnum \"Avasarala\""
	desc = "A hologram projector in the shape of a gun. There is a dial on the side to change the gun's disguise."
	icon = 'icons/obj/guns/projectile/avasarala.dmi'
	icon_state = "avasarala"
	w_class = ITEM_SIZE_NORMAL
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_GUN_ENERGY_CHAMALEON
	rarity_value = 25
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_COVERT = 2)
	matter = list()
	chameleon_slot = "gun"

	fire_sound = 'sound/weapons/Gunshot.ogg'
	projectile_type = /obj/item/projectile/chameleon
	charge_meter = 0
	charge_cost = 20 //uses next to no power, since it's just holograms

	var/obj/item/projectile/copy_projectile
	var/global/list/gun_choices

/obj/item/gun/energy/chameleon/New()
	..()

	if(!gun_choices)
		gun_choices = list()
		for(var/gun_type in typesof(/obj/item/gun/) - src.type)
			var/obj/item/gun/G = gun_type
			src.gun_choices[initial(G.name)] = gun_type

/obj/item/gun/energy/chameleon/consume_next_projectile()
	var/obj/item/projectile/P = ..()
	if(P && ispath(copy_projectile))
		P.name = initial(copy_projectile.name)
		P.icon = initial(copy_projectile.icon)
		P.icon_state = initial(copy_projectile.icon_state)
		P.pass_flags = initial(copy_projectile.pass_flags)
		P.hitscan = initial(copy_projectile.hitscan)
		P.step_delay = initial(copy_projectile.step_delay)
		P.muzzle_type = initial(copy_projectile.muzzle_type)
		P.tracer_type = initial(copy_projectile.tracer_type)
		P.impact_type = initial(copy_projectile.impact_type)
	return P

/obj/item/gun/energy/chameleon/emp_act(severity)
	name = "FS HG .40 Magnum \"Avasarala\""
	desc = "A hologram projector in the shape of a gun. There is a dial on the side to change the gun's disguise."
	icon_state = "avasarala"
	update_icon()
	update_wear_icon()

/obj/item/gun/energy/chameleon/disguise(newtype)
	var/obj/item/gun/copy = ..()

	flags_inv = copy.flags_inv
	fire_sound = copy.fire_sound
	fire_sound_text = copy.fire_sound_text

	var/obj/item/gun/energy/E = copy
	if(istype(E))
		copy_projectile = E.projectile_type
		//charge_meter = E.charge_meter //does not work very well with icon_state changes, ATM
	else
		copy_projectile = null
		//charge_meter = 0

/obj/item/gun/energy/chameleon/verb/change(picked in gun_choices)
	set name = "Change Gun Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(gun_choices[picked]))
		return

	disguise(gun_choices[picked], usr)

//*****************
//**Chameleon Headset**
//*****************

/obj/item/device/radio/headset/chameleon
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys. There is a dial on the side to change the headset's disguise."
	icon_state = "headset"
	item_state = "headset"
	origin_tech = list(TECH_COVERT = 1)
	spawn_blacklisted = TRUE
	ks1type = null // No keys pre-installed
	chameleon_slot = "headset"
	var/list/global/clothing_choices

/obj/item/device/radio/headset/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/device/radio/headset)

/obj/item/device/radio/headset/chameleon/emp_act(severity)
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys"
	icon_state = "headset"
	update_icon()
	update_wear_icon()

/obj/item/device/radio/headset/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Headset Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
