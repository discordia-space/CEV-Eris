// Stuff that shouldn't be faked by chameleons, mostly bad_type's and bst gear
GLOBAL_LIST_INIT(chameleon_blacklist, list(
	/obj/item/clothing/under/assistantformal/bst,
	/obj/item/device/radio/headset/ert/bst,
	/obj/item/storage/backpack/holding/bst,
	/obj/item/clothing/shoes/color/black/bst,
	/obj/item/clothing/glasses/sunglasses/bst,
	/obj/item/storage/belt/utility/full/bst,
	/obj/item/clothing/gloves/color/white/bst,
	/obj/item/gun,
	/obj/item/gun/projectile,
	/obj/item/gun/energy,
	/obj/item/clothing,
	/obj/item/clothing/ears,
	/obj/item/clothing/glasses,
	/obj/item/clothing/gloves,
	/obj/item/clothing/head,
	/obj/item/clothing/mask,
	/obj/item/clothing/shoes,
	/obj/item/clothing/suit,
	/obj/item/clothing/under,
	/obj/item/clothing/under/rank,
	/obj/item/clothing/under/color,
	/obj/item/clothing/accessory,
	/obj/item/clothing/glasses/hud,
	/obj/item/clothing/gloves/color,
	/obj/item/clothing/head/armor,
	/obj/item/clothing/head/surgery,
	/obj/item/clothing/head/collectable,
	/obj/item/clothing/suit/space,
	/obj/item/clothing/head/space,
	/obj/item/clothing/suit/armor/laserproof,
	/obj/item/clothing/suit/storage/vest,
	/obj/item/clothing/suit/storage,
	/obj/item/clothing/suit/storage/toggle))


GLOBAL_LIST_INIT(chameleon_key_to_path, list(
	"uniform" = /obj/item/clothing/under,
	"hat" = /obj/item/clothing/head,
	"suit" = /obj/item/clothing/suit,
	"shoes" = /obj/item/clothing/shoes,
	"back" = /obj/item/storage/backpack,
	"gloves" = /obj/item/clothing/gloves,
	"mask" = /obj/item/clothing/mask,
	"glasses" = /obj/item/clothing/glasses,
	"gun" = /obj/item/gun,
	"headset" = /obj/item/device/radio/headset))


/obj/item/proc/set_chameleon_appearance()
	set name = "Change Chameleon Appearance"
	set category = "Object"
	set src in usr

	pick_disguise(usr)


/obj/item/proc/pick_disguise(mob/user)
	var/list/options = generate_chameleon_choices(isgun(src) ? /obj/item/gun : parent_type)
	var/obj/item/I = input(user, "Available options", "Set appearance") as anything in options
	if(I)
		disguise(options[I], usr)


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
	item_state_slots = copy.item_state_slots?.Copy()
	update_wear_icon()

	if(istype(copy, /obj/item/clothing))
		var/obj/item/clothing/C = copy
		src:style_coverage = C.style_coverage

	return copy


/proc/generate_chameleon_choices(basetype)
	. = list()

	var/i = 1 // For cases when there is a collision with both name AND icon_state
	for(var/typepath in subtypesof(basetype) - GLOB.chameleon_blacklist)
		var/obj/O = typepath
		if(initial(O.icon) && initial(O.icon_state))
			var/name = initial(O.name)
			if(name in .)
				name += " ([initial(O.icon_state)])"
			if(name in .)
				name += " \[[i++]\]"
			.[name] = typepath


