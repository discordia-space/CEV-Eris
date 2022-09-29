//voidsuits found in exploration. mainly onestar
/obj/item/clothing/head/space/void/onestar
	name = "Onestar Voidsuit Helmet"
	desc = "A lightweight bubble helmet providing unrestricted vision and protection from space with a light on top. The glass is plasma-reinforced and could easily stop a rifle round."
	icon_state = "onestar_void"
	item_state = "onestar_void"
	armor = list(
		melee = 14,
		bullet = 12,
		energy = 14,
		bomb = 75,
		bio = 100,
		rad = 100
	)
	siemens_coefficient = 0.35
	light_overlay = "helmet_light_dual"
	obscuration = LIGHT_OBSCURATION

/obj/item/clothing/suit/space/void/onestar
	name = "Onestar Voidsuit"
	desc = "A Onestar industrial voidsuit designed to be resistant to bluespace anomalies and all types of damage. hundreds of thousands of theese were produced in the dying days of onestar. but they failed to be enough to save its citizens. the sight of a skeleton lying dead in this voidsuit is not an uncommon sight in nullspace, often horifically warped and damaged. the suit is incredibly light and appears to be made out of a special fibre and lightweight matriels to allow movement of limbs in EVA while not sacrificing protection"
	icon_state = "onestar_void"
	item_state = "onestar_void"
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	armor = list(
		melee = 14,
		bullet = 12,
		energy = 14,
		bomb = 75,
		bio = 100,
		rad = 100
	)
	siemens_coefficient = 0.35
	breach_threshold = 10
	resilience = 0.05
	helmet = /obj/item/clothing/head/space/void/onestar
	spawn_blacklisted = TRUE
	slowdown = MEDIUM_SLOWDOWN
	stiffness = LIGHT_STIFFNESS
