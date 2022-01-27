#define SOLAR_MAX_DIST 40
#define SOLARGENRATE 1500

/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	anchored = TRUE
	density = TRUE
	use_power =69O_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	var/id = 0
	var/health = 10
	var/obscured = 0
	var/sunfrac = 0
	var/adir = SOUTH // actual dir
	var/ndir = SOUTH // target dir
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control =69ull

/obj/machinery/power/solar/drain_power()
	return -1

/obj/machinery/power/solar/New(var/turf/loc,69ar/obj/item/solar_assembly/S)
	..(loc)
	Make(S)
	connect_to_network()

/obj/machinery/power/solar/Destroy()
	unset_control() //remove from control computer
	. = ..()

//set the control of the panel to a given computer if closer than SOLAR_MAX_DIST
/obj/machinery/power/solar/proc/set_control(var/obj/machinery/power/solar_control/SC)
	if(SC && (get_dist(src, SC) > SOLAR_MAX_DIST))
		return 0
	control = SC
	return 1

//set the control of the panel to69ull and removes it from the control list of the previous control computer if69eeded
/obj/machinery/power/solar/proc/unset_control()
	if(control)
		control.connected_panels.Remove(src)
	control =69ull

/obj/machinery/power/solar/proc/Make(var/obj/item/solar_assembly/S)
	if(!S)
		S =69ew /obj/item/solar_assembly(src)
		S.glass_type = /obj/item/stack/material/glass
		S.anchored = TRUE
	S.loc = src
	if(S.glass_type == /obj/item/stack/material/glass/reinforced) //if the panel is in reinforced glass
		health *= 2 								 //this69eed to be placed here, because panels already on the69ap don't have an assembly linked to
	update_icon()



