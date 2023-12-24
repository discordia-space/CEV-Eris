#define THIEF_MASK_SANITY_COEFF_BUFF 1.6
#define NORMAL_MASK_SANITY_COEFF_BUFF 1.3

/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	body_parts_covered = FACE
	style_coverage = COVERS_MOUTH
	volumeClass = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	voicechange = 1
	style_coverage = COVERS_MOUTH
	style = STYLE_LOW//yes

/obj/item/clothing/mask/muzzle/tape
	name = "length of tape"
	desc = "A robust DIY muzzle!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state = null
	volumeClass = ITEM_SIZE_TINY

/obj/item/clothing/mask/muzzle/New()
    ..()
    say_messages = list("Mmfph!", "Mmmf mrrfff!", "Mmmf mnnf!")
    say_verbs = list("mumbles", "says")

// Clumsy folks can't take the mask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/user as mob)
	if(user.wear_mask == src && !user.IsAdvancedToolUser())
		return 0
	..()

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	volumeClass = ITEM_SIZE_SMALL
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =0,
		ARMOR_BIO =75,
		ARMOR_RAD =0
	)
	price_tag = 10
	style_coverage = COVERS_MOUTH

/obj/item/clothing/mask/surgical/New()
	..()
	AddComponent(/datum/component/clothing_sanity_protection, NORMAL_MASK_SANITY_COEFF_BUFF)

/obj/item/clothing/mask/thief
	name = "mastermind's mask"
	desc = "A white mask with some strange drawings. Designed to hide the wearer's face"
	icon_state = "dallas"
	flags_inv = HIDEFACE
	volumeClass = ITEM_SIZE_SMALL
	body_parts_covered = FACE
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	price_tag = 150
	style_coverage = COVERS_WHOLE_FACE

/obj/item/clothing/mask/thief/New()
	..()
	AddComponent(/datum/component/clothing_sanity_protection, THIEF_MASK_SANITY_COEFF_BUFF)

/obj/item/clothing/mask/thief/wolf
	name = "technician's mask"
	icon_state = "wolf"

/obj/item/clothing/mask/thief/hoxton
	name = "fugitive's mask"
	icon_state = "hoxton"

/obj/item/clothing/mask/thief/chains
	name = "enforcer's mask"
	icon_state = "chains"

//Adminbus versions with extremly high armor, should never spawn in game
/obj/item/clothing/mask/thief/adminspawn
	spawn_blacklisted = TRUE
	body_parts_covered = HEAD|FACE
	armor = list(
		ARMOR_BLUNT = 15,
		ARMOR_BULLET = 16,
		ARMOR_ENERGY = 15,
		ARMOR_BOMB =75,
		ARMOR_BIO =100,
		ARMOR_RAD =30
	)

/obj/item/clothing/mask/thief/adminspawn/wolf
	name = "technician's mask"
	icon_state = "wolf"

/obj/item/clothing/mask/thief/adminspawn/hoxton
	name = "fugitive's mask"
	icon_state = "hoxton"

/obj/item/clothing/mask/thief/adminspawn/chains
	name = "enforcer's mask"
	icon_state = "chains"

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv = HIDEFACE
	body_parts_covered = 0
	style_coverage = COVERS_MOUTH

/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	flags_inv = HIDEFACE
	body_parts_covered = 0
	style_coverage = COVERS_WHOLE_FACE

//scarves (fit in in mask slot)
/obj/item/clothing/mask/scarf
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "blue_scarf"
	item_state = "blue_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	volumeClass = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	price_tag = 50
	style = STYLE_LOW
	style_coverage = COVERS_MOUTH

/obj/item/clothing/mask/scarf/stripedblue
	name = "striped blue scarf"
	desc = "A striped blue scarf."
	icon_state = "stripedbluescarf"
	item_state = "stripedbluescarf"

/obj/item/clothing/mask/scarf/red
	name = "red scarf"
	desc = "A red neck scarf."
	icon_state = "red_scarf"
	item_state = "red_scarf"

/obj/item/clothing/mask/scarf/stripedred
	name = "striped red scarf"
	desc = "A striped red scarf."
	icon_state = "stripedredscarf"
	item_state = "stripedredscarf"

/obj/item/clothing/mask/scarf/redwhite
	name = "checkered scarf"
	desc = "A red and white checkered neck scarf."
	icon_state = "redwhite_scarf"
	item_state = "redwhite_scarf"

/obj/item/clothing/mask/scarf/green
	name = "green scarf"
	desc = "A green neck scarf."
	icon_state = "green_scarf"
	item_state = "green_scarf"

/obj/item/clothing/mask/scarf/stripedgreen
	name = "striped green scarf"
	desc = "A striped green scarf."
	icon_state = "stripedgreenscarf"
	item_state = "stripedgreenscarf"

/obj/item/clothing/mask/scarf/ninja
	name = "ninja scarf"
	desc = "A stealthy, ominous scarf."
	icon_state = "ninja_scarf"
	item_state = "ninja_scarf"
	siemens_coefficient = 0

/obj/item/clothing/mask/scarf/style
	name = "black scarf"
	desc = "A stylish, black scarf."
	icon_state = "blackscarf"
	item_state = "blackscarf"
	style = STYLE_HIGH
	price_tag = 100

