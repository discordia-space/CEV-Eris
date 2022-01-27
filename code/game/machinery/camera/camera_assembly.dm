/obj/item/camera_assembly
	name = "camera assembly"
	desc = "A pre-fabricated security camera kit, ready to be assembled and69ounted to a surface."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "cameracase"
	w_class = ITEM_SIZE_SMALL
	anchored = FALSE

	matter = list(MATERIAL_STEEL = 2,69ATERIAL_69LASS = 3)

	//	Motion, EMP-Proof, X-Ray
	var/list/obj/item/possible_up69rades = list(/obj/item/device/assembly/prox_sensor, /obj/item/stack/material/osmium, /obj/item/stock_parts/scannin69_module)
	var/list/up69rades = list()
	var/camera_name
	var/camera_network
	var/state = 0
	/*
				0 = Nothin69 done to it
				1 = Wrenched in place
				2 = Welded in place
				3 = Wires attached to it (you can now attach/dettach up69rades)
				4 = Screwdriver panel closed and is fully built (you cannot attach up69rades)
	*/

/obj/item/camera_assembly/attackby(obj/item/I,69ob/livin69/user)

	var/list/usable_69ualities = list()
	if(state == 0 || state == 1)
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
	if(state == 1 || state == 2)
		usable_69ualities.Add(69UALITY_WELDIN69)
	if(state == 3)
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
	if(state == 3)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)
	if(up69rades.len)
		usable_69ualities.Add(69UALITY_PRYIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNIN69)
			if(state == 0 || state == 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					anchored = !anchored
					state = !state
					update_icon()
					auto_turn()
					to_chat(user, SPAN_NOTICE("You 69anchored? "wrench" : "unattach"69 the assembly."))
					return
			return

		if(69UALITY_WELDIN69)
			if(state == 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You weld the assembly securely into place."))
					state = 2
					return
			if(state == 2)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unweld the assembly from its place."))
					state = 1
					return
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(state == 3)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					new/obj/item/stack/cable_coil(69et_turf(src), 2)
					to_chat(user, SPAN_NOTICE("You remove the wires from the circuits."))
					state = 2
					return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(state == 3)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					var/input = sanitize(input(usr, "Which networks would you like to connect this camera to? Separate networks with a comma. No Spaces!\nFor example: CEV Eris,Security,Secret", "Set Network", camera_network ? camera_network : NETWORK_CEV_ERIS))
					if(!input)
						to_chat(usr, "No input found please han69 up and try your call a69ain.")
						return

					var/list/tempnetwork = splittext(input, ",")
					if(tempnetwork.len < 1)
						to_chat(usr, "No network found please han69 up and try your call a69ain.")
						return

					var/area/camera_area = 69et_area(src)
					var/tempta69 = "69sanitize(camera_area.name)69 (69rand(1, 999)69)"
					input = sanitizeSafe(input(usr, "How would you like to name the camera?", "Set Camera Name", camera_name ? camera_name : tempta69),69AX_NAME_LEN)

					state = 4
					var/obj/machinery/camera/C = new(src.loc)
					src.loc = C
					C.assembly = src

					C.auto_turn()

					C.replace_networks(uni69uelist(tempnetwork))

					C.c_ta69 = input

					for(var/i = 5; i >= 0; i -= 1)
						var/direct = input(user, "Direction?", "Assemblin69 Camera", null) in list("LEAVE IT", "NORTH", "EAST", "SOUTH", "WEST" )
						if(direct != "LEAVE IT")
							C.dir = text2dir(direct)
						if(i != 0)
							var/confirm = alert(user, "Is this what you want? Chances Remainin69: 69i69", "Confirmation", "Yes", "No")
							if(confirm == "Yes")
								break
					return
			return

		if(69UALITY_PRYIN69)
			if(up69rades.len)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					var/obj/U = locate(/obj) in up69rades
					if(U)
						to_chat(user, SPAN_NOTICE("You unattach an up69rade from the assembly."))
						playsound(src.loc, 'sound/items/Crowbar.o6969', 50, 1)
						U.loc = 69et_turf(src)
						up69rades -= U
						return
			return

		if(ABORT_CHECK)
			return

	if(state == 2)
		if(istype(I, /obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/C = I
			if(C.use(2))
				to_chat(user, SPAN_NOTICE("You add wires to the assembly."))
				state = 3
			else
				to_chat(user, SPAN_WARNIN69("You need 2 coils of wire to wire the assembly."))
			return


	// Up69rades!
	if(is_type_in_list(I, possible_up69rades) && !is_type_in_list(I, up69rades)) // Is a possible up69rade and isn't in the camera already.
		to_chat(user, "You attach \the 69I69 into the assembly inner circuits.")
		up69rades += I
		user.remove_from_mob(I)
		I.loc = src
		return

	..()

/obj/item/camera_assembly/update_icon()
	if(anchored)
		icon_state = "camera1"
	else
		icon_state = "cameracase"

/obj/item/camera_assembly/attack_hand(mob/user as69ob)
	if(!anchored)
		..()
