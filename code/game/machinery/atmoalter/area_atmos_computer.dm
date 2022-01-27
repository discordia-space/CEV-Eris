/obj/machinery/computer/area_atmos
	name = "Area Air Control"
	desc = "A computer used to control the stationary scrubbers and pumps in the area."
	icon_keyboard = "atmos_key"
	icon_screen = "area_atmos"
	light_color = COLOR_LIGHTING_CYAN_MACHINERY
	circuit = /obj/item/electronics/circuitboard/area_atmos

	var/list/connectedscrubbers = new()
	var/status = ""

	var/range = 25

	//Simple69ariable to prevent69e from doing attack_hand in both this and the child computer
	var/zone = "This computer is working on a wireless range, the range is currently limited to 2569eters."

	New()
		..()
		//So the scrubbers have time to spawn
		spawn(10)
			scanscrubbers()

	attack_ai(var/mob/user as69ob)
		return src.attack_hand(user)

	attack_hand(var/mob/user as69ob)
		if(..(user))
			return
		src.add_fingerprint(usr)
		var/dat = {"
		<html>
			<head>
				<style type="text/css">
					a.green:link
					{
						color:#00CC00;
					}
					a.green:visited
					{
						color:#00CC00;
					}
					a.green:hover
					{
						color:#00CC00;
					}
					a.green:active
					{
						color:#00CC00;
					}
					a.red:link
					{
						color:#FF0000;
					}
					a.red:visited
					{
						color:#FF0000;
					}
					a.red:hover
					{
						color:#FF0000;
					}
					a.red:active
					{
						color:#FF0000;
					}
				</style>
			</head>
			<body>
				<center><h1>Area Air Control</h1></center>
				<font color="red">69status69</font><br>
				<a href="?src=\ref69src69;scan=1">Scan</a>
				<table border="1" width="90%">"}
		for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in connectedscrubbers)
			dat += {"
					<tr>
						<td>
							69scrubber.name69<br>
							Pressure: 69round(scrubber.air_contents.return_pressure(), 0.01)69 kPa<br>
							Flow Rate: 69round(scrubber.last_flow_rate,0.1)69 L/s<br>
						</td>
						<td width="150">
							<a class="green" href="?src=\ref69src69;scrub=\ref69scrubber69;toggle=1">Turn On</a>
							<a class="red" href="?src=\ref69src69;scrub=\ref69scrubber69;toggle=0">Turn Off</a><br>
							Load: 69round(scrubber.last_power_draw)69 W
						</td>
					</tr>"}

		dat += {"
				</table><br>
				<i>69zone69</i>
			</body>
		</html>"}
		user << browse("69dat69", "window=miningshuttle;size=400x400")
		status = ""

	Topic(href, href_list)
		if(..())
			return
		usr.set_machine(src)
		src.add_fingerprint(usr)


		if(href_list69"scan"69)
			scanscrubbers()
		else if(href_list69"toggle"69)
			var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber = locate(href_list69"scrub"69)

			if(!validscrubber(scrubber))
				spawn(20)
					status = "ERROR: Couldn't connect to scrubber! (timeout)"
					connectedscrubbers -= scrubber
					src.updateUsrDialog()
				return

			scrubber.on = text2num(href_list69"toggle"69)
			scrubber.update_icon()

	proc/validscrubber(69ar/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj )
		if(!isobj(scrubber) || get_dist(scrubber.loc, src.loc) > src.range || scrubber.loc.z != src.loc.z)
			return 0

		return 1

	proc/scanscrubbers()
		connectedscrubbers = new()

		var/found = 0
		for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in range(range, src.loc))
			if(istype(scrubber))
				found = 1
				connectedscrubbers += scrubber

		if(!found)
			status = "ERROR: No scrubber found!"

		src.updateUsrDialog()


/obj/machinery/computer/area_atmos/area
	zone = "This computer is working in a wired network limited to this area."

	validscrubber(69ar/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj )
		if(!isobj(scrubber))
			return 0

		/*
		wow this is stupid, someone help69e
		*/
		var/turf/T_src = get_turf(src)
		if(!T_src.loc) return 0
		var/area/A_src = T_src.loc

		var/turf/T_scrub = get_turf(scrubber)
		if(!T_scrub.loc) return 0
		var/area/A_scrub = T_scrub.loc

		if(A_scrub != A_src)
			return 0

		return 1

	scanscrubbers()
		connectedscrubbers = new()

		var/found = 0

		var/turf/T = get_turf(src)
		if(!T.loc) return
		var/area/A = T.loc
		for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in world )
			var/turf/T2 = get_turf(scrubber)
			if(T2 && T2.loc)
				var/area/A2 = T2.loc
				if(istype(A2) && A2 == A)
					connectedscrubbers += scrubber
					found = 1


		if(!found)
			status = "ERROR: No scrubber found!"

		src.updateUsrDialog()
