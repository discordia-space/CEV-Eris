/obj/item/robot_parts
	name = "robot parts"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon = 'icons/obj/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	dir = SOUTH

/obj/item/robot_parts/set_dir()
	return

/obj/item/robot_parts/New(var/newloc, var/model)
	..(newloc)
	name = "robot [initial(name)]"

/obj/item/robot_parts/l_arm
	name = "left arm"
	icon_state = "l_arm"

/obj/item/robot_parts/r_arm
	name = "right arm"
	icon_state = "r_arm"

/obj/item/robot_parts/l_leg
	name = "left leg"
	icon_state = "l_leg"

/obj/item/robot_parts/r_leg
	name = "right leg"
	icon_state = "r_leg"

/obj/item/robot_parts/chest
	name = "torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "chest"
	var/wires = 0.0
	var/obj/item/weapon/cell/large/cell = null

/obj/item/robot_parts/head
	name = "head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"
	var/obj/item/device/flash/flash1 = null
	var/obj/item/device/flash/flash2 = null

/obj/item/robot_parts/robot_suit
	name = "endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"
	var/obj/item/robot_parts/l_arm/l_arm = null
	var/obj/item/robot_parts/r_arm/r_arm = null
	var/obj/item/robot_parts/l_leg/l_leg = null
	var/obj/item/robot_parts/r_leg/r_leg = null
	var/obj/item/robot_parts/chest/chest = null
	var/obj/item/robot_parts/head/head = null
	var/created_name = ""

/obj/item/robot_parts/robot_suit/New()
	..()
	src.updateicon()

/obj/item/robot_parts/robot_suit/proc/updateicon()
	src.overlays.Cut()
	if(src.l_arm)
		src.overlays += "l_arm+o"
	if(src.r_arm)
		src.overlays += "r_arm+o"
	if(src.chest)
		src.overlays += "chest+o"
	if(src.l_leg)
		src.overlays += "l_leg+o"
	if(src.r_leg)
		src.overlays += "r_leg+o"
	if(src.head)
		src.overlays += "head+o"

/obj/item/robot_parts/robot_suit/proc/check_completion()
	if(src.l_arm && src.r_arm)
		if(src.l_leg && src.r_leg)
			if(src.chest && src.head)
				return 1
	return 0

