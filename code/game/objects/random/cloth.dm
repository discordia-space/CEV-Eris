//CLOTH RANDOM
/obj/spawner/cloth
	name = "debug: random cloth"
	tags_to_spawn = list(SPAWN_CLOTHING)
	bad_type = /obj/spawner/cloth

/obj/spawner/cloth/masks
	name = "random mask"
	desc = "This is a random mask."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_MASK)

/obj/spawner/cloth/masks/low_chance
	name = "low chance random mask"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/armor
	name = "random armor"
	desc = "This is a random armor."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_ARMOR)

/obj/spawner/cloth/armor/low_chance
	name = "low chance random armor"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/suit
	name = "random suit"
	desc = "This is a random suit."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_SUIT_STORAGE, SPAWN_CLOTHING_SUIT_PONCHO)

/obj/spawner/cloth/suit/low_chance
	name = "low chance random suit"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/hazmatsuit
	name = "random hazmat suit"
	desc = "This is a random hazmat suit."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_HAZMATSUIT)

/obj/spawner/cloth/hazmatsuit/low_chance
	name = "low chance random hazmat suit"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/under
	name = "random under"
	desc = "This is a random under."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_UNDER)

/obj/spawner/cloth/under/low_chance
	name = "low chance random under"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/helmet
	name = "random helmet"
	desc = "This is a random helmet."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_HEAD_HELMET)

/obj/spawner/cloth/helmet/low_chance
	name = "low chance random helmet"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/head
	name = "random head"
	desc = "This is a random head."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_HEAD)
	restricted_tags = list(SPAWN_CLOTHING_HEAD_HELMET)

/obj/spawner/cloth/head/low_chance
	name = "low chance random head"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/gloves
	name = "random gloves"
	desc = "This is a random gloves."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_GLOVES)

/obj/spawner/cloth/gloves/low_chance
	name = "low chance random gloves"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/glasses
	name = "random glasses"
	desc = "This is a random glasses."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_GLASSES)

/obj/spawner/cloth/glasses/low_chance
	name = "low chance random glasses"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/shoes
	name = "random shoes"
	desc = "This is a random pair of shoes."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_SHOES)

/obj/spawner/cloth/shoes/low_chance
	name = "low chance random shoes"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/backpack
	name = "random backpack"
	desc = "This is a random backpack"
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_BACKPACK)

/obj/spawner/cloth/backpack/low_chance
	name = "low chance random backpack"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/belt
	name = "random belt"
	desc = "This is a random belt."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_BELT)

/obj/spawner/cloth/belt/low_chance
	name = "low chance random belt"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/holster
	name = "random holster"
	desc = "This is a random holster."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_HOLSTER)

/obj/spawner/cloth/holster/low_chance
	name = "low chance random holster"
	desc = "This is a random holster."
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60
