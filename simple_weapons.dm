//Hammers (hammer tool quality isnt in yet so they dont have tool qualities)

/obj/item/weapon/tool/homewrecker
	icon = 'icons/obj/weapons.dmi'
	icon_state = "homewrecker0"
	wielded_icon = "homewrecker1"
	name = "homewrecker"
	desc = "A large steel chunk welded to a long handle. Extremely heavy."
	sharp = 0
	edge = 0
	armor_penetration = ARMOR_PEN_EXTREME
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_NORMAL
	force_unwielded = WEAPON_FORCE_NORMAL
	force_wielded = WEAPON_FORCE_DANGEROUS
	attack_verb = list("attacked", "smashed", "bludgeoned", "beaten")
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
