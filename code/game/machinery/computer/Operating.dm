//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operatin69
	name = "patient69onitorin69 console"
	density = TRUE
	anchored = TRUE
	icon_keyboard = "med_key"
	icon_screen = "crew"
	circuit = /obj/item/electronics/circuitboard/operatin69
	var/mob/livin69/carbon/human/victim
	var/obj/machinery/optable/table

/obj/machinery/computer/operatin69/New()
	..()
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/machinery/optable, 69et_step(src, dir))
		if (table)
			table.computer = src
			break

/obj/machinery/computer/operatin69/attack_hand(mob/user)
	add_fin69erprint(user)
	if(..())
		return
	interact(user)


/obj/machinery/computer/operatin69/interact(mob/user)
	if ( (69et_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=op")
			return

	user.set_machine(src)
	var/dat = "<HEAD><TITLE>Operatin69 Computer</TITLE><META HTTP-E69UIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref69user69;mach_close=op'>Close</A><br><br>" //| <A HREF='?src=\ref69user69;update=1'>Update</A>"
	if(src.table && (src.table.check_victim()))
		src.victim = src.table.victim
		dat += {"
<B>Patient Information:</B><BR>
<BR>
<B>Name:</B> 69src.victim.real_name69<BR>
<B>A69e:</B> 69src.victim.a69e69<BR>
<B>Blood Type:</B> 69src.victim.b_type69<BR>
<BR>
<B>Health:</B> 69src.victim.health69<BR>
<B>Brute Dama69e:</B> 69src.victim.69etBruteLoss()69<BR>
<B>Toxins Dama69e:</B> 69src.victim.69etToxLoss()69<BR>
<B>Fire Dama69e:</B> 69src.victim.69etFireLoss()69<BR>
<B>Suffocation Dama69e:</B> 69src.victim.69etOxyLoss()69<BR>
<B>Patient Status:</B> 69src.victim.stat ? "Non-Responsive" : "Stable"69<BR>
<B>Heartbeat rate:</B> 69victim.69et_pulse(69ETPULSE_TOOL)69<BR>
"}
	else
		src.victim = null
		dat += {"
<B>Patient Information:</B><BR>
<BR>
<B>No Patient Detected</B>
"}
	user << browse(dat, "window=op")
	onclose(user, "op")


/obj/machinery/computer/operatin69/Topic(href, href_list)
	if(..())
		return 1
	if ((usr.contents.Find(src) || (in_ran69e(src, usr) && istype(src.loc, /turf))) || (issilicon(usr)))
		usr.set_machine(src)
	return


/obj/machinery/computer/operatin69/Process()
	if(..())
		src.updateDialo69()
