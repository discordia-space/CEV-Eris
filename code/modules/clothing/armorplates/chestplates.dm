/obj/item/armor_component/plate/steel
	name = "steel armor plate"
	desc = "when weight isn't an issue."
	weight = 1800
	maxArmorHealth = 2000
	armorHealth = 2000
	armor = list(
		ARMOR_BLUNT = 8,
		ARMOR_SLASH = 6,
		ARMOR_POINTY = 5,
		ARMOR_BULLET = 8,
		ARMOR_ENERGY = 2,
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
	matter = list(MATERIAL_STEEL = 5)

/obj/item/armor_component/plate/plasteel
	name = "plasteel armor plate"
	desc = "i like my steel with a little bit of plasma"
	weight = 1700
	maxArmorHealth = 2000
	armorHealth = 2000
	armor = list(
		ARMOR_BLUNT = 12,
		ARMOR_SLASH = 8,
		ARMOR_POINTY = 6,
		ARMOR_BULLET = 14,
		ARMOR_ENERGY = 4,
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
	matter = list(MATERIAL_PLASTEEL = 8)

/obj/item/armor_component/plate/ablative
	name = "ablative armor plate"
	desc = "the disco star is here"
	weight = 1200
	maxArmorHealth = 2000
	armorHealth = 2000
	armor = list(
		ARMOR_BLUNT = 3,
		ARMOR_SLASH = 3,
		ARMOR_POINTY = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 15,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 1,
		ARMOR_SLASH = 0.2,
		ARMOR_POINTY = 1,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 0.3,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_GOLD = 3, MATERIAL_SILVER = 1, MATERIAL_GLASS = 2)

/obj/item/armor_component/plate/ceramic
	name = "ceramic armor plate"
	desc = "pottery is great at blocking bullets"
	weight = 800
	armorFlags = CF_ARMOR_CUSTOM_VALS | CF_ARMOR_CUSTOM_DEGR | CF_ARMOR_CUSTOM_INTEGRITY | CF_ARMOR_CUSTOM_WEIGHT | CF_ARMOR_DEG_EXPONENTIAL
	maxArmorHealth = 2000
	armorHealth = 2000
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_SLASH = 15,
		ARMOR_POINTY = 15,
		ARMOR_BULLET = 15,
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
	matter = list(MATERIAL_GLASS = 3, MATERIAL_PLASMA = 1, MATERIAL_CLOTH = 1)

/obj/item/armor_component/plate/panzer
	name = "panzer carapace"
	desc = "can be used as an armor plate"
	weight = 2400
	maxArmorHealth = 2000
	armorHealth = 2000
	armor = list(
		ARMOR_BLUNT = 12,
		ARMOR_SLASH = 8,
		ARMOR_POINTY = 8,
		ARMOR_BULLET = 12,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 1,
		ARMOR_SLASH = 1,
		ARMOR_POINTY = 2,
		ARMOR_BULLET = 1.3,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_BIOMATTER = 30, MATERIAL_STEEL = 2)

/obj/item/armor_component/plate/fuhrer
	name = "fuhrer carapace"
	desc = "can be used as an armor plate"
	weight = 1500
	maxArmorHealth = 1000
	armorHealth = 1000
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_SLASH = 5,
		ARMOR_POINTY = 5,
		ARMOR_BULLET = 10,
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
	matter = list(MATERIAL_BIOMATTER = 20)

/obj/item/armor_component/plate/kaiser
	name = "kaiser carapace"
	desc = "can be used as an armor plate.."
	weight = 1200
	maxArmorHealth = 2000
	armorHealth = 2000
	armor = list(
		ARMOR_BLUNT = 10,
		ARMOR_SLASH = 10,
		ARMOR_POINTY = 10,
		ARMOR_BULLET = 15,
		ARMOR_ENERGY = 10,
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
	matter = list(MATERIAL_DIAMOND = 1, MATERIAL_BIOMATTER = 45, MATERIAL_GOLD = 3)

/obj/item/armor_component/plate/plastic
	name = "plastic armor plate"
	desc = "preety unreactive to damage in general"
	weight = 1000
	maxArmorHealth = 2000
	armorHealth = 2000
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
	matter = list(MATERIAL_PLASTIC = 8)

/obj/item/armor_component/plate/excelalloy
	name = "excelsior armor plate"
	desc = "a communist mix of plastic , steel and hard labour. Manufactured using excelsior secrets."
	weight = 1600
	maxArmorHealth = 2000
	armorHealth = 2000
	armor = list(
		ARMOR_BLUNT = 13,
		ARMOR_SLASH = 13,
		ARMOR_POINTY = 13,
		ARMOR_BULLET = 18,
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
	matter = list(MATERIAL_PLASTIC = 10, MATERIAL_STEEL = 8)

/obj/item/armor_component/plate/kevlar
	name = "kevlar armor plate"
	desc = "a very tight bundle of cloth fibers"
	weight = 1500
	maxArmorHealth = 1500
	armorHealth = 1500
	armor = list(
		ARMOR_BLUNT = 4,
		ARMOR_SLASH = 15,
		ARMOR_POINTY = 4,
		ARMOR_BULLET = 15,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 0,
		ARMOR_SLASH = 1.3,
		ARMOR_POINTY = 2,
		ARMOR_BULLET = 1.3,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_CLOTH = 30)

/obj/item/armor_component/plate/neojute
	name = "neojute armor plate"
	desc = "corporate secrets have never been so protective"
	weight = 1000
	maxArmorHealth = 1500
	armorHealth = 1500
	armor = list(
		ARMOR_BLUNT = 7,
		ARMOR_SLASH = 7,
		ARMOR_POINTY = 7,
		ARMOR_BULLET = 6,
		ARMOR_ENERGY = 6,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 1,
		ARMOR_SLASH = 1,
		ARMOR_POINTY = 1,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_GLASS = 5, MATERIAL_PLASTEEL = 1, MATERIAL_PLASTIC = 3)

/obj/item/armor_component/plate/carrion
	name = "carrion carapace"
	desc = "i always thought spiders were meant to be squishy"
	weight = 1000
	maxArmorHealth = 4500
	armorHealth = 4500
	armor = list(
		ARMOR_BLUNT = 20,
		ARMOR_SLASH = 5,
		ARMOR_POINTY = 10,
		ARMOR_BULLET = 20,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	armorDegradation = list(
		ARMOR_BLUNT = 0.3,
		ARMOR_SLASH = 1.3,
		ARMOR_POINTY = 1,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	matter = list(MATERIAL_BIOMATTER = 70)
