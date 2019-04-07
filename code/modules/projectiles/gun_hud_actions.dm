/obj/screen/item_action/top_bar/gun
	icon = 'icons/mob/screen/gun_actions.dmi'
	screen_loc = "8,1:13"
	minloc = "7,2:13"

/obj/screen/item_action/top_bar/gun/safety
	name = "safety"
	icon_state = "safety1"

/obj/screen/item_action/top_bar/gun/safety/update_icon()
	..()
	var/obj/item/weapon/gun/G = owner
	icon_state = "safety[G.safety]"


/obj/screen/item_action/top_bar/gun/fire_mode
	name = "fire mode"
	icon_state = "mode_semi"

/obj/screen/item_action/top_bar/gun/fire_mode/update_icon()
	..()
	var/obj/item/weapon/gun/G = owner
	if(G.sel_mode <= length(G.firemodes))
		var/datum/firemode/cur_mode = G.firemodes[G.sel_mode]
		icon_state = "mode_[cur_mode.icon_state]"


/obj/screen/item_action/top_bar/gun/scope
	name = "scope"
	icon_state = "scope0"
	screen_loc = "9,1:13"
	minloc = "8,2:13"

/obj/screen/item_action/top_bar/gun/scope/update_icon()
	..()
	var/obj/item/weapon/gun/G = owner
	icon_state = "scope[G.zoom]"

