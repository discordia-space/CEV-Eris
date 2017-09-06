//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null
//	weight = 1.0E8

/obj/structure/computerframe/verb/rotate()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return
	if(anchored)
		usr << "It is fastened to the floor!"
		return 0
	set_dir(turn(dir, -90))
	return 1

/obj/structure/computerframe/AltClick(mob/user)
	..()
	if(user.incapacitated())
		user << SPAN_WARNING("You can't do that right now!")
		return
	if(!in_range(src, user))
		return
	else
		rotate()

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20, src))
					user << SPAN_NOTICE("You wrench the frame into place.")
					src.anchored = 1
					src.state = 1
			if(istype(P, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = P
				if(!WT.remove_fuel(0, user))
					user << "The welding tool must be on to complete this task."
					return
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20, src))
					if(!src || !WT.isOn()) return
					user << SPAN_NOTICE("You deconstruct the frame.")
					new /obj/item/stack/material/steel( src.loc, 5 )
					qdel(src)
		if(1)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20, src))
					user << SPAN_NOTICE("You unfasten the frame.")
					src.anchored = 0
					src.state = 0
			if(istype(P, /obj/item/weapon/circuitboard) && !circuit)
				var/obj/item/weapon/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << SPAN_NOTICE("You place the circuit board inside the frame.")
					src.icon_state = "1"
					src.circuit = P
					user.drop_from_inventory(P)
					P.forceMove(src)
				else
					user << SPAN_WARNING("This frame does not accept circuit boards of this type!")
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << SPAN_NOTICE("You screw the circuit board into place.")
				src.state = 2
				src.icon_state = "2"
			if(istype(P, /obj/item/weapon/crowbar) && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << SPAN_NOTICE("You remove the circuit board.")
				src.state = 1
				src.icon_state = "0"
				circuit.loc = src.loc
				src.circuit = null
		if(2)
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << SPAN_NOTICE("You unfasten the circuit board.")
				src.state = 1
				src.icon_state = "1"
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					user << SPAN_WARNING("You need five coils of wire to add them to the frame.")
					return
				user << SPAN_NOTICE("You start to add cables to the frame.")
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20, src) && state == 2)
					if (C.use(5))
						user << SPAN_NOTICE("You add cables to the frame.")
						state = 3
						icon_state = "3"
		if(3)
			if(istype(P, /obj/item/weapon/wirecutters))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << SPAN_NOTICE("You remove the cables.")
				src.state = 2
				src.icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(src.loc)
				A.amount = 5

			if(istype(P, /obj/item/stack/material) && P.get_material_name() == "glass")
				var/obj/item/stack/G = P
				if (G.get_amount() < 2)
					user << SPAN_WARNING("You need two sheets of glass to put in the glass panel.")
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << SPAN_NOTICE("You start to put in the glass panel.")
				if(do_after(user, 20, src) && state == 3)
					if (G.use(2))
						user << SPAN_NOTICE("You put in the glass panel.")
						src.state = 4
						src.icon_state = "4"
		if(4)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << SPAN_NOTICE("You remove the glass panel.")
				src.state = 3
				src.icon_state = "3"
				new /obj/item/stack/material/glass(src.loc, 2)
			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << SPAN_NOTICE("You connect the monitor.")
				var/B = new src.circuit.build_path(src.loc, src.dir)
				src.circuit.construct(B)
				qdel(src)