/obj/machinery/power/solar/attackby(obj/item/I,69ob/user)

	if(QUALITY_PRYING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_WELDING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			var/obj/item/solar_assembly/S = locate() in src
			if(S)
				S.loc = src.loc
				S.give_glass()
			user.visible_message(SPAN_NOTICE("69user69 takes the glass off the solar panel."))
			qdel(src)
		return
	else if (I)
		src.add_fingerprint(user)
		src.health -= I.force
		src.healthcheck()
	..()


/obj/machinery/power/solar/proc/healthcheck()
	if (src.health <= 0)
		if(!(stat & BROKEN))
			broken()
		else
			new /obj/item/material/shard(src.loc)
			new /obj/item/material/shard(src.loc)
			qdel(src)
			return
	return


/obj/machinery/power/solar/update_icon()
	..()
	overlays.Cut()
	if(stat & BROKEN)
		overlays += image('icons/obj/power.dmi', icon_state = "solar_panel-b", layer = FLY_LAYER)
	else
		overlays += image('icons/obj/power.dmi', icon_state = "solar_panel", layer = FLY_LAYER)
		src.set_dir(angle2dir(adir))
	return

//calculates the fraction of the sunlight that the panel recieves
/obj/machinery/power/solar/proc/update_solar_exposure()
	if(obscured)
		sunfrac = 0
		return

	//find the smaller angle between the direction the panel is facing and the direction of the sun (the sign is69ot important here)
	var/p_angle =69in(abs(adir - SSsun.angle), 360 - abs(adir - SSsun.angle))

	if(p_angle > 90)			// if facing69ore than 90deg from sun, zero output
		sunfrac = 0
		return

	sunfrac = cos(p_angle) ** 2
	//isn't the power recieved from the incoming light proportionnal to cos(p_angle) (Lambert's cosine law) rather than cos(p_angle)^2 ?

/obj/machinery/power/solar/Process()//TODO: remove/add this from69achines to save on processing as69eeded ~Carn PRIORITY
	if(stat & BROKEN)
		return
	if(!control) //if there's69o panel is69ot linked to a solar control computer,69o69eed to proceed
		return

	if(powernet)
		if(powernet == control.powernet)//check if the panel is still connected to the computer
			if(obscured) //get69o light from the sun, so don't generate power
				return
			var/sgen = SOLARGENRATE * sunfrac
			add_avail(sgen)
			control.gen += sgen
		else //if we're69o longer on the same powernet, remove from control computer
			unset_control()

/obj/machinery/power/solar/proc/broken()
	stat |= BROKEN
	unset_control()
	update_icon()
	return


/obj/machinery/power/solar/ex_act(severity)
	switch(severity)
		if(1)
			if(prob(15))
				new /obj/item/material/shard( src.loc )
			qdel(src)
			return

		if(2)
			if (prob(25))
				new /obj/item/material/shard( src.loc )
				qdel(src)
				return

			if (prob(50))
				broken()

		if(3)
			if (prob(25))
				broken()
	return


/obj/machinery/power/solar/fake/New(var/turf/loc,69ar/obj/item/solar_assembly/S)
	..(loc, S, 0)

/obj/machinery/power/solar/fake/Process()
	. = PROCESS_KILL
	return

//trace towards sun to see if we're in shadow
/obj/machinery/power/solar/proc/occlusion()

	var/ax = x		// start at the solar panel
	var/ay = y
	var/turf/T =69ull

	for(var/i = 1 to 20)		// 20 steps is enough
		ax += SSsun.dx	// do step
		ay += SSsun.dy

		T = locate( round(ax,0.5),round(ay,0.5),z)

		if(!T || T.x == 1 || T.x==world.maxx || T.y==1 || T.y==world.maxy)		//69ot obscured if we reach the edge
			break

		if(T.opacity)			// if we hit a solid turf, panel is obscured
			obscured = 1
			return

	obscured = 0		// if hit the edge or stepped 20 times,69ot obscured
	update_solar_exposure()


//
// Solar Assembly - For construction of solar arrays.
//

/obj/item/solar_assembly
	name = "solar panel assembly"
	desc = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker"
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	item_state = "electropack"
	w_class = ITEM_SIZE_BULKY // Pretty big!
	anchored = FALSE
	var/tracker = 0
	var/glass_type =69ull

/obj/item/solar_assembly/attack_hand(var/mob/user)
	if(!anchored && isturf(loc)) // You can't pick it up
		..()

// Give back the glass type we were supplied with
/obj/item/solar_assembly/proc/give_glass()
	if(glass_type)
		var/obj/item/stack/material/S =69ew glass_type(src.loc)
		S.amount = 2
		glass_type =69ull


/obj/item/solar_assembly/attackby(var/obj/item/I,69ar/mob/user)

	var/list/usable_qualities = list(QUALITY_BOLT_TURNING)
	if(tracker)
		usable_qualities.Add(QUALITY_PRYING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_PRYING)
			if(tracker)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					new /obj/item/electronics/tracker(src.loc)
					tracker = 0
					user.visible_message(SPAN_NOTICE("69user69 takes out the electronics from the solar assembly."))
					return
			return

		if(QUALITY_BOLT_TURNING)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				anchored = !anchored
				user.visible_message(SPAN_NOTICE("69user69 69anchored ? "un" : ""69wrenches the solar assembly into place."))
				return
			return

		if(ABORT_CHECK)
			return

	if(anchored && !isturf(loc))
		if(istype(I, /obj/item/stack/material) && (I.get_material_name() ==69ATERIAL_GLASS || I.get_material_name() ==69ATERIAL_RGLASS))
			var/obj/item/stack/material/S = I
			if(S.use(2))
				glass_type = I.type
				playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
				user.visible_message(SPAN_NOTICE("69user69 places the glass on the solar assembly."))
				if(tracker)
					new /obj/machinery/power/tracker(get_turf(src), src)
				else
					new /obj/machinery/power/solar(get_turf(src), src)
			else
				to_chat(user, SPAN_WARNING("You69eed two sheets of glass to put them into a solar panel."))
				return
			return

	if(!tracker)
		if(istype(I, /obj/item/electronics/tracker))
			tracker = 1
			user.drop_item()
			qdel(I)
			user.visible_message(SPAN_NOTICE("69user69 inserts the electronics into the solar assembly."))
			return
	..()

//
// Solar Control Computer
//

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/computer.dmi'
	icon_state = "solar"
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 250
	var/light_range_on = 1.5
	var/light_power_on = 3
	var/id = 0
	var/cdir = 0
	var/targetdir = 0		// target angle in69anual tracking (since it updates every game69inute)
	var/gen = 0
	var/lastgen = 0
	var/track = 0			// 0= off  1=timed  2=auto (tracker)
	var/trackrate = 600		// 300-900 seconds
	var/nexttime = 0		// time for a panel to rotate of 1� in69anual tracking
	var/obj/machinery/power/tracker/connected_tracker =69ull
	var/list/connected_panels = list()

/obj/machinery/power/solar_control/drain_power()
	return -1

/obj/machinery/power/solar_control/Destroy()
	for(var/obj/machinery/power/solar/M in connected_panels)
		M.unset_control()
	if(connected_tracker)
		connected_tracker.unset_control()
	. = ..()

/obj/machinery/power/solar_control/disconnect_from_network()
	..()
	SSsun.solars.Remove(src)

/obj/machinery/power/solar_control/connect_to_network()
	var/to_return = ..()
	if(powernet) //if connected and69ot already in solar_list...
		SSsun.solars |= src //... add it
	return to_return

//search for unconnected panels and trackers in the computer powernet and connect them
/obj/machinery/power/solar_control/proc/search_for_connected()
	if(powernet)
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar))
				var/obj/machinery/power/solar/S =69
				if(!S.control) //i.e unconnected
					S.set_control(src)
					connected_panels |= S
			else if(istype(M, /obj/machinery/power/tracker))
				if(!connected_tracker) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/tracker/T =69
					if(!T.control) //i.e unconnected
						connected_tracker = T
						T.set_control(src)

