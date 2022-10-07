/obj/item/clothing/gloves/captain
	desc = "Black gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	item_state = "egloves"
	armor = list(
		melee = 6,
		bullet = 2,
		energy = 6,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	price_tag = 500
	style = STYLE_HIGH

/obj/item/clothing/gloves/insulated
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "yellow"
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 3,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	price_tag = 200
	spawn_tags = SPAWN_TAG_GLOVES_INSULATED
	style = STYLE_NEG_HIGH // very powergame much unstylish... literal power this time

/obj/item/clothing/gloves/insulated/cheap                          //Cheap Chinese Crap
	desc = "These gloves are cheap copies of the coveted gloves, no way this can end badly."
	name = "budget insulated gloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in New()
	permeability_coefficient = 0.05
	price_tag = 50

/obj/item/clothing/gloves/insulated/cheap/Initialize(mapload, ...)
	. = ..()
	//average of 0.5, somewhat better than regular gloves' 0.75
	siemens_coefficient = pick(0,0.1,0.3,0.5,0.5,0.75,1.35)

/obj/item/clothing/gloves/thick
	desc = "These work gloves are thick and fire-resistant."
	name = "black gloves"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0.5
	permeability_coefficient = 0.05
	armor = list(
		melee = 5,
		bullet = 0,
		energy = 5,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	price_tag = 100

	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = ARMS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/security
	name = "security gloves"
	desc = "Padded security gloves."
	icon_state = "security"
	item_state = "security"
	siemens_coefficient = 0.5
	permeability_coefficient = 0.05
	armor = list(
		melee = 6,
		bullet = 1,
		energy = 5,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = ARMS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	price_tag = 100

/obj/item/clothing/gloves/security/ironhammer
	name = "operator's gloves"
	icon_state = "security_ironhammer"
	item_state = "security_ironhammer"
	spawn_blacklisted = TRUE

/obj/item/clothing/gloves/security/tactical
	name = "tactical gloves"
	desc = "These tactical gloves are somewhat fire and impact resistant."
	icon_state = "security_tactical"
	item_state = "security_tactical"
	siemens_coefficient = 0
	price_tag = 500

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "latex"
	item_state = "latex"
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	siemens_coefficient = 1 //thin latex gloves, much more conductive than fabric gloves (basically a capacitor for AC)
	permeability_coefficient = 0.01
	germ_level = 0
	price_tag = 50

/obj/item/clothing/gloves/latex/nitrile
	name = "nitrile gloves"
	desc = "Sterile nitrile gloves."
	icon_state = "nitrile"
	item_state = "nitrile"
	spawn_blacklisted = TRUE

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.05
	siemens_coefficient = 0.50 //thick work gloves
	price_tag = 50

/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	desc = "Plain black gloves without fingertips for the hard working."
	icon_state = "fingerless"
	item_state = "fingerless"
	clipped = TRUE
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = ARMS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	price_tag = 10

/obj/item/clothing/gloves/aerostatic
	name = "red designed leather gloves"
	desc = "Elegant leather gloves without fingertips."
	icon_state = "aerostatic_gloves"
	item_state = "aerostatic_gloves"
	clipped = TRUE
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = ARMS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	price_tag = 10

/obj/item/clothing/gloves/german
	name = "Oberth Republic gloves"
	desc = "Brown gloves."
	icon_state = "germangloves"
	item_state = "germangloves"
	armor = list(
		melee = 2,
		bullet = 0,
		energy = 6,
		bomb = 0,
		bio = 0,
		rad = 0
	)

/obj/item/clothing/gloves/knuckles
	name = "knuckle gloves"
	desc = "Gloves with additional reinforcment on the knuckles."
	icon_state = "knuckles"
	item_state = "knuckles"
	style = STYLE_HIGH
	armor = list(
		melee = 4,
		bullet = 1,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	price_tag = 500

/obj/item/clothing/gloves/dusters
	name = "steel knuckle dusters"
	desc = "More pain for them, less for you."
	description_info = "Have to be worn in your gloves slot to increase your punch damage."
	icon_state = "dusters"
	item_state = "dusters"
	var/punch_increase = 5
	price_tag = 20

/obj/item/clothing/gloves/dusters/silver
	name = "silver knuckle dusters"
	desc = "More pain for them, more bling for you."
	icon_state = "dusters_silver"
	item_state = "dusters_silver"
	price_tag = 40
	style = STYLE_LOW

/obj/item/clothing/gloves/dusters/plasteel
	name = "plasteel knuckle dusters"
	desc = "More pain for them, now doubled."
	icon_state = "dusters_plasteel"
	item_state = "dusters_plasteel"
	punch_increase = 10
	price_tag = 60

/obj/item/clothing/gloves/dusters/gold
	name = "golden knuckle dusters"
	desc = "More pain for them, more style for you."
	icon_state = "dusters_gold"
	item_state = "dusters_gold"
	punch_increase = 10
	price_tag = 100
	style = STYLE_HIGH

/obj/item/clothing/gloves/dusters/platinum
	name = "spiked platinum knuckle dusters"
	desc = "Hurt like hell, and stylish as well."
	icon_state = "dusters_platinum"
	item_state = "dusters_platinum"
	punch_increase = 15
	price_tag = 120
	style = STYLE_HIGH

/obj/item/clothing/gloves/dusters/gloves
	name = "knuckle gloves"
	desc = "Gloves with additional reinforcment on the knuckles. \
	These have plasteel powder sewn into the knuckles, adding more kinetic energy to your punches."
	icon_state = "knuckles"
	item_state = "knuckles"
	punch_increase = 10
	style = STYLE_HIGH
	armor = list(
		melee = 4,
		bullet = 1,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	price_tag = 540

/obj/item/clothing/gloves/dusters/New()
	..()
	RegisterSignal(src, COMSIG_CLOTH_EQUIPPED, .proc/increase_punch_damage)
	RegisterSignal(src, COMSIG_CLOTH_DROPPED, .proc/decrease_punch_damage)

/obj/item/clothing/gloves/dusters/proc/increase_punch_damage(mob/living/carbon/human/user)
	if(istype(user))
		user.punch_damage_increase += punch_increase

/obj/item/clothing/gloves/dusters/proc/decrease_punch_damage(mob/living/carbon/human/user)
	if(istype(user))
		user.punch_damage_increase -= punch_increase