/obj/item/clothing/under/chameleon
	name = "black jumpsuit"
	desc = "A plain jumpsuit. It seems to have a small dial on the wrist."
	icon_state = "black"
	item_state = "bl_suit"
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_CLOTHING_UNDER_CHAMELEON
	chameleon_type = "uniform"

	var/list/loadout_1 = list(
	uniform = /obj/item/clothing/under/rank/assistant,
	hat = /obj/item/clothing/head/hardhat,
	suit = /obj/item/clothing/suit/storage/ass_jacket,
	shoes = /obj/item/clothing/shoes/reinforced,
	back = /obj/item/storage/backpack/satchel,
	gloves = /obj/item/clothing/gloves/thick,
	mask = /obj/item/clothing/mask/smokable/cigarette,
	glasses = /obj/item/clothing/glasses/sunglasses,
	gun = /obj/item/gun/projectile/boltgun/serbian,
	headset = /obj/item/device/radio/headset)

	var/list/loadout_2 = list(
	uniform = /obj/item/clothing/under/rank/security,
	hat = /obj/item/clothing/head/armor/helmet/ironhammer,
	suit = /obj/item/clothing/suit/armor/vest/full/ironhammer,
	shoes = /obj/item/clothing/shoes/jackboots/ironhammer,
	back = /obj/item/storage/backpack/satchel/security,
	gloves = /obj/item/clothing/gloves/stungloves,
	mask = /obj/item/clothing/mask/balaclava/tactical,
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical,
	gun = /obj/item/gun/projectile/automatic/sol,
	headset = /obj/item/device/radio/headset/headset_sec)

	var/list/loadout_3 = list(
	uniform = /obj/item/clothing/under/rank/scientist,
	hat = /obj/item/clothing/head/bandana/orange,
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science,
	shoes = /obj/item/clothing/shoes/jackboots,
	back = /obj/item/storage/backpack/satchel/purple/scientist,
	gloves = /obj/item/clothing/gloves/thick,
	mask = /obj/item/clothing/mask/gas,
	glasses = /obj/item/clothing/glasses/powered/science,
	gun = /obj/item/gun/energy/lasercannon,
	headset =/obj/item/device/radio/headset/headset_sci)

	var/list/loadout_4 = list(
	uniform = /obj/item/clothing/under/rank/acolyte,
	hat = /obj/item/clothing/head/armor/acolyte,
	suit = /obj/item/clothing/suit/armor/acolyte,
	shoes = /obj/item/clothing/shoes/reinforced,
	back = /obj/item/storage/backpack/satchel/neotheology,
	gloves = /obj/item/clothing/gloves/thick,
	mask = /obj/item/clothing/mask/scarf/red,
	glasses = /obj/item/clothing/glasses/sunglasses,
	gun = /obj/item/gun/energy/laser,
	headset = /obj/item/device/radio/headset/church)


/obj/item/clothing/under/chameleon/emp_act(severity)
	name = "psychedelic"
	desc = "Groovy!"
	icon_state = "psyche"
	item_state_slots[slot_w_uniform_str] = "psyche"
	update_icon()
	update_wear_icon()


/obj/item/clothing/under/chameleon/proc/set_loadout_slot(slot, loadout)
	var/options = generate_chameleon_choices(GLOB.chameleon_key_to_path[slot])
	var/obj/item/I = input("Available options", "Set appearance") in options
	if(I)
		loadout[slot] = options[I]


/obj/item/clothing/under/chameleon/proc/disguise_as_loadout(mob/user, loadout)
	for(var/obj/item/I in user.contents)
		if(I.chameleon_type)
			I.disguise(loadout[I.chameleon_type], user)


/obj/item/clothing/under/chameleon/nano_ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/nano_topic_state/state)
	var/list/data = list()
	var/list/clothes_in_loadout = list()

	var/current_loadout = 1
	for(var/list/loadout in list(loadout_1, loadout_2, loadout_3, loadout_4))
		for(var/slot in loadout)
			var/K = loadout[slot]
			var/obj/item/copy = new K (null)
			clothes_in_loadout += list(list(
					"name" = copy.name,
					"slot" = slot,
					"loadout" = current_loadout))
		current_loadout++
	data["clothes_in_loadout"] = clothes_in_loadout

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chameleon.tmpl", "Chameleon clothing", 1100, 400)
		ui.set_initial_data(data)
		ui.open()


/obj/item/clothing/under/chameleon/Topic(href, href_list)
	if(href_list["set_clothing_1"])
		set_loadout_slot(href_list["set_clothing_1"], loadout_1)
	if(href_list["set_clothing_2"])
		set_loadout_slot(href_list["set_clothing_2"], loadout_2)
	if(href_list["set_clothing_3"])
		set_loadout_slot(href_list["set_clothing_3"], loadout_3)
	if(href_list["set_clothing_4"])
		set_loadout_slot(href_list["set_clothing_4"], loadout_4)
	SSnano.update_uis(src)
	..()


/obj/item/clothing/under/chameleon/verb/configure_loadouts()
	set name = "Configure loadouts"
	set category = "Object"
	set src in usr.contents

	nano_ui_interact(usr)


/obj/item/clothing/under/chameleon/verb/disguise_as_loadout_1()
	set name = "Disguise as loadout 1"
	set category = "Object"
	set src in usr.contents

	disguise_as_loadout(usr, loadout_1)


/obj/item/clothing/under/chameleon/verb/disguise_as_loadout_2()
	set name = "Disguise as loadout 2"
	set category = "Object"
	set src in usr.contents

	disguise_as_loadout(usr, loadout_2)


/obj/item/clothing/under/chameleon/verb/disguise_as_loadout_3()
	set name = "Disguise as loadout 3"
	set category = "Object"
	set src in usr.contents

	disguise_as_loadout(usr, loadout_3)


/obj/item/clothing/under/chameleon/verb/disguise_as_loadout_4()
	set name = "Disguise as loadout 4"
	set category = "Object"
	set src in usr.contents

	disguise_as_loadout(usr, loadout_4)


