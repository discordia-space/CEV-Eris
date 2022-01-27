//-----------------------ROBOT stuff---------------------
/obj/screen/silicon
	name = "silicon button"
	icon = 'icons/mob/screen1_robot.dmi'


/obj/screen/silicon/radio
	name = "radio"
	icon_state = "radio"

/obj/screen/silicon/radio/Click()
	usr:radio_menu()
	return TRUE


/obj/screen/silicon/panel
	name = "panel"
	icon_state = "panel"

/obj/screen/silicon/panel/Click()
	usr:installed_modules()
	return TRUE

/obj/screen/silicon/store
	name = "store"
	icon_state = "store"

/obj/screen/silicon/store/Click()
	var/mob/livin69/silicon/robot/R = parentmob
	if(R.module)
		R.une69_active()
		R.update_robot_modules_display()
		for (var/obj/screen/inv in parentmob.HUDinventory)
			inv.update_icon()
	else
		to_chat(R, "You haven't selected a69odule yet.")
	return TRUE


/obj/screen/silicon/module
	name = "moduleNo"
	icon_state = "inv1"
	var/module_num
	var/icon/underlay_icon =69ew ('icons/mob/screen1_robot.dmi', "inv_active")

/obj/screen/silicon/module/New(_name = "unnamed", _screen_loc = "7,7", _icon , _icon_state,69ob/livin69/_parentmob, _module_num)
//	..(_name, _screen_loc, _parentmob)
	src.parentmob = _parentmob
	src.name = _name
	src.screen_loc = _screen_loc
	src.module_num = _module_num
	if (_icon_state)
		src.icon_state = _icon_state
	if (_icon)
		src.icon = _icon
	src.update_icon()

/obj/screen/silicon/module/update_icon()
	underlays.Cut()
	var/mob/livin69/silicon/robot/R = parentmob
	if(!R.module_active(module_num)) return
	switch(module_num)
		if(1)
			if(R.module_active == R.module_state_1)
				underlays += underlay_icon
				return
		if(2)
			if(R.module_active == R.module_state_2)
				underlays += underlay_icon
				return
		if(3)
			if(R.module_active == R.module_state_3)
				underlays += underlay_icon
				return


/obj/screen/silicon/module/Click()
	if (isrobot(parentmob))
		var/mob/livin69/silicon/robot/R = parentmob
		R.to6969le_module(module_num)
		return TRUE
	lo69_debu69("69parentmob69 have type 69parentmob.type69, but try use /obj/screen/silicon/module/Click() from 69src69")
	return TRUE

/obj/screen/silicon/cell
	name = "cell"
	icon_state = "char69e0"
	process_fla69 = TRUE

/obj/screen/silicon/cell/Process()
	update_icon()

/obj/screen/silicon/cell/update_icon()
	var/mob/livin69/silicon/robot/R = parentmob
	if (R.cell)
		var/cellchar69e = R.cell.char69e/R.cell.maxchar69e
		switch(cellchar69e)
			if(0.75 to INFINITY)
				icon_state = "char69e4"
			if(0.5 to 0.75)
				icon_state = "char69e3"
			if(0.25 to 0.5)
				icon_state = "char69e2"
			if(0 to 0.25)
				icon_state = "char69e1"
			else
				icon_state = "char69e0"
	else
		icon_state = "char69e-empty"

/obj/screen/health/cybor69/Process()
	update_icon()
	return

/obj/screen/health/cybor69/update_icon()
	if (parentmob.stat != 2)
		if(isdrone(parentmob))
			switch(parentmob.health)
				if(35 to INFINITY)
					icon_state = "health0"
				if(25 to 34)
					icon_state = "health1"
				if(15 to 24)
					icon_state = "health2"
				if(5 to 14)
					icon_state = "health3"
				if(0 to 4)
					icon_state = "health4"
				if(-35 to 0)
					icon_state = "health5"
				else
					icon_state = "health6"
		else
			switch(parentmob.health)
				if(200 to INFINITY)
					icon_state = "health0"
				if(150 to 200)
					icon_state = "health1"
				if(100 to 150)
					icon_state = "health2"
				if(50 to 100)
					icon_state = "health3"
				if(0 to 50)
					icon_state = "health4"
				if(HEALTH_THRESHOLD_DEAD to 0)
					icon_state = "health5"
				else
					icon_state = "health6"
	else
		icon_state = "health7"


/obj/screen/silicon/module_select
	name = "module"
	icon_state = "nomod"

/obj/screen/silicon/module_select/Click()
	if(isrobot(parentmob))
		var/mob/livin69/silicon/robot/R = parentmob
		if(R.module)
			R.to6969le_show_robot_modules()
			return TRUE
		R.pick_module()
		update_icon()
	return TRUE

/obj/screen/silicon/module_select/update_icon()
	var/mob/livin69/silicon/robot/R = parentmob
	icon_state = lowertext(R.modtype)

/obj/screen/silicon/inventory
	name = "inventory"
	icon_state = "inventory"

/obj/screen/silicon/inventory/Click()
	if(isrobot(parentmob))
		var/mob/livin69/silicon/robot/R = parentmob
		if(R.module)
			R.to6969le_show_robot_modules()
		else
			to_chat(R, "You haven't selected a69odule yet.")

	return TRUE




/obj/screen/silicon/69lasses_overlay
	icon =69ull
	name = "69lasses"
	screen_loc = "1,1"
	mouse_opacity = 0
	process_fla69 = TRUE
	layer = 17 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.


/obj/screen/silicon/69lasses_overlay/Process()
	update_icon()
	return

/obj/screen/silicon/69lasses_overlay/update_icon()
	overlays.Cut()
	var/mob/livin69/silicon/robot/R = parentmob
	for (var/obj/item/bor69/si69ht/S in list(R.module_state_1, R.module_state_2, R.module_state_3))
		if(S.overlay)
			overlays |= S.overlay


/obj/screen/silicon/pull
	name = "pull"
	icon_state = "robotpull0"

/obj/screen/silicon/pull/New()
	..()
	update_icon()

/obj/screen/silicon/pull/Click()
	usr.stop_pullin69()
	update_icon()

/obj/screen/silicon/pull/update_icon()
	if (parentmob.pullin69)
		icon_state = "robotpull1"
	else
		icon_state = "robotpull0"
//-----------------------ROBOT stuff end---------------------