/obj/item/robot_parts/robot_suit/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == MATERIAL_STEEL && !l_arm && !r_arm && !l_leg && !r_leg && !chest && !head)
		var/obj/item/stack/material/M = W
		if (M.use(1))
			var/obj/item/weapon/secbot_assembly/ed209_assembly/B = new /obj/item/weapon/secbot_assembly/ed209_assembly
			B.loc = get_turf(src)
			user << SPAN_NOTICE("You armed the robot frame.")
			if (user.get_inactive_hand()==src)
				user.remove_from_mob(src)
				user.put_in_inactive_hand(B)
			qdel(src)
		else
			user << SPAN_WARNING("You need one sheet of metal to arm the robot frame.")
	if(istype(W, /obj/item/robot_parts/l_leg))
		if(src.l_leg)	return
		user.drop_item()
		W.loc = src
		src.l_leg = W
		src.updateicon()

	if(istype(W, /obj/item/robot_parts/r_leg))
		if(src.r_leg)	return
		user.drop_item()
		W.loc = src
		src.r_leg = W
		src.updateicon()

	if(istype(W, /obj/item/robot_parts/l_arm))
		if(src.l_arm)	return
		user.drop_item()
		W.loc = src
		src.l_arm = W
		src.updateicon()

	if(istype(W, /obj/item/robot_parts/r_arm))
		if(src.r_arm)	return
		user.drop_item()
		W.loc = src
		src.r_arm = W
		src.updateicon()

	if(istype(W, /obj/item/robot_parts/chest))
		if(src.chest)	return
		if(W:wires && W:cell)
			user.drop_item()
			W.loc = src
			src.chest = W
			src.updateicon()
		else if(!W:wires)
			user << SPAN_WARNING("You need to attach wires to it first!")
		else
			user << SPAN_WARNING("You need to attach a cell to it first!")

	if(istype(W, /obj/item/robot_parts/head))
		if(src.head)	return
		if(W:flash2 && W:flash1)
			user.drop_item()
			W.loc = src
			src.head = W
			src.updateicon()
		else
			user << SPAN_WARNING("You need to attach a flash to it first!")

	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(check_completion())
			if(!istype(loc,/turf))
				user << SPAN_WARNING("You can't put \the [W] in, the frame has to be standing on the ground to be perfectly precise.")
				return
			if(!M.brainmob)
				user << SPAN_WARNING("Sticking an empty [W] into the frame would sort of defeat the purpose.")
				return
			if(!M.brainmob.key)
				var/ghost_can_reenter = 0
				if(M.brainmob.mind)
					for(var/mob/observer/ghost/G in player_list)
						if(G.can_reenter_corpse && G.mind == M.brainmob.mind)
							ghost_can_reenter = 1
							break
				if(!ghost_can_reenter)
					user << SPAN_NOTICE("\The [W] is completely unresponsive; there's no point.")
					return

			if(M.brainmob.stat == DEAD)
				user << SPAN_WARNING("Sticking a dead [W] into the frame would sort of defeat the purpose.")
				return

			if(jobban_isbanned(M.brainmob, "Cyborg"))
				user << SPAN_WARNING("This [W] does not seem to fit.")
				return

			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(get_turf(loc), unfinished = 1)
			if(!O)	return

			user.drop_item()

			O.mmi = W
			O.invisibility = 0
			O.custom_name = created_name
			O.updatename("Default")

			M.brainmob.mind.transfer_to(O)

			if(O.mind && player_is_antag(O.mind))
				O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")

			O.job = "Cyborg"

			O.cell = chest.cell
			O.cell.loc = O
			W.loc = O//Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.

			// Since we "magically" installed a cell, we also have to update the correct component.
			if(O.cell)
				var/datum/robot_component/cell_component = O.components["power cell"]
				cell_component.wrapped = O.cell
				cell_component.installed = 1

			callHook("borgify", list(O))
			O.Namepick()

			qdel(src)
		else
			user << SPAN_WARNING("The MMI must go in after everything else!")

	if (istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", src.name, src.created_name), MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t

	return

/obj/item/robot_parts/chest/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/cell/large))
		if(src.cell)
			user << SPAN_WARNING("You have already inserted a cell!")
			return
		else
			user.drop_item()
			W.loc = src
			src.cell = W
			user << SPAN_NOTICE("You insert the cell!")
	if(istype(W, /obj/item/stack/cable_coil))
		if(src.wires)
			user << SPAN_WARNING("You have already inserted wire!")
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			coil.use(1)
			src.wires = 1.0
			user << SPAN_NOTICE("You insert the wire!")
	return

/obj/item/robot_parts/head/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/device/flash))
		if(isrobot(user))
			var/current_module = user.get_active_hand()
			if(current_module == W)
				user << SPAN_WARNING("How do you propose to do that?")
				return
			else
				add_flashes(W,user)
		else
			add_flashes(W,user)
	else if(istype(W, /obj/item/weapon/stock_parts/manipulator))
		user << SPAN_NOTICE("You install some manipulators and modify the head, creating a functional spider-bot!")
		new /mob/living/simple_animal/spiderbot(get_turf(loc))
		user.drop_item()
		qdel(W)
		qdel(src)
		return
	return

/obj/item/robot_parts/head/proc/add_flashes(obj/item/W as obj, mob/user as mob) //Made into a seperate proc to avoid copypasta
	if(src.flash1 && src.flash2)
		user << SPAN_NOTICE("You have already inserted the eyes!")
		return
	else if(src.flash1)
		user.drop_item()
		W.loc = src
		src.flash2 = W
		user << SPAN_NOTICE("You insert the flash into the eye socket!")
	else
		user.drop_item()
		W.loc = src
		src.flash1 = W
		user << SPAN_NOTICE("You insert the flash into the eye socket!")
