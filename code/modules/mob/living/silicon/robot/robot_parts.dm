/obj/item/robot_parts
	name = "robot parts"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon = 'icons/obj/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	dir = SOUTH
	matter = list(MATERIAL_STEEL = 15)
	bad_type = /obj/item/robot_parts
	var/body_part = "part"

/obj/item/robot_parts/set_dir()
	return

/obj/item/robot_parts/Initialize(newloc)
	. = ..()
	name = "robot 69initial(name)69"

/obj/item/robot_parts/proc/is_ready(var/mob/living/user)
	return TRUE

/obj/item/robot_parts/l_arm
	name = "left arm"
	icon_state = "l_arm"
	body_part = "l_arm"

/obj/item/robot_parts/r_arm
	name = "right arm"
	icon_state = "r_arm"
	body_part = "r_arm"

/obj/item/robot_parts/l_leg
	name = "left leg"
	icon_state = "l_leg"
	body_part = "l_leg"

/obj/item/robot_parts/r_leg
	name = "right leg"
	icon_state = "r_leg"
	body_part = "r_leg"

/obj/item/robot_parts/chest
	name = "torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "chest"
	body_part = "chest"
	matter = list(MATERIAL_STEEL = 25)
	var/wires = 0
	var/obj/item/cell/large/cell

/obj/item/robot_parts/chest/is_ready(var/mob/living/user)
	if(!wires)
		to_chat(user, SPAN_WARNING("You need to attach wires to it first!"))
		return FALSE
	else if(!cell)
		to_chat(user, SPAN_WARNING("You need to attach a cell to it first!"))
		return FALSE
	return TRUE

/obj/item/robot_parts/head
	name = "head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"
	body_part = "head"
	var/obj/item/device/flash/flash1 = null
	var/obj/item/device/flash/flash2 = null

/obj/item/robot_parts/head/is_ready(var/mob/living/user)
	if(!flash1 || !flash2)
		to_chat(user, SPAN_WARNING("You need to attach a flash to it first!"))
		return FALSE
	return TRUE

/obj/item/robot_parts/robot_suit
	name = "endoskeleton"
	desc = "A complex69etal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"
	matter = list(MATERIAL_STEEL = 20)
	var/list/req_parts = list(
		"chest",
		"head",
		"l_arm",
		"r_arm",
		"l_leg",
		"r_leg"
	)
	var/list/parts = list()
	var/created_name = ""

/obj/item/robot_parts/robot_suit/with_limbs/Initialize()
	. = ..()
	var/list/preinstalled = list(
		/obj/item/robot_parts/r_arm,
		/obj/item/robot_parts/l_arm,
		/obj/item/robot_parts/r_leg,
		/obj/item/robot_parts/l_leg
	)
	for(var/path in preinstalled)
		var/obj/item/robot_parts/P = new path (src)
		parts69P.body_part69 = P
	update_icon()

/obj/item/robot_parts/robot_suit/update_icon()
	src.overlays.Cut()
	for(var/part in parts)
		if(parts69part69)
			overlays += "69part69+o"

/obj/item/robot_parts/robot_suit/is_ready()
	var/list/missed = req_parts - parts
	return !missed.len

