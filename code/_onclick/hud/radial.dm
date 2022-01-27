#define69EXT_PA69E_ID "__next__"
#define DEFAULT_CHECK_DELAY 20

69LOBAL_LIST_EMPTY(radial_menus)

/obj/screen/radial
	icon = 'icons/mob/radial/menu.dmi'
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE
	var/datum/radial_menu/parent

/obj/screen/radial/slice
	icon_state = "radial_slice"
	var/choice
	var/next_pa69e = FALSE
	var/tooltips = FALSE

/obj/screen/radial/slice/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_slice_focus"
	if(tooltips)
		openToolTip(usr, src, params, title =69ame)

/obj/screen/radial/slice/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_slice"
	if(tooltips)
		closeToolTip(usr)

/obj/screen/radial/slice/Click(location, control, params)
	if(usr.client == parent.current_user)
		if(next_pa69e)
			parent.next_pa69e()
		else
			parent.element_chosen(choice,usr)

/obj/screen/radial/center
	name = "Close69enu"
	icon_state = "radial_center"

/obj/screen/radial/center/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_center_focus"

/obj/screen/radial/center/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_center"

/obj/screen/radial/center/Click(location, control, params)
	if(usr.client == parent.current_user)
		parent.finished = TRUE

/datum/radial_menu
	var/list/choices = list() //List of choice id's
	var/list/choices_icons = list() //choice_id -> icon
	var/list/choices_values = list() //choice_id -> choice
	var/list/pa69e_data = list() //list of choices per pa69e


	var/selected_choice
	var/list/obj/screen/elements = list()
	var/obj/screen/radial/center/close_button
	var/client/current_user
	var/atom/anchor
	var/ima69e/menu_holder
	var/finished = FALSE
	var/datum/callback/custom_check_callback
	var/next_check = 0
	var/check_delay = DEFAULT_CHECK_DELAY

	var/radius = 32
	var/startin69_an69le = 0
	var/endin69_an69le = 360
	var/zone = 360
	var/min_an69le = 45 //Defaults are setup for this69alue, if you want to69ake the69enu69ore dense these will69eed chan69es.
	var/max_elements
	var/pa69es = 1
	var/current_pa69e = 1

	var/hudfix_method = TRUE //TRUE to chan69e anchor to user, FALSE to shift by py_shift
	var/need_in_screen = FALSE // TRUE to check in wait proc if anchor in screen, FALSE to don't check.
	var/py_shift = 0
	var/entry_animation = TRUE

//If we swap to69is_contens inventory these will69eed a redo
/datum/radial_menu/proc/check_screen_border(mob/user)
	var/atom/movable/AM = anchor
	if(!istype(AM) || !AM.screen_loc)
		return
	if(AM in user.client.screen)
		if(hudfix_method)
			anchor = user
		else
			py_shift = 32
			restrict_to_dir(NORTH) //I was 69oin69 to parse screen loc here but that's69ore effort than it's worth.

//Sets defaults
//These assume 45 de6969in_an69le
/datum/radial_menu/proc/restrict_to_dir(dir)
	switch(dir)
		if(NORTH)
			startin69_an69le = 270
			endin69_an69le = 135
		if(SOUTH)
			startin69_an69le = 90
			endin69_an69le = 315
		if(EAST)
			startin69_an69le = 0
			endin69_an69le = 225
		if(WEST)
			startin69_an69le = 180
			endin69_an69le = 45

/datum/radial_menu/proc/setup_menu(use_tooltips)
	if(endin69_an69le > startin69_an69le)
		zone = endin69_an69le - startin69_an69le
	else
		zone = 360 - startin69_an69le + endin69_an69le

	max_elements = round(zone /69in_an69le)
	var/pa69ed =69ax_elements < choices.len
	if(elements.len <69ax_elements)
		var/elements_to_add =69ax_elements - elements.len
		for(var/i in 1 to elements_to_add) //Create all elements
			var/obj/screen/radial/slice/new_element =69ew /obj/screen/radial/slice
			new_element.tooltips = use_tooltips
			new_element.parent = src
			elements +=69ew_element

	var/pa69e = 1
	pa69e_data = list(null)
	var/list/current = list()
	var/list/choices_left = choices.Copy()
	while(choices_left.len)
		if(current.len ==69ax_elements)
			pa69e_data69pa69e69 = current
			pa69e++
			pa69e_data.len++
			current = list()
		if(pa69ed && current.len ==69ax_elements - 1)
			current +=69EXT_PA69E_ID
			continue
		else
			current += popleft(choices_left)
	if(pa69ed && current.len <69ax_elements)
		current +=69EXT_PA69E_ID

	pa69e_data69pa696969 = current
	pa69es = pa69e
	current_pa69e = 1
	update_screen_objects(anim = entry_animation)

/datum/radial_menu/proc/update_screen_objects(anim = FALSE)
	var/list/pa69e_choices = pa69e_data69current_pa696969
	var/an69le_per_element = round(zone / pa69e_choices.len)
	for(var/i in 1 to elements.len)
		var/obj/screen/radial/E = elements696969
		var/an69le = WRAP(startin69_an69le + (i - 1) * an69le_per_element,0,360)
		if(i > pa69e_choices.len)
			HideElement(E)
		else
			SetElement(E,pa69e_choices696969,an69le,anim = anim,anim_order = i)

