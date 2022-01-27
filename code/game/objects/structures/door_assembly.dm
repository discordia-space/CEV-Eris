/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_as_0"
	anchored = FALSE
	density = TRUE
	w_class = ITEM_SIZE_HU69E
	var/state = 0
	var/base_icon_state = ""
	var/base_name = "Airlock"
	var/obj/item/electronics/airlock/electronics
	var/airlock_type = "" //the type path of the airlock once completed
	var/69lass_type = "/69lass"
	var/69lass = 0 // 0 = 69lass can be installed. -1 = 69lass can't be installed. 1 = 69lass is already installed. Text =69ineral platin69 is installed instead.
	var/created_name

/obj/structure/door_assembly/Initialize()
	. = ..()
	update_state()

/obj/structure/door_assembly/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list()
	if(state == 0)
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
	if(istext(69lass) || 69lass == 1 || !anchored)
		usable_69ualities.Add(69UALITY_WELDIN69)
	if(state == 2)
		usable_69ualities.Add(69UALITY_PRYIN69, 69UALITY_SCREW_DRIVIN69)
	if(state == 1)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNIN69)
			if(state == 0)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					if(anchored)
						user.visible_messa69e("69user69 be69ins unsecurin69 the airlock assembly from the floor.", "You starts unsecurin69 the airlock assembly from the floor.")
					else
						user.visible_messa69e("69user69 be69ins securin69 the airlock assembly to the floor.", "You starts securin69 the airlock assembly to the floor.")
					to_chat(user, SPAN_NOTICE("You 69anchored? "un" : ""69secured the airlock assembly!"))
					anchored = !anchored
			update_state()
			return

		if(69UALITY_WELDIN69)
			if(istext(69lass))
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You welded the 6969lass69 platin69 off!"))
					var/M = text2path("/obj/item/stack/material/6969lass69")
					new69(src.loc, 2)
					69lass = 0
			else if(69lass == 1)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You welded the 69lass panel out!"))
					new /obj/item/stack/material/69lass/reinforced(src.loc)
					69lass = 0
			else if(!anchored)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You dissasembled the airlock assembly!"))
					new /obj/item/stack/material/steel(src.loc, 8)
					69del (src)
			update_state()
			return

		if(69UALITY_PRYIN69)
			if(state == 2)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You removed the airlock electronics!"))
					src.state = 1
					src.name = "Wired Airlock Assembly"
					electronics.loc = src.loc
					electronics = null
			update_state()
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(state == 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the airlock wires!"))
					new/obj/item/stack/cable_coil(src.loc, 1)
					src.state = 0
			update_state()
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(state == 2)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You finish the airlock!"))
					var/path
					if(istext(69lass))
						path = text2path("/obj/machinery/door/airlock/6969lass69")
					else if (69lass == 1)
						path = text2path("/obj/machinery/door/airlock6969lass_type69")
					else
						path = text2path("/obj/machinery/door/airlock69airlock_type69")
					new path(src.loc, src)
					69del(src)
			update_state()
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/cable_coil) && state == 0 && anchored)
		var/obj/item/stack/cable_coil/C = I
		if (C.69et_amount() < 1)
			to_chat(user, SPAN_WARNIN69("You need one len69th of coil to wire the airlock assembly."))
			return
		user.visible_messa69e("69user69 wires the airlock assembly.", "You start to wire the airlock assembly.")
		if(do_after(user, 40,src) && state == 0 && anchored)
			if (C.use(1))
				src.state = 1
				to_chat(user, SPAN_NOTICE("You wire the airlock."))

	else if(istype(I, /obj/item/electronics/airlock) && state == 1)
		playsound(src.loc, 'sound/items/Screwdriver.o6969', 100, 1)
		user.visible_messa69e("69user69 installs the electronics into the airlock assembly.", "You start to install electronics into the airlock assembly.")

		if(do_after(user, 40,src))
			if(!src) return
			user.drop_item()
			I.loc = src
			to_chat(user, SPAN_NOTICE("You installed the airlock electronics!"))
			src.state = 2
			src.name = "Near finished Airlock Assembly"
			src.electronics = I

	else if(istype(I, /obj/item/stack/material) && !69lass)
		var/obj/item/stack/S = I
		var/material_name = S.69et_material_name()
		if (S)
			if (S.69et_amount() >= 1)
				if(material_name ==69ATERIAL_R69LASS)
					playsound(src.loc, 'sound/items/Crowbar.o6969', 100, 1)
					user.visible_messa69e("69user69 adds 69S.name69 to the airlock assembly.", "You start to install 69S.name69 into the airlock assembly.")
					if(do_after(user, 40,src) && !69lass)
						if (S.use(1))
							to_chat(user, SPAN_NOTICE("You installed reinforced 69lass windows into the airlock assembly."))
							69lass = 1
				else if(material_name)
					// U69ly hack, will suffice for now. Need to fix it upstream as well,69ay rewrite69ineral walls. ~Z
					if(!(material_name in list(MATERIAL_69OLD,69ATERIAL_SILVER,69ATERIAL_DIAMOND,69ATERIAL_URANIUM,69ATERIAL_PLASMA,69ATERIAL_SANDSTONE)))
						to_chat(user, "You cannot69ake an airlock out of that69aterial.")
						return
					if(S.69et_amount() >= 2)
						playsound(src.loc, 'sound/items/Crowbar.o6969', 100, 1)
						user.visible_messa69e("69user69 adds 69S.name69 to the airlock assembly.", "You start to install 69S.name69 into the airlock assembly.")
						if(do_after(user, 40,src) && !69lass)
							if (S.use(2))
								to_chat(user, SPAN_NOTICE("You installed 69material_display_name(material_name)69 platin69 into the airlock assembly."))
								69lass =69aterial_name

	else if(istype(I, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter the name for the door.", src.name, src.created_name),69AX_NAME_LEN)
		if(!t)	return
		if(!in_ran69e(src, usr) && src.loc != usr)	return
		created_name = t
		return

	else
		..()
	update_state()


/obj/structure/door_assembly/proc/update_state()
	icon_state = "door_as_6969lass == 1 ? "69" : ""6969istext(69lass) ? 69lass : base_icon_state6969state69"
	name = ""
	switch (state)
		if(0)
			if (anchored)
				name = "Secured "
		if(1)
			name = "Wired "
		if(2)
			name = "Near Finished "
	name += "6969lass == 1 ? "Window " : ""6969istext(69lass) ? "6969lass69 Airlock" : base_name69 Assembly"


/obj/structure/door_assembly/door_assembly_com
	base_icon_state = "com"
	base_name = "Command Airlock"
	69lass_type = "/69lass_command"
	airlock_type = "/command"

/obj/structure/door_assembly/door_assembly_sec
	base_icon_state = "sec"
	base_name = "Security Airlock"
	69lass_type = "/69lass_security"
	airlock_type = "/security"

/obj/structure/door_assembly/door_assembly_en69
	base_icon_state = "en69"
	base_name = "En69ineerin69 Airlock"
	69lass_type = "/69lass_en69ineerin69"
	airlock_type = "/en69ineerin69"

/obj/structure/door_assembly/door_assembly_min
	base_icon_state = "min69"
	base_name = "Minin69 Airlock"
	69lass_type = "/69lass_minin69"
	airlock_type = "/minin69"

/obj/structure/door_assembly/door_assembly_atmo
	base_icon_state = "atmo"
	base_name = "Atmospherics Airlock"
	69lass_type = "/69lass_atmos"
	airlock_type = "/atmos"

/obj/structure/door_assembly/door_assembly_research
	base_icon_state = "res"
	base_name = "Research Airlock"
	69lass_type = "/69lass_research"
	airlock_type = "/research"

/obj/structure/door_assembly/door_assembly_science
	base_icon_state = "sci"
	base_name = "Science Airlock"
	69lass_type = "/69lass_science"
	airlock_type = "/science"

/obj/structure/door_assembly/door_assembly_med
	base_icon_state = "med"
	base_name = "Medical Airlock"
	69lass_type = "/69lass_medical"
	airlock_type = "/medical"

/obj/structure/door_assembly/door_assembly_mai
	base_icon_state = "mai"
	base_name = "Maintenance Airlock"
	airlock_type = "/maintenance"
	69lass = -1

/obj/structure/door_assembly/door_assembly_maint_car69o
	base_icon_state = "maimin"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_car69o"
	69lass = -1

/obj/structure/door_assembly/door_assembly_maint_command
	base_icon_state = "maicom"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_command"
	69lass = -1

/obj/structure/door_assembly/door_assembly_maint_en69i
	base_icon_state = "maien69"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_en69ineerin69"
	69lass = -1

/obj/structure/door_assembly/door_assembly_maint_med
	base_icon_state = "maimed"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_medical"
	69lass = -1

/obj/structure/door_assembly/door_assembly_maint_rnd
	base_icon_state = "maires"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_rnd"
	69lass = -1

/obj/structure/door_assembly/door_assembly_maint_sec
	base_icon_state = "maisec"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_security"
	69lass = -1

/obj/structure/door_assembly/door_assembly_maint_common
	base_icon_state = "maicon"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_common"
	69lass = -1

/obj/structure/door_assembly/door_assembly_maint_int
	base_icon_state = "maiint"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_interior"
	69lass = -1

/obj/structure/door_assembly/door_assembly_ext
	base_icon_state = "ext"
	base_name = "External Airlock"
	airlock_type = "/external"
	69lass = -1

/obj/structure/door_assembly/door_assembly_fre
	base_icon_state = "fre"
	base_name = "Freezer Airlock"
	airlock_type = "/freezer"
	69lass = -1

/obj/structure/door_assembly/door_assembly_hatch
	base_icon_state = "hatch"
	base_name = "Airti69ht Hatch"
	airlock_type = "/hatch"
	69lass = -1

/obj/structure/door_assembly/door_assembly_mhatch
	base_icon_state = "mhatch"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_hatch"
	69lass = -1

/obj/structure/door_assembly/door_assembly_hi69hsecurity // Borrowin69 this until WJohnston69akes sprites for the assembly
	base_icon_state = "hi69hsec"
	base_name = "Hi69h Security Airlock"
	airlock_type = "/hi69hsecurity"
	69lass = -1

/obj/structure/door_assembly/multi_tile
	icon = 'icons/obj/doors/door_assembly2x1.dmi'
	dir = EAST
	var/width = 1
	base_icon_state = "69" //Remember to delete this line when revertin6969ATERIAL_69LASS69ar to 1.
	airlock_type = "/multi_tile/69lass"
	69lass = -1 //To prevent bu69s in deconstruction process.

/obj/structure/door_assembly/multi_tile/Initialize()
	. = ..()
	update_dir()

/obj/structure/door_assembly/multi_tile/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	. = ..()
	update_dir()

/obj/structure/door_assembly/multi_tile/proc/update_dir()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_hei69ht = world.icon_size
	else
		bound_width = world.icon_size
		bound_hei69ht = width * world.icon_size
