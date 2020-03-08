/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	item_state = "egloves"
	price_tag = 500

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "robohands"
	item_state = "r_hands"
	siemens_coefficient = 1

/obj/item/clothing/gloves/insulated
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	price_tag = 200

/obj/item/clothing/gloves/insulated/cheap                          //Cheap Chinese Crap
	desc = "These gloves are cheap copies of the coveted gloves, no way this can end badly."
	name = "budget insulated gloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in New()
	permeability_coefficient = 0.05
	price_tag = 50

/obj/item/clothing/gloves/insulated/cheap/New()
	//average of 0.5, somewhat better than regular gloves' 0.75
	siemens_coefficient = pick(0,0.1,0.3,0.5,0.5,0.75,1.35)

/obj/item/clothing/gloves/thick
	desc = "These work gloves are thick and fire-resistant."
	name = "black gloves"
	icon_state = "black"
	item_state = "bgloves"
	siemens_coefficient = 0.5
	permeability_coefficient = 0.05
	price_tag = 100

	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = ARMS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/security
	desc = "Padded security gloves."
	name = "security gloves"
	icon_state = "security"
	item_state = "combat"
	siemens_coefficient = 0.5
	permeability_coefficient = 0.05
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = ARMS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	price_tag = 100

/obj/item/clothing/gloves/security/ironhammer
	name = "operator's gloves"
	icon_state = "security_ironhammer"
	item_state = "combat"

/obj/item/clothing/gloves/security/tactical
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "tactical gloves"
	icon_state = "security"
	item_state = "swat_gl"
	siemens_coefficient = 0
	price_tag = 500

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 1.0 //thin latex gloves, much more conductive than fabric gloves (basically a capacitor for AC)
	permeability_coefficient = 0.01
	germ_level = 0
	price_tag = 50

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
