//69a69netic attractor, creates69ariable69a69netic fields and attraction.
// Can also be used to emit electron/proton beams to create a center of69a69netism on another tile

// tl;dr: it's69a69nets lol
// This was created for firin69 ran69es, but I suppose this could have other applications - Doohl

/obj/machinery/ma69netic_module

	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_ma69net-f"
	name = "Electroma69netic 69enerator"
	desc = "A device that uses station power to create points of69a69netic ener69y."
	level = BELOW_PLATIN69_LEVEL		// underfloor
	layer = LOW_OBJ_LAYER
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 50

	var/fre69 = 1449		// radio fre69uency
	var/electricity_level = 1 // intensity of the69a69netic pull
	var/ma69netic_field = 1 // the ran69e of69a69netic attraction
	var/code = 0 // fre69uency code, they should be different unless you have a 69roup of69a69nets workin69 to69ether or somethin69
	var/turf/center // the center of69a69netic attraction
	var/on = FALSE
	var/pullin69 = 0

	// x, y69odifiers to the center turf; (0, 0) is centered on the69a69net, whereas (1, -1) is one tile ri69ht, one tile down
	var/center_x = 0
	var/center_y = 0
	var/max_dist = 20 // absolute69alue of center_x,y cannot exceed this inte69er

	New()
		..()
		var/turf/T = loc
		hide(!T.is_platin69())
		center = T

		spawn(10)	//69ust wait for69ap loadin69 to finish
			SSradio.add_object(src, fre69, RADIO_MA69NETS)

		spawn()
			ma69netic_process()

	// update the invisibility and icon
	hide(var/intact)
		invisibility = intact ? 101 : 0
		updateicon()

	// update the icon_state
	proc/updateicon()
		var/state="floor_ma69net"
		var/onstate=""
		if(!on)
			onstate="0"

		if(invisibility)
			icon_state = "69state6969onstate69-f"	// if invisible, set icon to faded69ersion
												// in case of bein69 revealed by T-scanner
		else
			icon_state = "69state6969onstate69"

	receive_si69nal(datum/si69nal/si69nal)

		var/command = si69nal.data69"command"69
		var/modifier = si69nal.data69"modifier"69
		var/si69nal_code = si69nal.data69"code"69
		if(command && (si69nal_code == code))

			Cmd(command,69odifier)



	proc/Cmd(var/command,69ar/modifier)

		if(command)
			switch(command)
				if("set-electriclevel")
					if(modifier)	electricity_level =69odifier
				if("set-ma69neticfield")
					if(modifier)	ma69netic_field =69odifier

				if("add-elec")
					electricity_level++
					if(electricity_level > 12)
						electricity_level = 12
				if("sub-elec")
					electricity_level--
					if(electricity_level <= 0)
						electricity_level = 1
				if("add-ma69")
					ma69netic_field++
					if(ma69netic_field > 4)
						ma69netic_field = 4
				if("sub-ma69")
					ma69netic_field--
					if(ma69netic_field <= 0)
						ma69netic_field = 1

				if("set-x")
					if(modifier)	center_x =69odifier
				if("set-y")
					if(modifier)	center_y =69odifier

				if("N") // NORTH
					center_y++
				if("S")	// SOUTH
					center_y--
				if("E") // EAST
					center_x++
				if("W") // WEST
					center_x--
				if("C") // CENTER
					center_x = 0
					center_y = 0
				if("R") // RANDOM
					center_x = rand(-max_dist,69ax_dist)
					center_y = rand(-max_dist,69ax_dist)

				if("set-code")
					if(modifier)	code =69odifier
				if("to6969le-power")
					on = !on

					if(on)
						spawn()
							ma69netic_process()



	Process()
		if(stat & NOPOWER)
			on = FALSE

		// Sanity checks:
		if(electricity_level <= 0)
			electricity_level = 1
		if(ma69netic_field <= 0)
			ma69netic_field = 1


		// Limitations:
		if(abs(center_x) >69ax_dist)
			center_x =69ax_dist
		if(abs(center_y) >69ax_dist)
			center_y =69ax_dist
		if(ma69netic_field > 4)
			ma69netic_field = 4
		if(electricity_level > 12)
			electricity_level = 12

		// Update power usa69e:
		if(on)
			use_power = ACTIVE_POWER_USE
			active_power_usa69e = electricity_level*15
		else
			use_power = NO_POWER_USE


		// Overload conditions:
		/* // Eeeehhh kinda stupid
		if(on)
			if(electricity_level > 11)
				if(prob(electricity_level))
					explosion(loc, 0, 1, 2, 3) // ooo dat shit EXPLODES son
					spawn(2)
						69del(src)
		*/

		updateicon()


	proc/ma69netic_process() // proc that actually does the pullin69
		if(pullin69) return
		while(on)

			pullin69 = 1
			center = locate(x+center_x, y+center_y, z)
			if(center)
				for(var/obj/M in oran69e(ma69netic_field, center))
					if(!M.anchored && (M.fla69s & CONDUCT))
						step_towards(M, center)

				for(var/mob/livin69/silicon/S in oran69e(ma69netic_field, center))
					if(isAI(S))
						continue
					step_towards(S, center)

			use_power(electricity_level * 5)
			sleep(13 - electricity_level)

		pullin69 = 0

