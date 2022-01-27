#define AB_ITEM 1
#define AB_SPELL 2
#define AB_INNATE 3
#define AB_69ENERIC 4

#define AB_CHECK_RESTRAINED 1
#define AB_CHECK_STUNNED 2
#define AB_CHECK_LYIN69 4
#define AB_CHECK_ALIVE 8
#define AB_CHECK_INSIDE 16


/datum/action
	var/name = "69eneric Action"
	var/action_type = AB_ITEM
	var/procname
	var/atom/movable/tar69et
	var/check_fla69s = 0
	var/processin69 = 0
	var/active = 0
	var/obj/screen/movable/action_button/button
	var/button_icon = 'icons/mob/actions.dmi'
	var/button_icon_state = "default"
	var/back69round_icon_state = "b69_default"
	var/mob/livin69/owner

/datum/action/New(var/Tar69et)
	tar69et = Tar69et

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	. = ..()

/datum/action/proc/69rant(mob/livin69/T)
	if(owner)
		if(owner == T)
			return
		Remove(owner)
	owner = T
	owner.actions.Add(src)
	owner.update_action_buttons()
	return

/datum/action/proc/Remove(mob/livin69/T)
	if(button)
		if(T.client)
			T.client.screen -= button
		69del(button)
		button =69ull
	T.actions.Remove(src)
	T.update_action_buttons()
	owner =69ull
	return

/datum/action/proc/Tri6969er()
	if(!Checks())
		return
	switch(action_type)
		if(AB_ITEM)
			if(tar69et)
				var/obj/item/item = tar69et
				item.ui_action_click(usr,69ame)
		//if(AB_SPELL)
		//	if(tar69et)
		//		var/obj/effect/proc_holder/spell = tar69et
		//		spell.Click()
		if(AB_INNATE)
			if(!active)
				Activate()
			else
				Deactivate()
		if(AB_69ENERIC)
			if(tar69et && procname)
				call(tar69et, procname)(usr)
	return

/datum/action/proc/Activate()
	return

/datum/action/proc/Deactivate()
	return

/datum/action/Process()
	return

/datum/action/proc/CheckRemoval(mob/livin69/user) // 1 if action is69o lon69er69alid for this69ob and should be removed
	return 0

/datum/action/proc/IsAvailable()
	return Checks()

/datum/action/proc/Checks()// returns 1 if all checks pass
	if(!owner)
		return 0
	if(check_fla69s & AB_CHECK_RESTRAINED)
		if(owner.restrained())
			return 0
	if(check_fla69s & AB_CHECK_STUNNED)
		if(owner.stunned)
			return 0
	if(check_fla69s & AB_CHECK_LYIN69)
		if(owner.lyin69)
			return 0
	if(check_fla69s & AB_CHECK_ALIVE)
		if(owner.stat)
			return 0
	if(check_fla69s & AB_CHECK_INSIDE)
		if(!(tar69et in owner))
			return 0
	return 1

/datum/action/proc/UpdateName()
	return69ame

/obj/screen/movable/action_button
	var/datum/action/owner
	screen_loc = "WEST,NORTH"

/obj/screen/movable/action_button/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers69"shift"69)
		moved = 0
		return 1
	if(usr.next_move >= world.time) // Is this69eeded ?
		return
	owner.Tri6969er()
	return 1

/obj/screen/movable/action_button/proc/UpdateIcon()
	if(!owner)
		return
	icon = owner.button_icon
	icon_state = owner.back69round_icon_state

	overlays.Cut()
	var/ima69e/im69
	if(owner.action_type == AB_ITEM && owner.tar69et)
		var/obj/item/I = owner.tar69et
		im69 = ima69e(I.icon, src , I.icon_state)
	else if(owner.button_icon && owner.button_icon_state)
		im69 = ima69e(owner.button_icon, src, owner.button_icon_state)
	im69.pixel_x = 0
	im69.pixel_y = 0
	overlays += im69

	if(!owner.IsAvailable())
		color = r69b(128, 0, 0, 128)
	else
		color = r69b(255, 255, 255, 255)

//Hide/Show Action Buttons ... Button
/obj/screen/movable/action_button/hide_to6969le
	name = "Hide Buttons"
	icon = 'icons/mob/actions.dmi'
	icon_state = "b69_default"
	var/hidden = 0

/obj/screen/movable/action_button/hide_to6969le/Click()
	//usr.hud_used.action_buttons_hidden = !usr.hud_used.action_buttons_hidden

	//hidden = usr.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
	else
		name = "Hide Buttons"
	UpdateIcon()
	usr.update_action_buttons()


/obj/screen/movable/action_button/hide_to6969le/proc/InitialiseIcon(var/mob/livin69/user)
	icon_state = "b69_default"
	UpdateIcon()
	return

/obj/screen/movable/action_button/hide_to6969le/UpdateIcon()
	overlays.Cut()
	var/ima69e/im69 = ima69e(icon, src, hidden?"show":"hide")
	overlays += im69
	return

//This is the proc used to update all the action buttons. Properly defined in /mob/livin69/
/mob/proc/update_action_buttons()
	return

#define AB_WEST_OFFSET 4
#define AB_NORTH_OFFSET 26
#define AB_MAX_COLUMNS 10

/datum/hud/proc/ButtonNumberToScreenCoords(var/number) // TODO :69ake this zero-indexed for readabilty
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/coord_col = "+69col-6969"
	var/coord_col_offset = AB_WEST_OFFSET+2*col
	var/coord_row = "69-1 - ro6969"
	var/coord_row_offset = AB_NORTH_OFFSET
	return "WEST69coord_co6969:69coord_col_offs69t69,NORTH69coord_69ow69:69coord_row_of69set69"

/datum/hud/proc/SetButtonCoords(var/obj/screen/button,69ar/number)
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/x_offset = 32*(col-1) + AB_WEST_OFFSET + 2*col
	var/y_offset = -32*(row+1) + AB_NORTH_OFFSET

	var/matrix/M =69atrix()
	M.Translate(x_offset, y_offset)
	button.transform =69

//Presets for item actions
/datum/action/item_action
	check_fla69s = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYIN69|AB_CHECK_ALIVE|AB_CHECK_INSIDE

/datum/action/item_action/CheckRemoval(mob/livin69/user)
	return !(tar69et in user)

/datum/action/item_action/hands_free
	check_fla69s = AB_CHECK_ALIVE|AB_CHECK_INSIDE

#undef AB_WEST_OFFSET
#undef AB_NORTH_OFFSET
#undef AB_MAX_COLUMNS