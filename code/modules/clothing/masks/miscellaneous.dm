#define THIEF_MASK_SANITY_COEFF_BUFF 1.6
#define NORMAL_MASK_SANITY_COEFF_BUFF 1.3

/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	body_parts_covered = FACE
	style_coverage = COVERS_MOUTH
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	voicechange = 1
	style_coverage = COVERS_MOUTH
	style = STYLE_LOW//yes

/obj/item/clothing/mask/muzzle/tape
	name = "length of tape"
	desc = "A robust DIY69uzzle!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state = null
	w_class = ITEM_SIZE_TINY

/obj/item/clothing/mask/muzzle/New()
    ..()
    say_messages = list("Mmfph!", "Mmmf69rrfff!", "Mmmf69nnf!")
    say_verbs = list("mumbles", "says")

// Clumsy folks can't take the69ask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/user as69ob)
	if(user.wear_mask == src && !user.IsAdvancedToolUser())
		return 0
	..()

/obj/item/clothing/mask/surgical
	name = "sterile69ask"
	desc = "A sterile69ask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 75,
		rad = 0
	)
	price_tag = 10
	style_coverage = COVERS_MOUTH

/obj/item/clothing/mask/surgical/New()
	..()
	AddComponent(/datum/component/clothing_sanity_protection, NORMAL_MASK_SANITY_COEFF_BUFF)

/obj/item/clothing/mask/thief
	name = "mastermind's69ask"
	desc = "A white69ask with some strange drawings. Designed to hide the wearer's face"
	icon_state = "dallas"
	flags_inv = HIDEFACE
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = FACE
	armor = list(
		melee = 10,
		bullet = 10,
		energy = 10,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	price_tag = 150
	style_coverage = COVERS_WHOLE_FACE

/obj/item/clothing/mask/thief/New()
	..()
	AddComponent(/datum/component/clothing_sanity_protection, THIEF_MASK_SANITY_COEFF_BUFF)

/obj/item/clothing/mask/thief/wolf
	name = "technician's69ask"
	icon_state = "wolf"

/obj/item/clothing/mask/thief/hoxton
	name = "fugitive's69ask"
	icon_state = "hoxton"

/obj/item/clothing/mask/thief/chains
	name = "enforcer's69ask"
	icon_state = "chains"

//Adminbus69ersions with extremly high armor, should never spawn in game
/obj/item/clothing/mask/thief/adminspawn
	spawn_blacklisted = TRUE
	body_parts_covered = HEAD|FACE
	armor = list(
		melee = 60,
		bullet = 65,
		energy = 60,
		bomb = 75,
		bio = 100,
		rad = 30
	)

/obj/item/clothing/mask/thief/adminspawn/wolf
	name = "technician's69ask"
	icon_state = "wolf"

/obj/item/clothing/mask/thief/adminspawn/hoxton
	name = "fugitive's69ask"
	icon_state = "hoxton"

/obj/item/clothing/mask/thief/adminspawn/chains
	name = "enforcer's69ask"
	icon_state = "chains"

/obj/item/clothing/mask/fakemoustache
	name = "fake69oustache"
	desc = "Warning:69oustache is fake."
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

//scarves (fit in in69ask slot)
/obj/item/clothing/mask/scarf
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "blue_scarf"
	item_state = "blue_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
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
	name = "pig69ask"
	desc = "A rubber pig69ask."
	icon_state = "pig"
	item_state = "pig"
	flags_inv = HIDEFACE|BLOCKHAIR
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES
	style_coverage = COVERS_WHOLE_HEAD

/obj/item/clothing/mask/pig/New()
	..()
	AddComponent(/datum/component/clothing_sanity_protection, NORMAL_MASK_SANITY_COEFF_BUFF)

/obj/item/clothing/mask/horsehead
	name = "horse head69ask"
	desc = "A69ask69ade of soft69inyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9
	style_coverage = COVERS_WHOLE_HEAD

/obj/item/clothing/mask/horsehead/New()
	..()
	// The horse69ask doesn't cause69oice changes by default, the wizard spell changes the flag as necessary
	say_messages = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	say_verbs = list("whinnies", "neighs", "says")
	AddComponent(/datum/component/clothing_sanity_protection, NORMAL_MASK_SANITY_COEFF_BUFF)


/obj/item/clothing/mask/ai
	name = "camera69IU"
	desc = "Allows for direct69ental connection to accessible camera networks."
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

/obj/item/clothing/mask/ai/equipped(var/mob/user,69ar/slot)
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
	w_class = ITEM_SIZE_SMALL
	price_tag = 20
	style = STYLE_LOW

/obj/item/clothing/mask/bandana/equipped(var/mob/user,69ar/slot)
	switch(slot)
		if(slot_wear_mask) //Mask is the default for all the settings
			flags_inv = HIDEFACE
			body_parts_covered = FACE
			icon_state = initial(icon_state)
			style_coverage = COVERS_MOUTH|COVERS_FACE
		if(slot_head)
			flags_inv = 0
			body_parts_covered = HEAD
			icon_state = "69initial(icon_state)69_up"
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
