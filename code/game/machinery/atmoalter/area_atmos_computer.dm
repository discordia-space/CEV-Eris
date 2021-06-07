/obj/machinery/computer/area_atmos
	name = "Area Air Control"
	desc = "A computer used to control the stationary scrubbers and pumps in the area."
	icon_keyboard = "atmos_key"
	icon_screen = "area_atmos"
	light_color = COLOR_LIGHTING_CYAN_MACHINERY
	circuit = /obj/item/weapon/electronics/circuitboard/area_atmos

	var/list/connectedscrubbers = new()
	var/status = ""

	var/range = 25

	//Simple variable to prevent me from doing attack_hand in both this and the child computer
	var/zone = "This computer is working on a wireless range, the range is currently limited to 25 meters."

/obj/machinery/computer/area_atmos/Initialize()
	. = ..()
	scanscrubbers()

/obj/machinery/computer/area_atmos/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/area_atmos/attack_hand(mob/user)
	if(..())
		return
	add_fingerprint(usr)
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
			<font color="red">[status]</font><br>
			<a href="?src=[REF(src)];scan=1">Scan</a>
			<table border="1" width="90%">"}
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in connectedscrubbers)
		dat += {"
				<tr>
					<td>
						[scrubber.name]<br>
						Pressure: [round(scrubber.air_contents.return_pressure(), 0.01)] kPa<br>
						Flow Rate: [round(scrubber.last_flow_rate,0.1)] L/s<br>
					</td>
					<td width="150">
						<a class="green" href="?src=[REF(src)];scrub=[REF(scrubber)];toggle=1">Turn On</a>
						<a class="red" href="?src=[REF(src)];scrub=[REF(scrubber)];toggle=0">Turn Off</a><br>
						Load: [round(scrubber.last_power_draw)] W
					</td>
				</tr>"}

	dat += {"
			</table><br>
			<i>[zone]</i>
		</body>
	</html>"}
	user << browse("[dat]", "window=atmosscrubcontrol;size=400x400")
	status = ""

/obj/machinery/computer/area_atmos/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)


	if(href_list["scan"])
		scanscrubbers()
	else if(href_list["toggle"])
		var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber = locate(href_list["scrub"])

		if(!validscrubber(scrubber)) // NOT ASYNC WHY ARE YOU SLEEPING REEE
			status = "ERROR: Couldn't connect to scrubber! (timeout)"
			connectedscrubbers -= scrubber
			updateUsrDialog()
			return

		scrubber.on = text2num(href_list["toggle"])
		scrubber.update_icon()

/obj/machinery/computer/area_atmos/proc/validscrubber(obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	if(!istype(scrubber) || get_dist(scrubber.loc, loc) > range || scrubber.loc.z != loc.z)
		return FALSE

	return TRUE

/obj/machinery/computer/area_atmos/proc/scanscrubbers()
	connectedscrubbers = new()

	var/found = FALSE
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in range(range, loc))
		if(istype(scrubber))
			found = TRUE
			connectedscrubbers |= scrubber

	if(!found)
		status = "ERROR: No scrubber found!"

	updateUsrDialog()


/obj/machinery/computer/area_atmos/area
	zone = "This computer is working in a wired network limited to this area."

/obj/machinery/computer/area_atmos/area/validscrubber(obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	if(!istype(scrubber))
		return FALSE

	var/area/A = get_area(src)
	if(!A)
		return FALSE
	// get the scrubber validity too
	var/area/AS = get_area(src)
	if(!AS)
		return FALSE

	if(A != AS)
		return FALSE

	return TRUE

/obj/machinery/computer/area_atmos/area/scanscrubbers()
	connectedscrubbers = new()

	var/found = FALSE

	var/area/A = get_area(src)
	if(!A)
		return

	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in GLOB.machines)
		var/area/MA = get_area(scrubber)
		if(!MA || !istype(scrubber))
			continue
		if(MA == A)
			connectedscrubbers += scrubber
			found = TRUE

		if(!found)
			status = "ERROR: No scrubber found!"

		updateUsrDialog()
