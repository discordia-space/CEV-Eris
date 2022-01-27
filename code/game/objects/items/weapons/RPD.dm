//Contains the rapid piping device. Copied over largely from pipe_dispenser and RCD files.
/obj/item/rpd
	name = "rapid piping device"
	desc = "A device used to rapidly build pipes."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rpd" //By Toriate, according to Kurgis.
	opacity = 0
	density = FALSE
	anchored = FALSE
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2) //Redundant69alues that yer free ta' change later.
	matter = list(MATERIAL_STEEL = 10,69ATERIAL_PLASMA = 2,69ATERIAL_PLASTIC = 5) //Redundant69alues that yer free ta' change later.
	price_tag = 500 //Redundant69alues that yer free ta' change later.
	var/use_power_cost = 1.5
	var/obj/item/cell/cell
	var/suitable_cell = /obj/item/cell/medium
	var/wait = 0
	var/pipe_type = 0
	var/p_dir = 1

/obj/item/rpd/attack()
	return 0

/obj/item/rpd/proc/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && user.get_active_hand() == src && !user.stat && !user.restrained())

/obj/item/rpd/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
	else
		return ..()

/obj/item/rpd/attackby(obj/item/C,69ob/living/user, obj/item/I)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C
	return

/obj/item/rpd/proc/useCharge()
	//Use charge from the cell.
	if(!cell||!cell.checked_use(use_power_cost))
		return 0
	return 1

/obj/item/rpd/proc/deletePipe(var/turf/T)
	if(istype(T, /obj/item/pipe) || istype(T, /obj/item/pipe_meter))
		69del(T)
		return 1
	return 0

