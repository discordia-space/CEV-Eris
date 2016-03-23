/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300
	var/circuit = null //The path to the circuit board type. If circuit==null, the computer can't be disassembled.
	var/processing = 0

	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/light_range_on = 2
	var/light_power_on = 1
	var/overlay_layer

/obj/machinery/computer/New()
	overlay_layer = layer
	..()

/obj/machinery/computer/initialize()
	power_change()
	update_icon()

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	return 1

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken()
	..()


/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		if(3.0)
			if (prob(25))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		else
	return

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.get_structure_damage()))
		set_broken()
	..()

/obj/machinery/computer/update_icon()
	overlays.Cut()
	if(stat & NOPOWER)
		set_light(0)
		if(icon_keyboard)
			overlays += image(icon,"[icon_keyboard]_off", overlay_layer)
		return
	else
		set_light(light_range_on, light_power_on)

	if(stat & BROKEN)
		overlays += image(icon,"[icon_state]_broken", overlay_layer)
	else
		overlays += image(icon,icon_screen, overlay_layer)

	if(icon_keyboard)
		overlays += image(icon, icon_keyboard, overlay_layer)

/obj/machinery/computer/power_change()
	..()
	update_icon()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range_on, light_power_on)


/obj/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver) && circuit)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/weapon/circuitboard/M = new circuit( A )
			A.circuit = M
			A.anchored = 1
			for (var/obj/C in src)
				C.loc = src.loc
			if (src.stat & BROKEN)
				user << "<span class='notice'>The broken glass falls out.</span>"
				new /obj/item/weapon/material/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				user << "<span class='notice'>You disconnect the monitor.</span>"
				A.state = 4
				A.icon_state = "4"
			M.deconstruct(src)
			qdel(src)
	else
		..()

/obj/machinery/computer/Topic(href, href_list)
	if(..())
		return 1
	//var/CurrentDir = get_dir(src, usr)
	//if ((CurrentDir == src.dir) || (CurrentDir == turn(src.dir, 45)) || (CurrentDir == turn(src.dir, -45)))
	if (CheckFace(src,usr))
		keyboardsound(usr)
		return 0
	else
		usr << "you need stay face to console"
		return 1

/obj/proc/keyboardsound(mob/user as mob)
	if(!issilicon(user))
		playsound(src, "keyboard", 100, 1, 0)

/obj/machinery/computer/attack_hand(mob/user as mob)//check mob direction
	if(..())
		return 1
	if(istype(user, /mob/living/silicon))
		return 0
	/*if((src.dir == 1) && (user.y - src.y == 1)) //NORTH
		if((src.x == user.x) || (src.x - user.x == 1) || (user.x - src.x == 1))
			keyboardsound(user)
			world << "N"
			return 0
	else if(src.dir == 2 && (src.y - user.y == 1)) //SOUTH
		if((src.x == user.x) || (src.x - user.x == 1) || (user.x - src.x == 1))
			keyboardsound(user)
			world << "S"
			return 0
	else if(src.dir == 4 && (user.x - src.x == 1)) //EAST
		if((src.y == user.y) || (src.y - user.y == 1) || (user.y - src.y == 1))
			keyboardsound(user)
			world << "E"
			return 0
	else if(src.dir == 8 && (src.x - user.x == 1)) //WEST
		if((src.y == user.y) || (src.y - user.y == 1) || (user.y - src.y == 1))
			keyboardsound(user)
			world << "W"
			return 0*/
	//var/CurrentDir = get_dir(src, user)
	//if ((CurrentDir == src.dir) || (CurrentDir == turn(src.dir, 45)) || (CurrentDir == turn(src.dir, -45)))
	//if(get_dir(src, user) & (src.dir | turn(src.dir, 45) | turn(src.dir, -45)) )
	if (CheckFace(src,user))
		keyboardsound(user)
		return 0
	else
		user << "you need stay face to console"
		return 1
