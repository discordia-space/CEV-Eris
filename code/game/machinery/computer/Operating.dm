//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operating
	name = "patient monitoring console"
	density = TRUE
	anchored = TRUE
	icon_keyboard = "med_key"
	icon_screen = "crew"
	circuit = /obj/item/electronics/circuitboard/operating
	var/mob/living/carbon/human/victim
	var/obj/machinery/optable/table

/obj/machinery/computer/operating/New()
	..()
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/machinery/optable, get_step(src, dir))
		if(table)
			table.computer = src
			break

/obj/machinery/computer/operating/attack_hand(mob/user)
	add_fingerprint(user)
	if(..())
		return
	interact(user)


/obj/machinery/computer/operating/interact(mob/user)
	if( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if(!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=op")
			return

	user.set_machine(src)
	var/dat = "<HEAD><TITLE>Operating Computer</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[user];mach_close=op'>Close</A><br><br>" //| <A HREF='?src=\ref[user];update=1'>Update</A>"
	if(table && (table.check_victim()))
		victim = table.victim
		var/internal_health
		if(ishuman(victim))
			var/organ_health
			var/organ_damage
			for(var/obj/item/organ/external/E in victim.organs)
				organ_health += E.total_internal_health
				organ_damage += E.severity_internal_wounds
			internal_health = organ_health ? round((1 - (organ_damage / organ_health)) * 100) : 100
		var/tox_content = victim.chem_effects[CE_TOXIN] + victim.chem_effects[CE_ALCOHOL_TOXIC]
		dat += {"
				<B>Patient Information:</B><BR>
				<BR>
				<B>Name:</B> [victim.real_name]<BR>
				<B>Age:</B> [victim.age]<BR>
				<B>Blood Type:</B> [victim.b_type]<BR>
				<BR>
				<B>Critical Health:</B> [victim.health]%<BR>
				<B>Organ Health:</B> [internal_health]%<BR>
				<B>Brute Damage:</B> [victim.getBruteLoss()]<BR>
				<B>Toxin Content:</B> [tox_content ? tox_content : "0"]<BR>
				<B>Fire Damage:</B> [victim.getFireLoss()]<BR>
				<B>Suffocation Damage:</B> [victim.getOxyLoss()]<BR>
				<B>Patient Status:</B> [victim.stat ? "Non-Responsive" : "Stable"]<BR>
				<B>Heartbeat rate:</B> [victim.get_pulse(GETPULSE_TOOL)]<BR>
				"}
	else
		victim = null
		dat += {"
<B>Patient Information:</B><BR>
<BR>
<B>No Patient Detected</B>
"}
	user << browse(dat, "window=op")
	onclose(user, "op")


/obj/machinery/computer/operating/Topic(href, href_list)
	if(..())
		return 1
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (issilicon(usr)))
		usr.set_machine(src)
	return


/obj/machinery/computer/operating/Process()
	if(..())
		src.updateDialog()
