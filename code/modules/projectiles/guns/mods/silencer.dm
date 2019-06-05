/obj/item/weapon/silencer
	name = "silencer"
	desc = "a threaded silencer that can be attached to the barrel of certain guns. Vastly reduces noise, but impedes muzzle velocity."
	icon = 'icons/obj/guns/mods.dmi'
	var/damage_mod = 0.1
	var/can_remove = TRUE
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 1)
	icon_state = "silencer"
	w_class = ITEM_SIZE_TINY
	price_tag = 500

//A silencer that comes built into certain guns. Cannot be removed, doesn't affect damage
/obj/item/weapon/silencer/integrated
	damage_mod = 0
	can_remove = FALSE