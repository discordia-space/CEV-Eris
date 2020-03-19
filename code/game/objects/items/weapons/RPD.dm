//Contains the rapid piping device. Copied over largely from pipe_dispenser and RCD files.
/obj/item/weapon/rpd
	name = "rapid piping device"
	desc = "A device used to rapidly build pipes."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rcd" //Same as RCD, currentely.
	opacity = 0
	density = 0
	anchored = 0.0
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2) //Redundant values that yer free ta' change later.
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASMA = 2, MATERIAL_PLASTIC = 5) //Redundant values that yer free ta' change later.
	price_tag = 500 //Redundant values that yer free ta' change later.
	var/use_power_cost = 1.5
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/medium
	var/wait = 0
	var/pipe_type = 0
	var/p_dir = 1

/obj/item/weapon/rpd/attack()
	return 0

/obj/item/weapon/rpd/proc/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && user.get_active_hand() == src && !user.stat && !user.restrained())

/obj/item/weapon/rpd/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
	else
		return ..()

/obj/item/weapon/rpd/attackby(obj/item/C, mob/living/user, obj/item/I)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C
	return

/obj/item/weapon/rpd/proc/useCharge()
	//Use charge from the cell.
	if(!cell||!cell.checked_use(use_power_cost))
		return 0
	return 1

/obj/item/weapon/rpd/proc/deletePipe(var/turf/T)
	if(istype(T, /obj/item/pipe) || istype(T, /obj/item/pipe_meter))
		qdel(T)
		return 1
	return 0

/obj/item/weapon/rpd/attack_self(mob/user)
	//Open pipe dispenser window.
	.=..()
	if(.) return
///// Z-Level stuff
	var/dat = {"
<b>Regular pipes:</b><BR>
<A href='?src=\ref[src];make=0;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=1;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=5;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=8;dir=1'>Manual Valve</A><BR>
<A href='?src=\ref[src];make=20;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=19;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=18;dir=1'>Manual T-Valve</A><BR>
<A href='?src=\ref[src];make=43;dir=1'>Manual T-Valve - Mirrored</A><BR>
<A href='?src=\ref[src];make=21;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=22;dir=1'>Downward Pipe</A><BR>
<b>Supply pipes:</b><BR>
<A href='?src=\ref[src];make=29;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=30;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=33;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=41;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=35;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=37;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=39;dir=1'>Downward Pipe</A><BR>
<b>Scrubbers pipes:</b><BR>
<A href='?src=\ref[src];make=31;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=32;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=34;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=42;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=36;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=38;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=40;dir=1'>Downward Pipe</A><BR>
<b>Devices:</b><BR>
<A href='?src=\ref[src];make=28;dir=1'>Universal pipe adapter</A><BR>
<A href='?src=\ref[src];make=4;dir=1'>Connector</A><BR>
<A href='?src=\ref[src];make=7;dir=1'>Unary Vent</A><BR>
<A href='?src=\ref[src];make=9;dir=1'>Gas Pump</A><BR>
<A href='?src=\ref[src];make=15;dir=1'>Pressure Regulator</A><BR>
<A href='?src=\ref[src];make=16;dir=1'>High Power Gas Pump</A><BR>
<A href='?src=\ref[src];make=10;dir=1'>Scrubber</A><BR>
<A href='?src=\ref[src];makemeter=1;dir=0'>Meter</A><BR>
<A href='?src=\ref[src];make=13;dir=1'>Gas Filter</A><BR>
<A href='?src=\ref[src];make=23;dir=1'>Gas Filter - Mirrored</A><BR>
<A href='?src=\ref[src];make=14;dir=1'>Gas Mixer</A><BR>
<A href='?src=\ref[src];make=25;dir=1'>Gas Mixer - Mirrored</A><BR>
<A href='?src=\ref[src];make=24;dir=1'>Gas Mixer - T</A><BR>
<A href='?src=\ref[src];make=26;dir=1'>Omni Gas Mixer</A><BR>
<A href='?src=\ref[src];make=27;dir=1'>Omni Gas Filter</A><BR>
<b>Heat exchange:</b><BR>
<A href='?src=\ref[src];make=2;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=3;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=6;dir=1'>Junction</A><BR>
<A href='?src=\ref[src];make=17;dir=1'>Heat Exchanger</A><BR>
<b>Insulated pipes:</b><BR>
<A href='?src=\ref[src];make=11;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=12;dir=5'>Bent Pipe</A><BR>

"}
///// Z-Level stuff
//What number the make points to is in the define # at the top of construction.dm in same folder

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	onclose(user, "pipedispenser")
	return

/obj/item/weapon/rpd/Topic(href, href_list)

	if(..())
		return
	if(href_list["make"])
		pipe_type = text2num(href_list["make"])
		p_dir = text2num(href_list["dir"])
	if(href_list["makemeter"])
		p_dir = text2num(href_list["dir"]) //If direction is 0, the pipe is pipe_meter.

/obj/item/weapon/rpd/afterattack(atom/A, mob/user, proximity)
	if(wait)
	//So that charge isn't used while wait is true. Doesnae solve the charge use bug, but does partially solve it.
		return 0
	if(!proximity)
		return
	if(!can_use(user,A))
		return 0
	if(istype(get_area(A),/area/shuttle)||istype(get_area(A),/turf/space/transit))
		return 0
	if(!useCharge(user))
		to_chat(user, SPAN_WARNING("[src] battery is dead or missing."))
		return 0
	if(deletePipe(A))
		to_chat(user, SPAN_NOTICE("You put [A] back to [src]."))
		return
	if(!p_dir == 0) //If direction is 0, the pipe is pipe_meter, otherwise it's one of the pipes.
		if(!wait)
			var/obj/item/pipe/P = new (A, pipe_type=pipe_type, dir=p_dir)
			P.update()
			P.add_fingerprint(usr)
			wait = 1
			spawn(10)
				wait = 0
	if(!wait)
		new /obj/item/pipe_meter(A)
		wait = 1
		spawn(15)
			wait = 0
	return

/obj/item/weapon/rpd/borg

/obj/item/weapon/rpd/borg/useCharge(mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		return R.cell && R.cell.checked_use(use_power_cost*30) //Redundant power use multiplier.
	return ..()

/obj/item/weapon/rpd/borg/attackby()
	return

/obj/item/weapon/rpd/borg/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat)