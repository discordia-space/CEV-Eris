/obj/item/punk_lootbox
	name = "jacket box"
	desc = "Brown cardboard box."
	icon_state = "jacket_box"
	matter = list(MATERIAL_CARDBOARD = 2)
	rarity_value = 65

/obj/item/punk_lootbox/attack_self(mob/user)
	. = ..()
	if(icon_state == "jacket_box_open")
		to_chat(user, SPAN_NOTICE("You fold \the [name] flat."))
		new /obj/item/stack/material/cardboard(get_turf(src))
		qdel(src)
		return

	var/jacket_list = list(
		"Bright" = "punk_bright",
		"Dark" = "punk_dark",
		"Dark with highlights" = "punk_highlight")

	var/jacket_type = input(user, "Choose jacket type", "What kind of punk are you?") as null|anything in jacket_list
	if(!jacket_type)
		to_chat(user, SPAN_NOTICE("You're an indecisive punk today."))
		return

	var/logo_list = list(
		"Valentinos" = "punk_over_valentinos",
		"Samurai" = "punk_over_samurai",
		"Jager Roaches" = "punk_over_jager_roach",
		"Tunnel Snakes" = "punk_over_tunnel_snakes",
		"No logo" = "")

	var/logo_type = input(user, "Choose logo type", "Gang affiliation much?") as null|anything in logo_list

	new /obj/item/clothing/suit/storage/greatcoat/punk(loc = get_turf(loc), jacket_type = jacket_list[jacket_type], logo_type = logo_list[logo_type], is_natural_spawn = FALSE)
	to_chat(user, SPAN_NOTICE("You take out the jacket."))
	icon_state = "jacket_box_open"
	update_icon()