/obj/item/robot_parts/robot_suit/attackby(obj/item/W as obj,69ob/user as69ob)
	..()
	if(istype(W, /obj/item/stack/material) && W.get_material_name() ==69ATERIAL_STEEL && !parts.len)
		var/obj/item/stack/material/M = W
		if (M.use(1))
			var/obj/item/secbot_assembly/ed209_assembly/B = new(loc)
			B.forceMove(get_turf(src))
			to_chat(user, SPAN_NOTICE("You armed the robot frame."))
			if (user.get_inactive_hand() == src)
				user.remove_from_mob(src)
				user.put_in_inactive_hand(B)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("You need one sheet of69etal to arm the robot frame."))

	if(W.has_quality(QUALITY_BOLT_TURNING))
		var/part = input("Select part for detach", "Detach") \
			as null|anything in parts
		var/obj/item/robot_parts/selected = part ? parts69part69 : null
		if(!Adjacent(user) || !selected) return

		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		if(!W.use_tool(user, src, 30, QUALITY_BOLT_TURNING))
			to_chat(user, SPAN_NOTICE("You stop detaching 69selected69."))
			return

		if(selected.loc == src)
			parts -= selected.body_part
		else
			return

		selected.forceMove(get_turf(src))
		src.update_icon()
		user.visible_message(
			SPAN_NOTICE("69user69 detached 69selected69 from 69src69."),
			SPAN_NOTICE("You had successfuly detach 69selected69 from 69src69."),
			SPAN_WARNING("You have hear how something69etallic hit the floor.")
		)
		return

	if(istype(W, /obj/item/robot_parts))
		var/obj/item/robot_parts/RP = W
		if(!req_parts.Find(RP.body_part))
			to_chat(user, SPAN_WARNING("You can't attach that here!"))
			return
		if(parts69RP.body_part69)
			to_chat(user, SPAN_WARNING("There is already one 69parts69RP.body_part6969 attached."))
			return
		if(!RP.is_ready(user))
			return
		parts69RP.body_part69 = RP

		user.drop_from_inventory(W, src)
		src.update_icon()

	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(!is_ready(user))
			to_chat(user, SPAN_WARNING("The69MI69ust go in after everything else!"))
			return

		if(!istype(loc,/turf))
			to_chat(user, SPAN_WARNING("You can't put \the 69W69 in, the frame has to be standing on the ground to be perfectly precise."))
			return
		if(!M.brainmob)
			to_chat(user, SPAN_WARNING("Sticking an empty 69W69 into the frame would sort of defeat the purpose."))
			return
		if(!M.brainmob.key)
			var/ghost_can_reenter = 0
			if(M.brainmob.mind)
				for(var/mob/observer/ghost/G in GLOB.player_list)
					if(G.can_reenter_corpse && G.mind ==69.brainmob.mind)
						ghost_can_reenter = 1
						break
			if(!ghost_can_reenter)
				to_chat(user, SPAN_NOTICE("\The 69W69 is completely unresponsive; there's no point."))
				return

		if(M.brainmob.stat == DEAD)
			to_chat(user, SPAN_WARNING("Sticking a dead 69W69 into the frame would sort of defeat the purpose."))
			return

		if(jobban_isbanned(M.brainmob, "Robot"))
			to_chat(user, SPAN_WARNING("This 69W69 does not seem to fit."))
			return

		var/mob/living/silicon/robot/O = new (get_turf(loc), unfinished = 1)
		if(!O)	return

		user.unEquip(M)

		O.mmi =69
		O.invisibility = 0
		O.custom_name = created_name
		O.updatename("Default")

		M.brainmob.mind.transfer_to(O)

		if(O.mind && player_is_antag(O.mind))
			O.mind.store_memory({"
				In case you look at this after being borged,
				the objectives are only here until I find a way to69ake them not show up for you,
				as I can't simply delete them without screwing up round-end reporting. --NeoFite
			"})

		O.job = "Robot"
		var/obj/item/robot_parts/chest/chest = parts69"chest"69
		O.cell = chest.cell
		O.cell.forceMove(O)
		//Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.
		W.forceMove(O)

		// Since we "magically" installed a cell, we also have to update the correct component.
		if(O.cell)
			var/datum/robot_component/cell_component = O.components69"power cell"69
			cell_component.wrapped = O.cell
			cell_component.installed = 1

		callHook("borgify", list(O))
		O.Namepick()

		qdel(src)

	if (istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", src.name, src.created_name),69AX_NAME_LEN)
		if (!t)
			return
		if (!Adjacent(user) && src.loc != user)
			return

		src.created_name = t

	return

/obj/item/robot_parts/chest/attackby(obj/item/W,69ob/living/user)
	if(istype(W, /obj/item/cell))
		if(src.cell)
			to_chat(user, SPAN_WARNING("You have already inserted a cell!"))
		else
			user.drop_from_inventory(W, src)
			src.cell = W
			to_chat(user, SPAN_NOTICE("You insert the cell!"))
	else if(istype(W, /obj/item/stack/cable_coil))
		if(src.wires)
			to_chat(user, SPAN_WARNING("You have already inserted wire!"))
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			coil.use(1)
			src.wires = W.color
			to_chat(user, SPAN_NOTICE("You insert the wire!"))

	var/tool_type = W.get_tool_type(user, list(QUALITY_SCREW_DRIVING, QUALITY_WIRE_CUTTING), src)
	switch(tool_type)
		if(QUALITY_SCREW_DRIVING)
			if(cell)
				to_chat(user, SPAN_WARNING("You eject the cell!"))
				user.put_in_hands(cell)
				cell = null
			else
				to_chat(user, SPAN_WARNING("There is nothing to eject."))
			return
		if(QUALITY_WIRE_CUTTING)
			if(wires)
				var/obj/item/stack/cable_coil/C = new(src.loc, 1)
				C.color = wires
				wires = 0
				user.put_in_hands(C)
				to_chat(user, SPAN_WARNING("You cut the wire!"))
			else
				to_chat(user, SPAN_WARNING("There is no wire inside!"))


/obj/item/robot_parts/head/attackby(obj/item/W as obj,69ob/user as69ob)
	..()
	if(istype(W, /obj/item/device/flash))
		if(isrobot(user))
			var/current_module = user.get_active_hand()
			if(current_module == W)
				to_chat(user, SPAN_WARNING("How do you propose to do that?"))
				return
			else
				add_flashes(W,user)
		else
			add_flashes(W,user)

	else if(W.has_quality(QUALITY_SCREW_DRIVING))
		if(flash2)
			user.put_in_hands(flash2)
			user.visible_message(SPAN_NOTICE("69user69 eject 69flash269 from 69src69."))
			flash2 = null
		else if(flash1)
			user.put_in_hands(flash1)
			user.visible_message(SPAN_NOTICE("69user69 eject 69flash169 from 69src69."))
			flash1 = null
		else
			to_chat(user, "<span class='warning'There is nothing to eject.</span>")

	else if(istype(W, /obj/item/stock_parts/manipulator))
		to_chat(user, SPAN_NOTICE("You install some69anipulators and69odify the head, creating a functional spider-bot!"))
		new /mob/living/simple_animal/spiderbot(get_turf(loc))
		user.drop_from_inventory(W)
		qdel(W)
		qdel(src)


//Made into a seperate proc to avoid copypasta
/obj/item/robot_parts/head/proc/add_flashes(obj/item/W as obj,69ob/user as69ob)
	if(src.flash1 && src.flash2)
		to_chat(user, SPAN_NOTICE("You have already inserted the eyes!"))
		return
	else if(src.flash1)
		src.flash2 = W
	else
		src.flash1 = W
	user.drop_from_inventory(W, src)
	to_chat(user, SPAN_NOTICE("You insert the flash into the eye socket!"))
