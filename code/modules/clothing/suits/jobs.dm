/*
 * Job related
 */

//vagabond
/obj/item/clothing/suit/storage/ass_jacket
	name = "assistant jacket"
	desc = "Practical and comfortable jacket. It seems have a little protection from physical harm."
	icon_state = "ass_jacket"
	item_state = "ass_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

//Club Artist
/obj/item/clothing/suit/artist
	name = "Complicated Vest"
	desc = "The tubes don't even do anything."
	icon_state = "artist"
	item_state = "artist_armor"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(
		ARMOR_BLUNT = 1,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	spawn_frequency = 0

//Guild Technician
/obj/item/clothing/suit/storage/cargo_jacket
	name = "guild technician jacket"
	desc = "An orange and grey jacket, a hybrid of a hazard vest and a proper jacket."
	icon_state = "cargo_jacket"
	item_state = "cargo_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

/obj/item/clothing/suit/storage/cargo_jacket/black
	name = "black guild technician jacket"
	desc = "A black stylish jacket. Used by guild technicians."
	icon_state = "cargo_jacket_black"
	item_state = "cargo_jacket_black"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

/obj/item/clothing/suit/storage/cargo_jacket/black/old
	name = "old guild technician jacket"
	desc = "An older version of the guild tech coat, still used occasionally."
	icon_state = "cargo_jacket_old"
	item_state = "cargo_jacket_old"

//Merchant
/obj/item/clothing/suit/storage/qm_coat
	name = "guild merchant coat"
	desc = "A grungy brown coat, perfect for a smuggler."
	icon_state = "qm_coat"
	item_state = "qm_coat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	siemens_coefficient = 0.8

/*/obj/item/clothing/suit/storage/qm_coat/old
	name = "old brown guild coat"
	desc = "One of the old merchant coat designs, passed down to technicians after it fell out of fashion."
	icon_state = "qm_coat_old"
	item_state = "qm_coat_old"*/

//Botanist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic yellow apron."
	icon_state = "apron"
	item_state = "apron"
	blood_overlay_type = "armor"
	body_parts_covered = 0
	spawn_blacklisted = TRUE
	extra_allowed = list(
		/obj/item/seeds,
		/obj/item/reagent_containers/glass/fertilizer,
		/obj/item/weedkiller
	)

//Club
/obj/item/clothing/suit/storage/toggle/club
	name = "manager's jacket"
	desc = "A well tailored and rich jacket of the club manager"
	icon_state = "cm_coat"
	item_state = "cm_coat"
	icon_open = "cm_coat_open"
	icon_closed = "cm_coat"
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7
	spawn_blacklisted = TRUE
	style = STYLE_HIGH

//Captain
/obj/item/clothing/suit/storage/captain
	name = "captain's coat"
	desc = "A very stylish black coat with fancy shoulder straps. Shows who the boss here."
	icon_state = "captain"
	item_state = "captain"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS
	spawn_blacklisted = TRUE
	rarity_value = 150
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	price_tag = 5000
	style = STYLE_HIGH
	armorComps = list(
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)


//NeoTheology
/obj/item/clothing/suit/storage/neotheology_jacket
	name = "acolyte jacket"
	desc = "A long jacket. Dark, stylish, and authoritarian."
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS
	spawn_blacklisted = TRUE
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =50,  //same as labcoats at LEAST
		ARMOR_RAD =0
	)

/obj/item/clothing/suit/storage/neotheology_jacket/black
	name = "black acolyte jacket"
	desc = "A long black jacket. Dark, stylish, and authoritarian."
	icon_state = "chaplain_hoodie_old"
	item_state = "chaplain_hoodie_old"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS
	spawn_blacklisted = TRUE
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =50,  //same as labcoats at LEAST
		ARMOR_RAD =0
	)

/obj/item/clothing/suit/storage/neotheology_coat
	name = "preacher coat"
	desc = "A snugly fitting, lightly armoured brown coat."
	icon_state = "church_coat"
	item_state = "church_coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_BIOMATTER = 20, MATERIAL_GOLD = 5)
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =0,
		ARMOR_BIO =50,  //same as labcoats at LEAST
		ARMOR_RAD =0
	)