/obj/item/rpd/attack_self(mob/user)
	//Open pipe dispenser window.
	.=..()
	if(.) return
	var/dat = {"
<b>Regular pipes:</b><BR>
<A href='?src=\ref69src69;make=69PIPE_SIMPLE_STRAIGHT69;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SIMPLE_BENT69;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_MANIFOLD69;dir=1'>Manifold</A><BR>
<A href='?src=\ref69src69;make=69PIPE_MVALVE69;dir=1'>Manual69alve</A><BR>
<A href='?src=\ref69src69;make=69PIPE_CAP69;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref69src69;make=69PIPE_MANIFOLD4W69;dir=1'>4-Way69anifold</A><BR>
<A href='?src=\ref69src69;make=69PIPE_MTVALVE69;dir=1'>Manual T-Valve</A><BR>
<A href='?src=\ref69src69;make=69PIPE_MTVALVEM69;dir=1'>Manual T-Valve -69irrored</A><BR>
<A href='?src=\ref69src69;make=69PIPE_UP69;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_DOWN69;dir=1'>Downward Pipe</A><BR>
<b>Supply pipes:</b><BR>
<A href='?src=\ref69src69;make=69PIPE_SUPPLY_STRAIGHT69;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SUPPLY_BENT69;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SUPPLY_MANIFOLD69;dir=1'>Manifold</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SUPPLY_CAP69;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SUPPLY_MANIFOLD4W69;dir=1'>4-Way69anifold</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SUPPLY_UP69;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SUPPLY_DOWN69;dir=1'>Downward Pipe</A><BR>
<b>Scrubbers pipes:</b><BR>
<A href='?src=\ref69src69;make=69PIPE_SCRUBBERS_STRAIGHT69;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SCRUBBERS_BENT69;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SCRUBBERS_MANIFOLD69;dir=1'>Manifold</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SCRUBBERS_CAP69;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SCRUBBERS_MANIFOLD4W69;dir=1'>4-Way69anifold</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SCRUBBERS_UP69;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SCRUBBERS_DOWN69;dir=1'>Downward Pipe</A><BR>
<b>Devices:</b><BR>
<A href='?src=\ref69src69;make=69PIPE_UNIVERSAL69;dir=1'>Universal pipe adapter</A><BR>
<A href='?src=\ref69src69;make=69PIPE_CONNECTOR69;dir=1'>Connector</A><BR>
<A href='?src=\ref69src69;make=69PIPE_UVENT69;dir=1'>Unary69ent</A><BR>
<A href='?src=\ref69src69;make=69PIPE_PUMP69;dir=1'>Gas Pump</A><BR>
<A href='?src=\ref69src69;make=69PIPE_PASSIVE_GATE69;dir=1'>Pressure Regulator</A><BR>
<A href='?src=\ref69src69;make=69PIPE_VOLUME_PUMP69;dir=1'>High Power Gas Pump</A><BR>
<A href='?src=\ref69src69;make=69PIPE_SCRUBBER69;dir=1'>Scrubber</A><BR>
<A href='?src=\ref69src69;makemeter=1;dir=0'>Meter</A><BR>
<A href='?src=\ref69src69;make=69PIPE_GAS_FILTER69;dir=1'>Gas Filter</A><BR>
<A href='?src=\ref69src69;make=69PIPE_GAS_FILTER_M69;dir=1'>Gas Filter -69irrored</A><BR>
<A href='?src=\ref69src69;make=69PIPE_GAS_MIXER69;dir=1'>Gas69ixer</A><BR>
<A href='?src=\ref69src69;make=69PIPE_GAS_MIXER_M69;dir=1'>Gas69ixer -69irrored</A><BR>
<A href='?src=\ref69src69;make=69PIPE_GAS_MIXER_T69;dir=1'>Gas69ixer - T</A><BR>
<A href='?src=\ref69src69;make=69PIPE_OMNI_MIXER69;dir=1'>Omni Gas69ixer</A><BR>
<A href='?src=\ref69src69;make=69PIPE_OMNI_FILTER69;dir=1'>Omni Gas Filter</A><BR>
<b>Heat exchange:</b><BR>
<A href='?src=\ref69src69;make=69PIPE_HE_STRAIGHT69;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_HE_BENT69;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_JUNCTION69;dir=1'>Junction</A><BR>
<A href='?src=\ref69src69;make=69PIPE_HEAT_EXCHANGE69;dir=1'>Heat Exchanger</A><BR>
<b>Insulated pipes:</b><BR>
<A href='?src=\ref69src69;make=69PIPE_INSULATED_STRAIGHT69;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=69PIPE_INSULATED_BENT69;dir=5'>Bent Pipe</A><BR>

"}
///// Z-Level stuff
//What number the69ake points to is in the define # at the top of construction.dm in same folder

	user << browse("<HEAD><TITLE>69src69</TITLE></HEAD><TT>69dat69</TT>", "window=pipedispenser")
	onclose(user, "pipedispenser")
	return

/obj/item/rpd/Topic(href, href_list)

	if(..())
		return
	if(href_list69"make"69)
		pipe_type = text2num(href_list69"make"69)
		p_dir = text2num(href_list69"dir"69)
	if(href_list69"makemeter"69)
		p_dir = text2num(href_list69"dir"69) //If direction is 0, the pipe is pipe_meter.

/obj/item/rpd/afterattack(atom/A,69ob/user, proximity)
	if(wait)
		return 0
	if(!proximity)
		return
	if(!can_use(user,A))
		return 0
	if(istype(get_area(A),/area/shuttle)||istype(get_area(A),/turf/space/transit))
		return 0
	if(!useCharge(user))
		to_chat(user, SPAN_WARNING("69src69 battery is dead or69issing."))
		return 0
	if(deletePipe(A))
		to_chat(user, SPAN_NOTICE("You put 69A69 back to 69src69."))
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

/obj/item/rpd/borg
	spawn_tags = null


/obj/item/rpd/borg/useCharge(mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		return R.cell && R.cell.checked_use(use_power_cost*30) //Redundant power use69ultiplier.
	return ..()

/obj/item/rpd/borg/attackby()
	return

/obj/item/rpd/borg/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat)