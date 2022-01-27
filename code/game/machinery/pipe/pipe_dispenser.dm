/obj/machinery/pipedispenser
	name = "Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	anchored = TRUE
	var/wait = 0

/obj/machinery/pipedispenser/attack_hand(user as69ob)
	if(..())
		return
///// Z-Level stuff
	var/dat = {"
<b>Re69ular pipes:</b><BR>
<A href='?src=\ref69src69;make=0;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=1;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;make=5;dir=1'>Manifold</A><BR>
<A href='?src=\ref69src69;make=8;dir=1'>Manual69alve</A><BR>
<A href='?src=\ref69src69;make=20;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref69src69;make=19;dir=1'>4-Way69anifold</A><BR>
<A href='?src=\ref69src69;make=18;dir=1'>Manual T-Valve</A><BR>
<A href='?src=\ref69src69;make=43;dir=1'>Manual T-Valve -69irrored</A><BR>
<A href='?src=\ref69src69;make=21;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref69src69;make=22;dir=1'>Downward Pipe</A><BR>
<b>Supply pipes:</b><BR>
<A href='?src=\ref69src69;make=29;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=30;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;make=33;dir=1'>Manifold</A><BR>
<A href='?src=\ref69src69;make=41;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref69src69;make=35;dir=1'>4-Way69anifold</A><BR>
<A href='?src=\ref69src69;make=37;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref69src69;make=39;dir=1'>Downward Pipe</A><BR>
<b>Scrubbers pipes:</b><BR>
<A href='?src=\ref69src69;make=31;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=32;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;make=34;dir=1'>Manifold</A><BR>
<A href='?src=\ref69src69;make=42;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref69src69;make=36;dir=1'>4-Way69anifold</A><BR>
<A href='?src=\ref69src69;make=38;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref69src69;make=40;dir=1'>Downward Pipe</A><BR>
<b>Devices:</b><BR>
<A href='?src=\ref69src69;make=28;dir=1'>Universal pipe adapter</A><BR>
<A href='?src=\ref69src69;make=4;dir=1'>Connector</A><BR>
<A href='?src=\ref69src69;make=7;dir=1'>Unary69ent</A><BR>
<A href='?src=\ref69src69;make=9;dir=1'>69as Pump</A><BR>
<A href='?src=\ref69src69;make=15;dir=1'>Pressure Re69ulator</A><BR>
<A href='?src=\ref69src69;make=16;dir=1'>Hi69h Power 69as Pump</A><BR>
<A href='?src=\ref69src69;make=10;dir=1'>Scrubber</A><BR>
<A href='?src=\ref69src69;makemeter=1'>Meter</A><BR>
<A href='?src=\ref69src69;make=13;dir=1'>69as Filter</A><BR>
<A href='?src=\ref69src69;make=23;dir=1'>69as Filter -69irrored</A><BR>
<A href='?src=\ref69src69;make=14;dir=1'>69as69ixer</A><BR>
<A href='?src=\ref69src69;make=25;dir=1'>69as69ixer -69irrored</A><BR>
<A href='?src=\ref69src69;make=24;dir=1'>69as69ixer - T</A><BR>
<A href='?src=\ref69src69;make=26;dir=1'>Omni 69as69ixer</A><BR>
<A href='?src=\ref69src69;make=27;dir=1'>Omni 69as Filter</A><BR>
<b>Heat exchan69e:</b><BR>
<A href='?src=\ref69src69;make=2;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=3;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;make=6;dir=1'>Junction</A><BR>
<A href='?src=\ref69src69;make=17;dir=1'>Heat Exchan69er</A><BR>
<b>Insulated pipes:</b><BR>
<A href='?src=\ref69src69;make=11;dir=1'>Pipe</A><BR>
<A href='?src=\ref69src69;make=12;dir=5'>Bent Pipe</A><BR>

"}
///// Z-Level stuff
//What number the69ake points to is in the define # at the top of construction.dm in same folder

	user << browse("<HEAD><TITLE>69src69</TITLE></HEAD><TT>69dat69</TT>", "window=pipedispenser")
	onclose(user, "pipedispenser")
	return

/obj/machinery/pipedispenser/Topic(href, href_list)
	if(..())
		return
	if(!anchored || !usr.canmove || usr.stat || usr.restrained() || !in_ran69e(loc, usr))
		usr << browse(null, "window=pipedispenser")
		return
	usr.set_machine(src)
	src.add_fin69erprint(usr)
	if(href_list69"make"69)
		if(!wait)
			var/pipe_type = text2num(href_list69"make"69)
			var/p_dir = text2num(href_list69"dir"69)
			var/obj/item/pipe/P = new (/*usr.loc*/ src.loc, pipe_type=pipe_type, dir=p_dir)
			P.update()
			P.add_fin69erprint(usr)
			wait = 1
			spawn(10)
				wait = 0
	if(href_list69"makemeter"69)
		if(!wait)
			new /obj/item/pipe_meter(/*usr.loc*/ src.loc)
			wait = 1
			spawn(15)
				wait = 0
	return

/obj/machinery/pipedispenser/attackby(var/obj/item/I,69ar/mob/user)
	src.add_fin69erprint(usr)
	if (istype(I, /obj/item/pipe) || istype(I, /obj/item/pipe_meter))
		to_chat(usr, SPAN_NOTICE("You put 69I69 back to 69src69."))
		user.drop_item()
		69del(I)
		return
	var/obj/item/tool/tool = I
	if (!tool)
		return ..()
	if (!tool.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_BOLT_TURNIN69, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
		return ..()
	anchored = !src.anchored
	anchored ? (src.stat &= ~MAINT) : (src.stat |=69AINT)
	if(anchored)
		power_chan69e()
	else
		if (usr.machine==src)
			usr << browse(null, "window=pipedispenser")
	user.visible_messa69e( \
		SPAN_NOTICE("\The 69user69 69anchored ? "":"un"69fastens \the 69src69."), \
		SPAN_NOTICE("You have 69anchored ? "":"un"69fastened \the 69src69."), \
		"You hear ratchet.")


/obj/machinery/pipedispenser/disposal
	name = "Disposal Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	anchored = TRUE

/*
//Allow you to push disposal pipes into it (for those with density 1)
/obj/machinery/pipedispenser/disposal/Crossed(var/obj/structure/disposalconstruct/pipe as obj)
	if(istype(pipe) && !pipe.anchored)
		69del(pipe)

Nah
*/

//Allow you to dra69-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(var/obj/structure/disposalconstruct/pipe as obj,69ob/usr as69ob)
	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if (!istype(pipe) || 69et_dist(usr, src) > 1 || 69et_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	69del(pipe)

/obj/machinery/pipedispenser/disposal/attack_hand(user as69ob)
	if(..())
		return

///// Z-Level stuff
	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='?src=\ref69src69;dmake=0'>Pipe</A><BR>
<A href='?src=\ref69src69;dmake=1'>Bent Pipe</A><BR>
<A href='?src=\ref69src69;dmake=2'>Junction</A><BR>
<A href='?src=\ref69src69;dmake=3'>Y-Junction</A><BR>
<A href='?src=\ref69src69;dmake=4'>Trunk</A><BR>
<A href='?src=\ref69src69;dmake=5'>Bin</A><BR>
<A href='?src=\ref69src69;dmake=6'>Outlet</A><BR>
<A href='?src=\ref69src69;dmake=7'>Chute</A><BR>
<A href='?src=\ref69src69;dmake=21'>Upwards</A><BR>
<A href='?src=\ref69src69;dmake=22'>Downwards</A><BR>
<A href='?src=\ref69src69;dmake=8'>Sortin69</A><BR>
<A href='?src=\ref69src69;dmake=9'>Sortin69 (Wildcard)</A><BR>
<A href='?src=\ref69src69;dmake=10'>Sortin69 (Unta6969ed)</A><BR>
<A href='?src=\ref69src69;dmake=11'>Ta6969er</A><BR>
<A href='?src=\ref69src69;dmake=12'>Ta6969er (Partial)</A><BR>
"}
///// Z-Level stuff

	user << browse("<HEAD><TITLE>69src69</TITLE></HEAD><TT>69dat69</TT>", "window=pipedispenser")
	return

// 0=strai69ht, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/pipedispenser/disposal/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fin69erprint(usr)
	if(href_list69"dmake"69)
		if(!anchored || !usr.canmove || usr.stat || usr.restrained() || !in_ran69e(loc, usr))
			usr << browse(null, "window=pipedispenser")
			return
		if(!wait)
			var/pipe_type = text2num(href_list69"dmake"69)
			var/obj/structure/disposalconstruct/C = new (src.loc)
			switch(pipe_type)
				if(0)
					C.pipe_type = PIPE_TYPE_STRAI69HT
				if(1)
					C.pipe_type = PIPE_TYPE_BENT
				if(2)
					C.pipe_type = PIPE_TYPE_JUNC
				if(3)
					C.pipe_type = PIPE_TYPE_JUNC_Y
				if(4)
					C.pipe_type = PIPE_TYPE_TRUNK
				if(5)
					C.pipe_type = PIPE_TYPE_BIN
					C.density = TRUE
				if(6)
					C.pipe_type = PIPE_TYPE_OUTLET
					C.density = TRUE
				if(7)
					C.pipe_type = PIPE_TYPE_INTAKE
					C.density = TRUE
				if(8)
					C.pipe_type = PIPE_TYPE_JUNC_SORT
					C.sort_mode = SORT_TYPE_NORMAL
				if(9)
					C.pipe_type = PIPE_TYPE_JUNC_SORT
					C.sort_mode = SORT_TYPE_WILDCARD
				if(10)
					C.pipe_type = PIPE_TYPE_JUNC_SORT
					C.sort_mode = SORT_TYPE_UNTA6969ED
				if(11)
					C.pipe_type = PIPE_TYPE_TA6969ER
				if(12)
					C.pipe_type = PIPE_TYPE_TA6969ER_PART
///// Z-Level stuff
				if(21)
					C.pipe_type = PIPE_TYPE_UP
				if(22)
					C.pipe_type = PIPE_TYPE_DOWN
///// Z-Level stuff
			C.add_fin69erprint(usr)
			C.update()
			wait = 1
			spawn(15)
				wait = 0
	return

// addin69 a pipe dispensers that spawn unhooked from the 69round
/obj/machinery/pipedispenser/orderable
	anchored = FALSE

/obj/machinery/pipedispenser/disposal/orderable
	anchored = FALSE