//called by the sun controller, update the facing angle (either69anually or69ia tracking) and rotates the panels accordingly
/obj/machinery/power/solar_control/proc/update()
	if(stat & (NOPOWER | BROKEN))
		return

	switch(track)
		if(1)
			if(trackrate) //we're69anual tracking. If we set a rotation speed...
				cdir = targetdir //...the current direction is the targetted one (and rotates panels to it)
		if(2) // auto-tracking
			if(connected_tracker)
				connected_tracker.set_angle(SSsun.angle)

	set_panels(cdir)
	updateDialog()


/obj/machinery/power/solar_control/Initialize()
	. = ..()
	if(!connect_to_network()) return
	set_panels(cdir)

/obj/machinery/power/solar_control/update_icon()
	if(stat & BROKEN)
		icon_state = "broken"
		overlays.Cut()
		return
	if(stat &69OPOWER)
		icon_state = "c_unpowered"
		overlays.Cut()
		return
	icon_state = "solar"
	overlays.Cut()
	if(cdir > -1)
		overlays += image('icons/obj/computer.dmi', "solcon-o", FLY_LAYER, angle2dir(cdir))
	return

/obj/machinery/power/solar_control/attack_hand(mob/user)
	if(!..())
		interact(user)

/obj/machinery/power/solar_control/interact(mob/user)

	var/t = "<B><span class='highlight'>Generated power</span></B> : 69round(lastgen)69 W<BR>"
	t += "<B><span class='highlight'>Star Orientation</span></B>: 69SSsun.angle69&deg (69angle2text(SSsun.angle)69)<BR>"
	t += "<B><span class='highlight'>Array Orientation</span></B>: 69rate_control(src,"cdir","69cdir69&deg",1,15)69 (69angle2text(cdir)69)<BR>"
	t += "<B><span class='highlight'>Tracking:</span></B><div class='statusDisplay'>"
	switch(track)
		if(0)
			t += "<span class='linkOn'>Off</span> <A href='?src=\ref69src69;track=1'>Timed</A> <A href='?src=\ref69src69;track=2'>Auto</A><BR>"
		if(1)
			t += "<A href='?src=\ref69src69;track=0'>Off</A> <span class='linkOn'>Timed</span> <A href='?src=\ref69src69;track=2'>Auto</A><BR>"
		if(2)
			t += "<A href='?src=\ref69src69;track=0'>Off</A> <A href='?src=\ref69src69;track=1'>Timed</A> <span class='linkOn'>Auto</span><BR>"

	t += "Tracking Rate: 69rate_control(src,"tdir","69trackrate69 deg/h (69trackrate<0 ? "CCW" : "CW"69)",1,30,180)69</div><BR>"

	t += "<B><span class='highlight'>Connected devices:</span></B><div class='statusDisplay'>"

	t += "<A href='?src=\ref69src69;search_connected=1'>Search for devices</A><BR>"
	t += "Solar panels : 69connected_panels.len69 connected<BR>"
	t += "Solar tracker : 69connected_tracker ? "<span class='good'>Found</span>" : "<span class='bad'>Not found</span>"69</div><BR>"

	t += "<A href='?src=\ref69src69;close=1'>Close</A>"

	var/datum/browser/popup =69ew(user, "solar",69ame)
	popup.set_content(t)
	popup.open()

	return