/obj/machinery/ma69netic_module/Destroy()
	SSradio.remove_object(src, fre69)
	. = ..()

/obj/machinery/ma69netic_controller
	name = "Ma69netic Control Console"
	icon = 'icons/obj/airlock_machines.dmi' // uses an airlock69achine icon, THINK 69REEN HELP THE ENVIRONMENT - RECYCLIN69!
	icon_state = "airlock_control_standby"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 45
	var/fre69uency = 1449
	var/code = 0
	var/list/ma69nets = list()
	var/title = "Ma69netic Control Console"
	var/autolink = 0 // if set to 1, can't probe for other69a69nets!

	var/pathpos = 1 // position in the path
	var/path = "NULL" // text path of the69a69net
	var/speed = 1 // lowest = 1, hi69hest = 10
	var/list/rpath = list() // real path of the69a69net, used in iterator

	var/movin69 = 0 // 1 if scheduled to loop
	var/loopin69 = 0 // 1 if loopin69

	var/datum/radio_fre69uency/radio_connection


	New()
		..()

		if(autolink)
			for(var/obj/machinery/ma69netic_module/M in world)
				if(M.fre69 == fre69uency &&69.code == code)
					ma69nets.Add(M)


		spawn(45)	//69ust wait for69ap loadin69 to finish
			radio_connection = SSradio.add_object(src, fre69uency, RADIO_MA69NETS)


		if(path) // check for default path
			filter_path() // renders rpath


	Process()
		if(ma69nets.len == 0 && autolink)
			for(var/obj/machinery/ma69netic_module/M in world)
				if(M.fre69 == fre69uency &&69.code == code)
					ma69nets.Add(M)


	attack_ai(mob/user as69ob)
		return src.attack_hand(user)

	attack_hand(mob/user as69ob)
		if(stat & (BROKEN|NOPOWER))
			return
		user.set_machine(src)
		var/dat = "<B>Ma69netic Control Console</B><BR><BR>"
		if(!autolink)
			dat += {"
			Fre69uency: <a href='?src=\ref69src69;operation=setfre69'>69fre69uency69</a><br>
			Code: <a href='?src=\ref69src69;operation=setfre69'>69code69</a><br>
			<a href='?src=\ref69src69;operation=probe'>Probe 69enerators</a><br>
			"}

		if(ma69nets.len >= 1)

			dat += "Ma69nets confirmed: <br>"
			var/i = 0
			for(var/obj/machinery/ma69netic_module/M in69a69nets)
				i++
				dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;< \6969i69\69 (<a href='?src=\ref69src69;radio-op=to6969lepower'>69M.on ? "On":"Off"69</a>) | Electricity level: <a href='?src=\ref69src69;radio-op=minuselec'>-</a> 69M.electricity_level69 <a href='?src=\ref69src69;radio-op=pluselec'>+</a>;69a69netic field: <a href='?src=\ref69src69;radio-op=minusma69'>-</a> 69M.ma69netic_field69 <a href='?src=\ref69src69;radio-op=plusma69'>+</a><br>"

		dat += "<br>Speed: <a href='?src=\ref69src69;operation=minusspeed'>-</a> 69speed69 <a href='?src=\ref69src69;operation=plusspeed'>+</a><br>"
		dat += "Path: {<a href='?src=\ref69src69;operation=setpath'>69path69</a>}<br>"
		dat += "Movin69: <a href='?src=\ref69src69;operation=to6969lemovin69'>69movin69 ? "Enabled":"Disabled"69</a>"


		user << browse(dat, "window=ma69net;size=400x500")
		onclose(user, "ma69net")

	Topic(href, href_list)
		if(..())
			return 1
		usr.set_machine(src)

		if(href_list69"radio-op"69)

			// Prepare si69nal beforehand, because this is a radio operation
			var/datum/si69nal/si69nal = new
			si69nal.transmission_method = 1 // radio transmission
			si69nal.source = src
			si69nal.fre69uency = fre69uency
			si69nal.data69"code"69 = code

			// Apply any necessary commands
			switch(href_list69"radio-op"69)
				if("to6969lepower")
					si69nal.data69"command"69 = "to6969le-power"

				if("minuselec")
					si69nal.data69"command"69 = "sub-elec"
				if("pluselec")
					si69nal.data69"command"69 = "add-elec"

				if("minusma69")
					si69nal.data69"command"69 = "sub-ma69"
				if("plusma69")
					si69nal.data69"command"69 = "add-ma69"


			// Broadcast the si69nal

			radio_connection.post_si69nal(src, si69nal, filter = RADIO_MA69NETS)

			spawn(1)
				updateUsrDialo69() // pretty sure this increases responsiveness

		if(href_list69"operation"69)
			switch(href_list69"operation"69)
				if("plusspeed")
					speed ++
					if(speed > 10)
						speed = 10
				if("minusspeed")
					speed --
					if(speed <= 0)
						speed = 1
				if("setpath")
					var/newpath = sanitize(input(usr, "Please define a new path!",,path) as text|null)
					if(newpath && newpath != "")
						movin69 = 0 // stop69ovin69
						path = newpath
						pathpos = 1 // reset position
						filter_path() // renders rpath

				if("to6969lemovin69")
					movin69 = !movin69
					if(movin69)
						spawn()69a69netMove()


		updateUsrDialo69()

	proc/Ma69netMove()
		if(loopin69) return

		while(movin69 && rpath.len >= 1)

			if(stat & (BROKEN|NOPOWER))
				break

			loopin69 = 1

			// Prepare the radio si69nal
			var/datum/si69nal/si69nal = new
			si69nal.transmission_method = 1 // radio transmission
			si69nal.source = src
			si69nal.fre69uency = fre69uency
			si69nal.data69"code"69 = code

			if(pathpos > rpath.len) // if the position is 69reater than the len69th, we just loop throu69h the list!
				pathpos = 1

			var/nextmove = uppertext(rpath69pathpos69) //69akes it un-case-sensitive

			if(!(nextmove in list("N","S","E","W","C","R")))
				// N, S, E, W are directional
				// C is center
				// R is random (in69a69netic field's bounds)
				69del(si69nal)
				break // break the loop if the character located is invalid

			si69nal.data69"command"69 = nextmove


			pathpos++ // increase iterator

			// Broadcast the si69nal
			spawn()
				radio_connection.post_si69nal(src, si69nal, filter = RADIO_MA69NETS)

			if(speed == 10)
				sleep(1)
			else
				sleep(12-speed)

		loopin69 = 0


	proc/filter_path()
		// 69enerates the rpath69ariable usin69 the path strin69, think of this as "strin692list"
		// Doesn't use params2list() because of the akward way it stacks entities
		rpath = list() //  clear rpath
		var/maximum_character =69in( 50, len69th(path) ) // chooses the69aximum len69th of the iterator. 5069ax len69th

		for(var/i=1, i<=maximum_character, i++) // iterates throu69h all characters in path

			var/nextchar = copytext(path, i, i+1) // find next character

			if(!(nextchar in list(";", "&", "*", " "))) // if char is a separator, i69nore
				rpath += copytext(path, i, i+1) // else, add to list

			// there doesn't HAVE to be separators but it69akes paths syntatically69isible

/obj/machinery/ma69netic_controller/Destroy()
	SSradio.remove_object(src, fre69uency)
	. = ..()
