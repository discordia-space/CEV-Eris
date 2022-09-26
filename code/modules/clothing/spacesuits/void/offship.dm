//space for voidsuits found in exploration. mainly onestar
/obj/item/clothing/head/space/void/onestar
	name = "Onestar Voidsuit Helmet"
	desc = "a lightweight bubble helmet providing unrestricted vision and protection from space with a light on top. the glass is plasma reinforced and could easily stop a rifle round"
	icon_state = "onestar_void"
	item_state = "onestar_void"
	armor = list(
		melee = 14,
		bullet = 14,
		energy = 14,
		bomb = 75,
		bio = 100,
		rad = 100
	)
	siemens_coefficient = 0.35
	light_overlay = "helmet_light_green"
	obscuration = LIGHT_OBSCURATION

/obj/item/clothing/suit/space/void/onestar
	name = "Onestar Voidsuit"
	desc = "A Onestar industrial voidsuit produced in large numbers "
	icon_state = "onestar_void"
	item_state = "onestar_void"
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	armor = list(
		melee = 14,
		bullet = 14,
		energy = 14,
		bomb = 75,
		bio = 100,
		rad = 100
	)
	siemens_coefficient = 0.35
	breach_threshold = 10
	resilience = 0.07
	helmet = /obj/item/clothing/head/space/void/onestar
	spawn_blacklisted = TRUE
	slowdown = MEDIUM_SLOWDOWN
	stiffness = LIGHT_STIFFNESS
