/obj/item/weapon/material/harpoon
	name = "harpoon"
	sharp = 1
	edge = 1
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	armor_penetration = ARMOR_PEN_MODERATE
	force_divisor = 0.3 // 18 with hardness 60 (steel)
	attack_verb = list("jabbed","stabbed","ripped")

/obj/item/weapon/material/spear
	icon_state = "spearglass0"
	wielded_icon = "spearglass1"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	armor_penetration = ARMOR_PEN_MODERATE // It's a SPEAR!
	structure_damage_factor = STRUCTURE_DAMAGE_WEAK
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	force_divisor = 0.5         // 15 when unwielded 22.5 when wielded with hardness 30 (glass)
	thrown_force_divisor = 1.5 // 22 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 1
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = MATERIAL_GLASS
	embed_mult = 1.5

/obj/item/weapon/material/spear/update_force()
	..()
	force_unwielded = force
	force_wielded = force * 1.5