/obj/item/clothing/suit/storage/neotheosports
	name = "NeoTheology sports jacket"
	desc = "NeoTheology styled sports jacket to keep the faithful always on their feet."
	icon_state = "nt_sportsjacket"
	item_state = "nt_sportsjacket"
	body_parts_covered = UPPER_TORSO|ARMS
	style_coverage = COVERS_CHEST|COVERS_UPPER_ARMS
	spawn_blacklisted = TRUE
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon_state = "nun"
	item_state = "nun"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	style_coverage = COVERS_WHOLE_LEGS|COVERS_TORSO|COVERS_UPPER_ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	spawn_blacklisted = TRUE

//Chef
/obj/item/clothing/suit/chef
	name = "chef's apron"
	desc = "An apron used by a high class chef."
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.9
	permeability_coefficient = 0.5
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS
	style = STYLE_HIGH
	spawn_blacklisted = TRUE

//Chef
/obj/item/clothing/suit/chef/classic
	name = "classic chef's apron."
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	body_parts_covered = 0
	spawn_blacklisted = TRUE

//Inspector
/obj/item/clothing/suit/storage/detective
	name = "inspector's grey armored trenchcoat"
	desc = "Grey armored trenchcoat, designed and created by Ironhammer Security. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	icon_state = "detective_gray"
	item_state = "detective_gray"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	style_coverage = COVERS_TORSO|COVERS_UPPER_ARMS|COVERS_UPPER_LEGS
	armor = list(
		ARMOR_BLUNT = 7,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	siemens_coefficient = 0.8
	price_tag = 250
	style = STYLE_HIGH
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/detective/brown
	name = "inspector's brown armored trenchcoat"
	desc = "Brown armored trenchcoat, designed and created by Ironhammer Security. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	icon_state = "detective_brown"
	item_state = "detective_brown"

/obj/item/clothing/suit/storage/detective/black
	name = "inspector's black armored trenchcoat"
	desc = "Black armored trenchcoat, designed and created by Ironhammer Security. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	icon_state = "detective_black"
	item_state = "detective_black"

//Technomancers
/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
	blood_overlay_type = "armor"
	extra_allowed = list(/obj/item/tool)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	price_tag = 50

/obj/item/clothing/suit/storage/hazardvest/orange
	icon_state = "hazard_orange"
	item_state = "hazard_orange"

//Paramedics
/obj/item/clothing/suit/storage/hazardvest/black
	icon_state = "hazard_black"
	item_state = "hazard_black"

//Technomancer Exultant
/obj/item/clothing/suit/storage/te_coat
	name = "exultant coat"
	desc = "A sturdy and proud crimson coat. Lightly armored, with some protection against radiation."
	icon_state = "te_coat"
	item_state = "te_coat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	spawn_blacklisted = TRUE
	armor = list(
		ARMOR_BLUNT = 7,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =10
	)
	price_tag = 250

//Roboticist
/obj/item/clothing/suit/storage/robotech_jacket
	name = "robotech jacket"
	desc = "Jacket for those who like to get dirty in a machine oil."
	icon_state = "robotech_jacket"
	item_state = "robotech_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	price_tag = 50
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

/obj/item/clothing/suit/storage/surgical_apron
	name = "surgical apron"
	desc = "Excellent blood collector."
	icon_state = "surgeon"
	item_state = "surgeon"
	blood_overlay_type = "armor"
	spawn_blacklisted = TRUE
	extra_allowed = list(
		/obj/item/tool/bonesetter,
		/obj/item/tool/cautery,
		/obj/item/tool/saw/circular,
		/obj/item/tool/hemostat,
		/obj/item/tool/retractor,
		/obj/item/tool/scalpel,
		/obj/item/tool/surgicaldrill,
		/obj/item/stack/medical/advanced/bruise_pack
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	price_tag = 50
