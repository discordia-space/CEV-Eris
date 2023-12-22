/obj/item/armor_component/sideguards/steel
	name = "Steel Leg & Arm guards"
	desc = "Ankles and hips of STEEL"
	icon_state = "steel_sg"
	volume = 1
	weight = 1000
	maxArmorHealth = 500
	armorHealth = 500
	armor = list(
		ARMOR_BLUNT = 12,
		ARMOR_SLASH = 12,
		ARMOR_POINTY = 7,
		ARMOR_BULLET = 15,
		ARMOR_ENERGY = 5,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 0.5,
		ARMOR_SLASH = 0.3,
		ARMOR_POINTY = 1.4,
		ARMOR_BULLET = 1.4,
		ARMOR_ENERGY = 1,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 2,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_STEEL = 2)

/obj/item/armor_component/sideguards/plasteel
	name = "Plasteel Leg & Arm guards"
	desc = "The plasteel doesn't feel plastic at all.."
	icon_state = "plasteel_sg"
	weight = 1300
	maxArmorHealth = 700
	armorHealth = 700
	armor = list(
		ARMOR_BLUNT = 16,
		ARMOR_SLASH = 16,
		ARMOR_POINTY = 10,
		ARMOR_BULLET = 20,
		ARMOR_ENERGY = 10,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 50,
		ARMOR_RAD = 10
	)
	armorDegradation = list(
		ARMOR_BLUNT = 0.5,
		ARMOR_SLASH = 0.3,
		ARMOR_POINTY = 0.9,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 1,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 1.4,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_PLASTEEL = 3)

/obj/item/armor_component/sideguards/albative
	name = "Ablative Leg & Arm guards"
	desc = "Mirrors for your ankles"
	icon_state = "ablative_sg"
	weight = 400
	maxArmorHealth = 400
	armorHealth = 400
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_SLASH = 5,
		ARMOR_POINTY = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 30,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 1,
		ARMOR_SLASH = 0.2,
		ARMOR_POINTY = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 0.3,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_GOLD = 1, MATERIAL_SILVER = 0.25, MATERIAL_GLASS = 1)

/obj/item/armor_component/sideguards/ceramic
	name = "Ceramic Leg & Arm guards"
	desc = "Make sure it doesn't crack"
	icon_state = "ceramic_sg"
	weight = 200
	armorFlags = CF_ARMOR_CUSTOM_VALS | CF_ARMOR_CUSTOM_DEGR | CF_ARMOR_CUSTOM_INTEGRITY | CF_ARMOR_CUSTOM_WEIGHT | CF_ARMOR_DEG_EXPONENTIAL
	maxArmorHealth = 300
	armorHealth = 300
	armor = list(
		ARMOR_BLUNT = 10,
		ARMOR_SLASH = 20,
		ARMOR_POINTY = 50,
		ARMOR_BULLET = 50,
		ARMOR_ENERGY = 5,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 2,
		ARMOR_SLASH = 0.5,
		ARMOR_POINTY = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_GLASS = 1, MATERIAL_PLASMA = 0.25, MATERIAL_CLOTH = 1)

/obj/item/armor_component/sideguards/fuhrer
	name = "Fuhrer limb carapace"
	desc = "The armor that used to coat his legs"
	icon_state = "fuhrer_sg"
	weight = 500
	maxArmorHealth = 500
	armorHealth = 500
	armor = list(
		ARMOR_BLUNT = 10,
		ARMOR_SLASH = 10,
		ARMOR_POINTY = 10,
		ARMOR_BULLET = 15,
		ARMOR_ENERGY = 5,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 1,
		ARMOR_SLASH = 1,
		ARMOR_POINTY = 1.4,
		ARMOR_BULLET = 1.4,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_BIOMATTER = 5)

/obj/item/armor_component/sideguards/kaiser
	name = "Kaiser limb carapace"
	desc = "The carapace that coated the kaiser's enormous legs. Its heavy"
	icon_state = "kaiser_sg"
	weight =  700
	maxArmorHealth = 1000
	armorHealth = 1000
	armor = list(
		ARMOR_BLUNT = 20,
		ARMOR_SLASH = 20,
		ARMOR_POINTY = 15,
		ARMOR_BULLET = 25,
		ARMOR_ENERGY = 15,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 0.7,
		ARMOR_SLASH = 0.5,
		ARMOR_POINTY = 1,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_DIAMOND = 0.25, MATERIAL_BIOMATTER = 10, MATERIAL_GOLD = 1)

/obj/item/armor_component/sideguards/plastic
	name = "Plastic Leg & Arm sideguards"
	desc = "Won't react much when you fall down"
	icon_state = "plastic_sg"
	weight = 200
	maxArmorHealth = 1000
	armorHealth = 1000
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_SLASH = 5,
		ARMOR_POINTY = 3,
		ARMOR_BULLET = 3,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 50,
		ARMOR_CHEM = 100,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 1,
		ARMOR_SLASH = 0.7,
		ARMOR_POINTY = 1.3,
		ARMOR_BULLET = 1.3,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_PLASTIC = 2)

/obj/item/armor_component/sideguards/excelalloy
	name = "Excelsior Leg & Arm sideguards"
	desc = "Communist protection for communist legs and arms"
	icon_state = "excelalloy_sg"
	weight = 600
	maxArmorHealth = 600
	armorHealth = 600
	armor = list(
		ARMOR_BLUNT = 15,
		ARMOR_SLASH = 15,
		ARMOR_POINTY = 5,
		ARMOR_BULLET = 25,
		ARMOR_ENERGY = 10,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 1,
		ARMOR_SLASH = 0.4,
		ARMOR_POINTY = 2,
		ARMOR_BULLET = 1.4,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_PLASTIC = 3, MATERIAL_STEEL = 2)



