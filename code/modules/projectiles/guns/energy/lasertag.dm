/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	item_state = "laser"
	desc = "Standard-issue weapon of the Imperial Guard"
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	self_recharge = TRUE
	matter = list(MATERIAL_PLASTIC = 6)
	fire_sound = 'sound/weapons/Laser.ogg'
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	bad_type = /obj/item/gun/energy/lasertag
	spawn_tags = SPAWN_TAG_TOY_WEAPON
	rarity_value = 30
	var/re69uired_vest

/obj/item/gun/energy/lasertag/special_check(mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, re69uired_vest))
			to_chat(M, SPAN_WARNING("You69eed to be wearing your laser tag69est!"))
			return 0
	return ..()

/obj/item/gun/energy/lasertag/blue
	icon = 'icons/obj/guns/energy/bluetag.dmi'
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	re69uired_vest = /obj/item/clothing/suit/bluetag

/obj/item/gun/energy/lasertag/red
	icon = 'icons/obj/guns/energy/redtag.dmi'
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lastertag/red
	re69uired_vest = /obj/item/clothing/suit/redtag