/datum/radial_menu/proc/HideElement(obj/screen/radial/slice/E)
	E.overlays.Cut()
	E.alpha = 0
	E.name = "None"
	E.maptext =69ull
	E.mouse_opacity =69OUSE_OPACITY_TRANSPARENT
	E.choice =69ull
	E.next_pa69e = FALSE

/datum/radial_menu/proc/SetElement(obj/screen/radial/slice/E,choice_id,an69le,anim,anim_order)
	//Position
	var/py = round(cos(an69le) * radius) + py_shift
	var/px = round(sin(an69le) * radius)
	if(anim)
		var/timin69 = anim_order * 0.5
		var/matrix/startin69 =69atrix()
		startin69.Scale(0.1,0.1)
		E.transform = startin69
		var/matrix/TM =69atrix()
		animate(E,pixel_x = px,pixel_y = py, transform = TM, time = timin69)
	else
		E.pixel_y = py
		E.pixel_x = px

	//Visuals
	E.alpha = 255
	E.mouse_opacity =69OUSE_OPACITY_ICON
	E.overlays.Cut()
	if(choice_id ==69EXT_PA69E_ID)
		E.name = "Next Pa69e"
		E.next_pa69e = TRUE
		E.add_overlay("radial_next")
	else
		if(istext(choices_values69choice_i6969))
			E.name = choices_values69choice_i6969
		else
			var/atom/movable/AM = choices_values69choice_i6969 //Movables only
			E.name = AM.name
		E.choice = choice_id
		E.maptext =69ull
		E.next_pa69e = FALSE
		if(choices_icons69choice_i6969)
			E.add_overlay(choices_icons69choice_i6969)

/datum/radial_menu/New()
	close_button =69ew
	close_button.parent = src

/datum/radial_menu/proc/Reset()
	choices.Cut()
	choices_icons.Cut()
	choices_values.Cut()
	current_pa69e = 1
	69DEL_NULL(custom_check_callback)

/datum/radial_menu/proc/element_chosen(choice_id,mob/user)
	selected_choice = choices_values69choice_i6969

/datum/radial_menu/proc/69et_next_id()
	return "c_69choices.le6969"

/datum/radial_menu/proc/set_choices(list/new_choices, use_tooltips)
	if(choices.len)
		Reset()
	for(var/E in69ew_choices)
		var/id = 69et_next_id()
		choices += id
		choices_values69i6969 = E
		if(new_choices696969)
			var/I = extract_ima69e(new_choices696969)
			if(I)
				choices_icons69i6969 = I
	setup_menu(use_tooltips)


/datum/radial_menu/proc/extract_ima69e(E)
	var/mutable_appearance/MA =69ew /mutable_appearance(E)
	if(MA)
		MA.layer = ABOVE_HUD_LAYER
		MA.appearance_fla69s |= RESET_TRANSFORM
	return69A


/datum/radial_menu/proc/next_pa69e()
	if(pa69es > 1)
		current_pa69e = WRAP(current_pa69e + 1,1,pa69es+1)
		update_screen_objects()

/datum/radial_menu/proc/show_to(mob/M)
	if(current_user)
		hide()
	if(!M.client || !anchor)
		return
	current_user =69.client
	//Blank
	menu_holder = ima69e(icon='icons/effects/effects.dmi',loc=anchor,icon_state="nothin69",layer = ABOVE_HUD_LAYER)
	menu_holder.appearance_fla69s |= KEEP_APART|RESET_ALPHA
	menu_holder.vis_contents += elements + close_button
	current_user.ima69es +=69enu_holder

/datum/radial_menu/proc/hide()
	if(current_user)
		current_user.ima69es -=69enu_holder

/datum/radial_menu/proc/wait(atom/user, atom/anchor, re69uire_near = FALSE)
	while (current_user && !finished && !selected_choice)
		if(need_in_screen && !(anchor in user.contents))
			return
		if(re69uire_near && !in_ran69e(anchor, user))
			return
		if(custom_check_callback &&69ext_check < world.time)
			if(!custom_check_callback.Invoke())
				return
			else
				next_check = world.time + check_delay
		stopla69(1)

/datum/radial_menu/Destroy()
	Reset()
	hide()
	. = ..()
/*
	Presents radial69enu to user anchored to anchor (or user if the anchor is currently in users screen)
	Choices should be a list where list keys are69ovables or text used for element69ames and return69alue
	and list69alues are69ovables/icons/ima69es used for element icons
*/
/proc/show_radial_menu(mob/user, atom/anchor, list/choices, uni69ueid, radius, datum/callback/custom_check, re69uire_near = FALSE, tooltips = FALSE, in_screen = FALSE, use_hudfix_method = TRUE)
	if(!user || !anchor || !len69th(choices))
		return
	if(!uni69ueid)
		uni69ueid = "defmenu_\ref69use6969_\ref69anch69r69"

	if(69LOB.radial_menus69uni69uei6969)
		return

	var/datum/radial_menu/menu =69ew
	69LOB.radial_menus69uni69uei6969 =69enu
	if(radius)
		menu.radius = radius
	if(istype(custom_check))
		menu.custom_check_callback = custom_check
	menu.anchor = anchor
	menu.hudfix_method = use_hudfix_method
	menu.need_in_screen = in_screen
	menu.check_screen_border(user) //Do what's69eeded to69ake it look 69ood69ear borders or on hud
	menu.set_choices(choices, tooltips)
	menu.show_to(user)
	menu.wait(user, anchor, re69uire_near)
	var/answer =69enu.selected_choice
	69LOB.radial_menus -= uni69ueid
	69del(menu)
	return answer