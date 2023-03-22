/obj/item/clothing/head/space/void/excelsior
	name = "Excelsior helmet"
	desc = "A deceptively well armored space helmet. Ancient design, but advanced manufacturing."
	icon_state = "cosmo"
	item_state = "cosmo"

	//The excelsior armors cost small amounts of rare materials that they can teleport in.
	//This means they can either build up materials over time, or make it go faster by scavenging rare mats
	matter = list(
		MATERIAL_PLASTIC = 20,
		MATERIAL_GLASS = 10,
		MATERIAL_PLASTEEL = 3
	)

	armor = list(
		melee = 10,
		bullet = 13,
		energy = 14,
		bomb = 75,
		bio = 100,
		rad = 75
	)
	siemens_coefficient = 0
	species_restricted = list(SPECIES_HUMAN)
	//camera_networks = list(NETWORK_EXCELSIOR) //Todo future: Excelsior camera network and monitoring console
	light_overlay = "helmet_light_green"
	var/obj/item/clothing/glasses/hud/excelsior/hud
	price_tag = 300

/obj/item/clothing/head/space/void/excelsior/New()
	..()
	hud = new(src)
	hud.canremove = FALSE

/obj/item/clothing/head/space/void/excelsior/equipped()
	..()
	toggle_hud()

/obj/item/clothing/head/space/void/excelsior/verb/toggle_hud()
	set name = "Toggle Excelsior Hud"
	set desc = "Shows you who's a communist and who will soon become a communist."
	set category = "Object"
	var/mob/living/carbon/human/user = loc
	if(!istype(user) || usr.stat || user.restrained())
		return
	if(user.get_equipped_item(slot_head) != src)
		return
	if(hud in src)
		if(user.glasses)
			to_chat(user, SPAN_WARNING("You fail to enable the hud due to something being in the way."))
		else
			user.equip_to_slot(hud, slot_glasses)
			to_chat(user, "You enable the hud.")
	else
		if(ismob(hud.loc))
			var/mob/hud_loc = hud.loc
			hud_loc.drop_from_inventory(hud, src)
			to_chat(user, "You disable the hud.")
		hud.forceMove(src)

/obj/item/clothing/head/space/void/excelsior/dropped(usr)
	..()
	if(hud.loc != src)
		if(ismob(hud.loc))
			var/mob/hud_loc = hud.loc
			hud_loc.drop_from_inventory(hud, src)
		hud.forceMove(src)

/obj/item/clothing/suit/space/void/excelsior
	name = "Excelsior armor"
	desc = "An ancient space suit design, remade with advanced materials. Provides good protection, especially against energy discharges, while remaining surprisingly flexible."
	icon_state = "soviet_skaf"
	item_state = "soviet_skaf"
	slowdown = 0.2
	w_class = ITEM_SIZE_NORMAL
	armor = list(
		melee = 10,
		bullet = 13,
		energy = 14,
		bomb = 75,
		bio = 100,
		rad = 75
	)
	siemens_coefficient = 0 //Shockproof!
	breach_threshold = 6
	resilience = 0.08
	matter = list(
		MATERIAL_PLASTIC = 30,
		MATERIAL_STEEL = 10,
		MATERIAL_PLASTEEL = 5
	)
	helmet = /obj/item/clothing/head/space/void/excelsior
	spawn_blacklisted = TRUE
	slowdown = MEDIUM_SLOWDOWN
