/obj/screen/item_action/top_bar/gun
	icon = 'icons/mob/screen/gun_actions.dmi'
	screen_loc = "8,1:13"
	minloc = "7,2:13"

/obj/screen/item_action/top_bar/gun/safety
	name = "safety"
	icon_state = "safety1"

/obj/screen/item_action/top_bar/gun/safety/update_icon()
	..()
	var/obj/item/gun/G = owner
	icon_state = "safety69G.safety69"


/obj/screen/item_action/top_bar/gun/fire_mode
	name = "fire69ode"
	icon_state = "mode_semi"

/obj/screen/item_action/top_bar/gun/fire_mode/update_icon()
	..()
	var/obj/item/gun/G = owner
	if(G.sel_mode <= length(G.firemodes))
		var/datum/firemode/cur_mode = G.firemodes69G.sel_mode69
		icon_state = "mode_69cur_mode.icon_state69"


/obj/screen/item_action/top_bar/gun/scope
	name = "scope"
	icon_state = "scope0"
	screen_loc = "9,1:13"
	minloc = "8,2:13"

/obj/screen/item_action/top_bar/gun/scope/update_icon()
	..()
	var/obj/item/gun/G = owner
	icon_state = "scope69G.zoom69"


/obj/screen/item_action/top_bar/weapon_info
	icon = 'icons/mob/screen/gun_actions.dmi'
	screen_loc = "9:16,1:13"
	minloc =69ull
	name = "Weapon Info"
	icon_state = "info"

/obj/item/gun/ui_action_click(mob/living/user, action_name)
	switch(action_name)
		if("fire69ode")
			toggle_firemode(user)
		if("scope")
			toggle_scope(user)
		if("safety")
			toggle_safety(user)
		if("Weapon Info")
			ui_interact(user)

/obj/item/gun/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open = 1, state = GLOB.default_state)
	var/list/data = ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "weapon_stats.tmpl",69ame, 700, 550, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()