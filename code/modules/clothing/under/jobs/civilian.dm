//Alphabetical order of civilian jobs.
/obj/item/clothing/under/rank/assistant
	desc = "Filled with hatred and envy."
	name = "assistant's uniform"
	icon_state = "assistant"
	item_state = "assistant"

/obj/item/clothing/under/rank/bartender
	desc = "Expensive shirt and tie with tailored pants."
	name = "bartender's uniform"
	icon_state = "ba_suit"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/bartender/skirt
	desc = "Expensive shirt and tie with a tailored skirt."
	name = "bartender's skirtsuit"
	icon_state = "ba_skirt"
	item_state = "ba_skirt"

/obj/item/clothing/under/rank/captain //Alright, technically not a 'civilian' but its better then giving a .dm file for a single define.
	desc = "It's a red jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "captain's jumpsuit"
	icon_state = "captain"
	item_state = "b_suit"

/obj/item/clothing/under/rank/cargotech
	name = "cargo worker's jumpsuit"
	desc = "It's a jeans and turtleneck worn by the cargo workers."
	icon_state = "cargotech"
	item_state = "lb_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/preacher
	desc = "Ceremonial garb of NeoTheologian preachers."
	name = "preacher vestments"
	icon_state = "preacher"
	item_state = "w_suit"

/obj/item/clothing/under/rank/acolyte
	desc = "Ceremonial garb of NeoTheologian disciples."
	name = "acolyte vestments"
	icon_state = "acolyte"
	item_state = "acolyte"

/obj/item/clothing/under/rank/church
	desc = "Smells like incense."
	name = "church vestments"
	icon_state = "church"
	item_state = "church"

/obj/item/clothing/under/rank/church/sport
	desc = "Smells like lilac."
	name = "church sports vestment"
	icon_state = "nt_sports"
	item_state = "nt_sports"

/obj/item/clothing/under/rank/chef
	desc = "It's an apron which is given only to the most <b>hardcore</b> chefs in space."
	name = "chef's uniform"
	icon_state = "chef"
	item_state = "w_suit"

/obj/item/clothing/under/rank/artist
	name = "Jester's Garments"
	desc = "The bright colors are almost distracting."
	icon_state = "artist"
	item_state = "artist"
	spawn_frequency = 0

/obj/item/clothing/under/rank/clown
	name = "clown suit"
	desc = "<i>'HONK!'</i>"
	icon_state = "clown"
	item_state = "clown"

/obj/item/clothing/under/rank/first_officer
	desc = "It's a jumpsuit worn by someone who works in the position of \"First Officer\"."
	name = "First Officer's jumpsuit"
	icon_state = "hop"
	item_state = "b_suit"

/obj/item/clothing/under/rank/hydroponics
	desc = "It's a jumpsuit designed to protect against minor plant-related hazards."
	name = "botanist's jumpsuit"
	icon_state = "hydroponics"
	item_state = "g_suit"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/janitor
	desc = "It's the official uniform of the ship's janitor."
	name = "janitor's jumpsuit"
	icon_state = "janitor"
	item_state = "janitor"
	permeability_coefficient = 0.50
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 10,
		rad = 0
	)

/obj/item/clothing/under/librarian
	name = "sensible suit"
	desc = "It's very... sensible."
	icon_state = "red_suit"
	item_state = "lawyer_red"

/obj/item/clothing/under/mime
	name = "mime's outfit"
	desc = "It's not very colourful."
	icon_state = "mime"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/miner
	desc = "It's a snappy jumpsuit with a sturdy set of overalls. It is very dirty."
	name = "guild miner's jumpsuit"
	icon_state = "miner"
	item_state = "lb_suit"