/obj/machinery/power/solar_control/attackby(obj/item/I,69ob/user)
	if(I.get_tool_type(usr, list(QUALITY_SCREW_DRIVING), src))
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			if (src.stat & BROKEN)
				to_chat(user, SPAN_NOTICE("The broken glass falls out."))
				var/obj/structure/computerframe/A =69ew /obj/structure/computerframe( src.loc )
				new /obj/item/material/shard( src.loc )
				var/obj/item/electronics/circuitboard/solar_control/M =69ew /obj/item/electronics/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit =69
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				qdel(src)
			else
				to_chat(user, SPAN_NOTICE("You disconnect the69onitor."))
				var/obj/structure/computerframe/A =69ew /obj/structure/computerframe( src.loc )
				var/obj/item/electronics/circuitboard/solar_control/M =69ew /obj/item/electronics/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit =69
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				qdel(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/power/solar_control/Process()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	if(connected_tracker) //NOTE : handled here so that we don't add trackers to the processing list
		if(connected_tracker.powernet != powernet)
			connected_tracker.unset_control()

	if(track==1 && trackrate) //manual tracking and set a rotation speed
		if(nexttime <= world.time) //every time we69eed to increase/decrease the angle by 1�...
			targetdir = (targetdir + trackrate/abs(trackrate) + 360) % 360 	//... do it
			nexttime += 36000/abs(trackrate) //reset the counter for the69ext 1�

	updateDialog()

/obj/machinery/power/solar_control/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return 0
	if(href_list69"close"69 )
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return 0

	if(href_list69"rate control"69)
		if(href_list69"cdir"69)
			src.cdir = dd_range(0,359,(360+src.cdir+text2num(href_list69"cdir"69))%360)
			src.targetdir = src.cdir
			if(track == 2) //manual update, so losing auto-tracking
				track = 0
			spawn(1)
				set_panels(cdir)
		if(href_list69"tdir"69)
			src.trackrate = dd_range(-7200,7200,src.trackrate+text2num(href_list69"tdir"69))
			if(src.trackrate)69exttime = world.time + 36000/abs(trackrate)

	if(href_list69"track"69)
		track = text2num(href_list69"track"69)
		if(track == 2)
			if(connected_tracker)
				connected_tracker.set_angle(SSsun.angle)
				set_panels(cdir)
		else if (track == 1) //begin69anual tracking
			src.targetdir = src.cdir
			if(src.trackrate)69exttime = world.time + 36000/abs(trackrate)
			set_panels(targetdir)

	if(href_list69"search_connected"69)
		src.search_for_connected()
		if(connected_tracker && track == 2)
			connected_tracker.set_angle(SSsun.angle)
		src.set_panels(cdir)

	interact(usr)
	return 1

//rotates the panel to the passed angle
/obj/machinery/power/solar_control/proc/set_panels(var/cdir)

	for(var/obj/machinery/power/solar/S in connected_panels)
		S.adir = cdir //instantly rotates the panel
		S.occlusion()//and
		S.update_icon() //update it

	update_icon()


/obj/machinery/power/solar_control/power_change()
	..()
	update_icon()


/obj/machinery/power/solar_control/proc/broken()
	stat |= BROKEN
	update_icon()


/obj/machinery/power/solar_control/ex_act(severity)
	switch(severity)
		if(1)
			//SN src =69ull
			qdel(src)
			return
		if(2)
			if (prob(50))
				broken()
		if(3)
			if (prob(25))
				broken()
	return

// Used for69apping in solar array which automatically starts itself (telecomms, for example)
/obj/machinery/power/solar_control/autostart
	track = 2 // Auto tracking69ode

/obj/machinery/power/solar_control/autostart/New()
	..()
	spawn(150) // Wait 15 seconds to ensure everything was set up properly (such as, powernets, solar panels, etc.
		src.search_for_connected()
		if(connected_tracker && track == 2)
			connected_tracker.set_angle(SSsun.angle)
		src.set_panels(cdir)

//
//69ISC
//

/obj/item/paper/solar
	name = "paper- 'Going green! Setup your own solar array instructions.'"
	info = "<h1>Welcome</h1><p>At greencorps we love the environment, and space. With this package you are able to help69other69ature and produce energy without any usage of fossil fuel or plasma! Singularity energy is dangerous while solar energy is safe, which is why it's better.69ow here is how you setup your own solar array.</p><p>You can69ake a solar panel by wrenching the solar assembly onto a cable69ode. Adding a glass panel, reinforced or regular glass will do, will finish the construction of your solar panel. It is that easy!</p><p>Now after setting up 1969ore of these solar panels you will want to create a solar tracker to keep track of our69other69ature's gift, the sun. These are the same steps as before except you insert the tracker equipment circuit into the assembly before performing the final step of adding the glass. You69ow have a tracker!69ow the last step is to add a computer to calculate the sun's69ovements and to send commands to the solar panels to change direction with the sun. Setting up the solar computer is the same as setting up any computer, so you should have69o trouble in doing that. You do69eed to put a wire69ode under the computer, and the wire69eeds to be connected to the tracker.</p><p>Congratulations, you should have a working solar array. If you are having trouble, here are some tips.69ake sure all solar equipment are on a cable69ode, even the computer. You can always deconstruct your creations if you69ake a69istake.</p><p>That's all to it, be safe, be green!</p>"

/proc/rate_control(var/S,69ar/V,69ar/C,69ar/Min=1,69ar/Max=5,69ar/Limit=null) //How69ot to69ame69ars
	var/href = "<A href='?src=\ref69S69;rate control=1;69V69"
	var/rate = "69href69=-69Max69'>-</A>69href69=-69Min69'>-</A> 69(C?C : 0)69 69href69=69Min69'>+</A>69href69=69Max69'>+</A>"
	if(Limit) return "69href69=-69Limit69'>-</A>"+rate+"69href69=69Limit69'>+</A>"
	return rate