/obj/item/clothing/head/chameleon
	name = "grey cap"
	icon_state = "greysoft"
	desc = "It looks like a plain hat, but upon closer inspection, there's an advanced holographic array installed inside. It seems to have a small dial inside."
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_CLOTHING_HEAD_CHAMELEON
	chameleon_type = "hat"

/obj/item/clothing/suit/chameleon
	name = "armor"
	icon_state = "armor"
	item_state = "armor"
	desc = "It appears to be a vest of standard armor, except this is embedded with a hidden holographic cloaker, allowing it to change it's appearance, but offering no protection.. It seems to have a small dial inside."
	spawn_blacklisted = TRUE
	chameleon_type = "suit"

/obj/item/clothing/shoes/chameleon
	name = "black shoes"
	icon_state = "black"
	item_state = "black"
	desc = "They're comfy black shoes, with clever cloaking technology built in. It seems to have a small dial on the back of each shoe."
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_SHOES_CHAMELEON
	chameleon_type = "shoes"

/obj/item/storage/backpack/chameleon //functionally a satchel
	name = "grey satchel"
	icon_state = "satchel"
	desc = "A satchel outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	max_storage_space = DEFAULT_HUGE_STORAGE * 0.7
	worn_access = TRUE
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_BACKPACK_CHAMELEON
	rarity_value = 50
	chameleon_type = "back"

/obj/item/clothing/gloves/chameleon
	name = "black gloves"
	icon_state = "black"
	item_state = "bgloves"
	desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_GLOVES_CHAMELEON
	chameleon_type = "gloves"

/obj/item/clothing/mask/chameleon
	name = "gas mask"
	icon_state = "gas_alt"
	item_state = "gas_alt"
	desc = "It looks like a plain gask mask, but on closer inspection, it seems to have a small dial inside."
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_MASK_CONTRABAND
	flags_inv = HIDEEYES|HIDEFACE
	chameleon_type = "mask"
	style_coverage = COVERS_WHOLE_FACE

/obj/item/clothing/glasses/chameleon
	name = "Optical Meson Scanner"
	icon_state = "meson"
	item_state = "glasses"
	desc = "It looks like a plain set of mesons, but on closer inspection, it seems to have a small dial inside."
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_GLASSES_CHAMELEON
	chameleon_type = "glasses"

/obj/item/device/radio/headset/chameleon
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys. There is a dial on the side to change the headset's disguise."
	icon_state = "headset"
	item_state = "headset"
	spawn_blacklisted = TRUE
	chameleon_type = "headset"

/obj/item/gun/energy/chameleon
	name = "FS HG .40 Magnum \"Avasarala\""
	desc = "A hologram projector in the shape of a gun. There is a dial on the side to change the gun's disguise."
	icon = 'icons/obj/guns/projectile/avasarala.dmi'
	icon_state = "avasarala"
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_GUN_ENERGY_CHAMELEON
	rarity_value = 25
	chameleon_type = "gun"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	projectile_type = /obj/item/projectile/chameleon
	charge_meter = FALSE
	charge_cost = 20


/obj/item/gun/energy/chameleon/disguise(newtype, mob/user)
	var/obj/item/gun/copy = ..()

	fire_sound = copy?.fire_sound
	fire_sound_text = copy?.fire_sound_text

	if(istype(copy, /obj/item/gun/energy))
		var/obj/item/gun/energy/G = new copy.type(null)
		projectile_type = G.projectile_type

	else if(istype(copy, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/G = new copy.type(null)
		if(G.ammo_type)
			var/obj/item/ammo_casing/AC = new G.ammo_type(null)
			projectile_type = AC.projectile_type ? AC.projectile_type : initial(projectile_type)
		else
			projectile_type = initial(projectile_type)


/obj/item/gun/energy/chameleon/consume_next_projectile()
	if(..())
		var/obj/item/projectile/chameleon/C = new(null)
		var/obj/item/projectile/P = new projectile_type(null)
		C.name = P.name
		C.icon = P.icon
		C.icon_state = P.icon_state
		C.pass_flags = P.pass_flags
		C.hitscan = P.hitscan
		C.muzzle_type = P?.muzzle_type
		C.tracer_type = P?.tracer_type
		C.impact_type = P?.impact_type
		return C


/obj/item/gun/energy/chameleon/emp_act(severity)
	. = ..()
	name = initial(name)
	desc = initial(desc)
	icon = initial(icon)
	icon_state = initial(icon_state)
	fire_sound = initial(fire_sound)
	fire_sound_text = initial(fire_sound)
	projectile_type = initial(projectile_type)


/obj/item/gun/energy/chameleon/verb/change_serials()
	set name = "Change Serial Number"
	set category = "Object"
	set src in usr

	var/new_serial = input(usr, "Cancel for it to appear scribbled", "Input a new serial code") as text|null
	serial_type = new_serial