/obj/item/clothing/mask/scarf/style/bluestyle
	name = "blue scarf"
	desc = "A stylish, blue scarf."
	icon_state = "bluescarf"
	item_state = "bluescarf"

/obj/item/clothing/mask/scarf/style/yellowstyle
	name = "yellow scarf"
	desc = "A stylish, yellow scarf."
	icon_state = "yellowscarf"
	item_state = "yellowscarf"

/obj/item/clothing/mask/scarf/style/redstyle
	name = "red scarf"
	desc = "A stylish, red scarf."
	icon_state = "redscarf"
	item_state = "redscarf"

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags_inv = HIDEFACE|BLOCKHAIR
	volumeClass = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES
	style_coverage = COVERS_WHOLE_HEAD
	muffle_voice = TRUE

/obj/item/clothing/mask/pig/New()
	..()
	AddComponent(/datum/component/clothing_sanity_protection, NORMAL_MASK_SANITY_COEFF_BUFF)

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	volumeClass = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9
	style_coverage = COVERS_WHOLE_HEAD
	muffle_voice = TRUE

/obj/item/clothing/mask/horsehead/New()
	..()
	// The horse mask doesn't cause voice changes by default, the wizard spell changes the flag as necessary
	say_messages = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	say_verbs = list("whinnies", "neighs", "says")
	AddComponent(/datum/component/clothing_sanity_protection, NORMAL_MASK_SANITY_COEFF_BUFF)


/obj/item/clothing/mask/ai
	name = "camera MIU"
	desc = "Allows for direct mental connection to accessible camera networks."
	icon_state = "s-ninja"
	item_state = "s-ninja"
	flags_inv = HIDEFACE
	body_parts_covered = 0
	var/mob/observer/eye/aiEye/eye
	spawn_blacklisted = TRUE
	style_coverage = COVERS_WHOLE_FACE
	style = STYLE_NEG_HIGH

/obj/item/clothing/mask/ai/Initialize(mapload, ...)
	. = ..()
	eye = new(src)

/obj/item/clothing/mask/ai/equipped(var/mob/user, var/slot)
	..(user, slot)
	if(slot == slot_wear_mask)
		eye.owner = user
		user.eyeobj = eye

		for(var/datum/chunk/c in eye.visibleChunks)
			c.remove(eye)
		eye.setLoc(user)

/obj/item/clothing/mask/ai/dropped(var/mob/user)
	..()
	if(eye.owner == user)
		for(var/datum/chunk/c in eye.visibleChunks)
			c.remove(eye)

		eye.owner.eyeobj = null
		eye.owner = null

// Bandanas below
/obj/item/clothing/mask/bandana
	name = "black bandana"
	desc = "A fine bandana with nanotech lining. Can be worn on the head or face."
	flags_inv = HIDEFACE
	slot_flags = SLOT_MASK|SLOT_HEAD
	body_parts_covered = FACE
	icon_state = "bandblack"
	item_state = "bandblack"
	item_flags = FLEXIBLEMATERIAL
	volumeClass = ITEM_SIZE_SMALL
	price_tag = 20
	style = STYLE_LOW
	muffle_voice = TRUE

/obj/item/clothing/mask/bandana/equipped(var/mob/user, var/slot)
	switch(slot)
		if(slot_wear_mask) //Mask is the default for all the settings
			flags_inv = HIDEFACE
			body_parts_covered = FACE
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			style_coverage = COVERS_MOUTH|COVERS_FACE
		if(slot_head)
			flags_inv = 0
			body_parts_covered = HEAD
			icon_state = "[initial(icon_state)]_up"
			item_state = "[initial(item_state)]_up"
			style_coverage = COVERS_HAIR

	return ..()

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	icon_state = "bandred"
	item_state = "bandred"

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	icon_state = "bandblue"
	item_state = "bandblue"

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	icon_state = "bandgreen"
	item_state = "bandgreen"

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	icon_state = "bandgold"
	item_state = "bandgold"

/obj/item/clothing/mask/bandana/orange
	name = "orange bandana"
	icon_state = "bandorange"
	item_state = "bandorange"

/obj/item/clothing/mask/bandana/purple
	name = "purple bandana"
	icon_state = "bandpurple"
	item_state = "bandpurple"

/obj/item/clothing/mask/bandana/botany
	name = "botany bandana"
	icon_state = "bandbotany"
	item_state = "bandbotany"

/obj/item/clothing/mask/bandana/camo
	name = "camo bandana"
	icon_state = "bandcamo"
	item_state = "bandcamo"

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "A fine black bandana with nanotech lining and a skull emblem. Can be worn on the head or face."
	icon_state = "bandskull"
	item_state = "bandskull"

/obj/item/clothing/mask/gnome
	name = "tactical beard"
	desc = "The fancy looking beard."
	icon_state = "gnome_beard"
	item_state = "gnome_beard"
	flags_inv = HIDEFACE
	body_parts_covered = 0
	style = STYLE_HIGH
	style_coverage = COVERS_MOUTH|COVERS_FACE
