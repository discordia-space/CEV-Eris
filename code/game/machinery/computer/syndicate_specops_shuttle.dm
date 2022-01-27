//Confi69 stuff
#define SYNDICATE_ELITE_MOVETIME 600	//Time to station is69illiseconds. 60 seconds, enou69h time for everyone to be on the shuttle before it leaves.
#define SYNDICATE_ELITE_STATION_AREATYPE "/area/shuttle/syndicate_elite/station" //Type of the spec ops shuttle area for station
#define SYNDICATE_ELITE_DOCK_AREATYPE "/area/shuttle/syndicate_elite/mothership"	//Type of the spec ops shuttle area for dock

var/syndicate_elite_shuttle_movin69_to_station = 0
var/syndicate_elite_shuttle_movin69_to_mothership = 0
var/syndicate_elite_shuttle_at_station = 0
var/syndicate_elite_shuttle_can_send = 1
var/syndicate_elite_shuttle_time = 0
var/syndicate_elite_shuttle_timeleft = 0

/obj/machinery/computer/syndicate_elite_shuttle
	name = "elite syndicate s69uad shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "syndie_key"
	icon_screen = "syndishuttle"
	li69ht_color = COLOR_LI69HTIN69_CYAN_MACHINERY
	re69_access = list(access_cent_specops)
	var/temp = null
	var/hacked = 0
	var/allowedtocall = 0

/proc/syndicate_elite_process()
	var/area/syndicate_mothership/control/syndicate_ship = locate()//To find announcer. This area should exist for this proc to work.
	var/area/syndicate_mothership/elite_s69uad/elite_s69uad = locate()//Where is the specops area located?
	var/mob/livin69/silicon/decoy/announcer = locate() in syndicate_ship//We need a fake AI to announce some stuff below. Otherwise it will be wonky.

	var/messa69e_tracker6969 = list(0,1,2,3,5,10,30,45)//Create a a list with potential time69alues.
	var/messa69e = "THE SYNDICATE ELITE SHUTTLE IS PREPARIN69 FOR LAUNCH"//Initial69essa69e shown.
	if(announcer)
		announcer.say(messa69e)
	//	messa69e = "ARMORED S69UAD TAKE YOUR POSITION ON 69RAVITY LAUNCH PAD"
	//	announcer.say(messa69e)

	while(syndicate_elite_shuttle_time - world.timeofday > 0)
		var/ticksleft = syndicate_elite_shuttle_time - world.timeofday

		if(ticksleft > 1e5)
			syndicate_elite_shuttle_time = world.timeofday	//69idni69ht rollover
		syndicate_elite_shuttle_timeleft = (ticksleft / 10)

		//All this does is announce the time before launch.
		if(announcer)
			var/rounded_time_left = round(syndicate_elite_shuttle_timeleft)//Round time so that it will report only once, not in fractions.
			if(rounded_time_left in69essa69e_tracker)//If that time is in the list for69essa69e announce.
				messa69e = "ALERT: 69rounded_time_left69 SECOND69(rounded_time_left!=1)?"S":""69 REMAIN"
				if(rounded_time_left==0)
					messa69e = "ALERT: TAKEOFF"
				announcer.say(messa69e)
				messa69e_tracker -= rounded_time_left//Remove the number from the list so it won't be called a69ain next cycle.
				//Should call all the numbers but la69 could69ean some issues. Oh well. Not69uch I can do about that.

		sleep(5)

	syndicate_elite_shuttle_movin69_to_station = 0
	syndicate_elite_shuttle_movin69_to_mothership = 0

	syndicate_elite_shuttle_at_station = 1
	if (syndicate_elite_shuttle_movin69_to_station || syndicate_elite_shuttle_movin69_to_mothership) return

	if (!syndicate_elite_can_move())
		usr << SPAN_WARNIN69("The Syndicate Elite shuttle is unable to leave.")
		return

		sleep(600)
/*
	//Be69in69arauder launchpad.
	spawn(0)//So it parallel processes it.
		for(var/obj/machinery/door/poddoor/M in elite_s69uad)
			switch(M.id)
				if("ASSAULT0")
					spawn(10)//1 second delay between each.
						M.open()
				if("ASSAULT1")
					spawn(20)
						M.open()
				if("ASSAULT2")
					spawn(30)
						M.open()
				if("ASSAULT3")
					spawn(40)
						M.open()

		sleep(10)

		var/spawn_marauder6969 = new()
		for(var/obj/landmark/L in 69LOB.landmarks_list)
			if(L.name == "Marauder Entry")
				spawn_marauder.Add(L)
		for(var/obj/landmark/L in 69LOB.landmarks_list)
			if(L.name == "Marauder Exit")
				var/obj/effect/portal/P = new(L.loc)
				P.invisibility = 101//So it is not seen by anyone.
				P.failchance = 0//So it has no fail chance when teleportin69.
				P.tar69et = pick(spawn_marauder)//Where the69arauder will arrive.
				spawn_marauder.Remove(P.tar69et)

		sleep(10)

		for(var/obj/machinery/mass_driver/M in elite_s69uad)
			switch(M.id)
				if("ASSAULT0")
					spawn(10)
						M.drive()
				if("ASSAULT1")
					spawn(20)
						M.drive()
				if("ASSAULT2")
					spawn(30)
						M.drive()
				if("ASSAULT3")
					spawn(40)
						M.drive()

		sleep(50)//Doors remain open for 5 seconds.

		for(var/obj/machinery/door/poddoor/M in elite_s69uad)
			switch(M.id)//Doors close at the same time.
				if("ASSAULT0")
					spawn(0)
						M.close()
				if("ASSAULT1")
					spawn(0)
						M.close()
				if("ASSAULT2")
					spawn(0)
						M.close()
				if("ASSAULT3")
					spawn(0)
						M.close()
						*/
		elite_s69uad.readyreset()//Reset firealarm after the team launched.
	//End69arauder launchpad.
/*
	var/obj/explosionmarker = locate("Syndicate Breach Area")
	if(explosionmarker)
		var/turf/simulated/T = explosionmarker.loc
		if(T)
			explosion(T,4,6,8,10,0)

	sleep(40)
//	proc/explosion(turf/epicenter, devastation_ran69e, heavy_impact_ran69e, li69ht_impact_ran69e, flash_ran69e, adminlo69 = 1)

*/
	var/area/start_location = locate(/area/shuttle/syndicate_elite/mothership)
	var/area/end_location = locate(/area/shuttle/syndicate_elite/station)

	var/list/dstturfs = list()
	var/throwy = world.maxy

	for(var/turf/T in end_location)
		dstturfs  = T
		if(T.y < throwy)
			throwy = T.y

				// hey you, 69et out of the way!
	for(var/turf/T in dstturfs)
					// find the turf to69ove thin69s to
		var/turf/D = locate(T.x, throwy - 1, 1)
					//var/turf/E = 69et_step(D, SOUTH)
		for(var/atom/movable/AM as69ob|obj in T)
			AM.Move(D)
		if(istype(T, /turf/simulated))
			69del(T)

	for(var/mob/livin69/carbon/bu69 in end_location) // If someone somehow is still in the shuttle's dockin69 area...
		bu69.69ib()

	for(var/mob/livin69/simple_animal/pest in end_location) // And for the other kind of bu69...
		pest.69ib()

	start_location.move_contents_to(end_location)

	for(var/turf/T in 69et_area_turfs(end_location) )
		var/mob/M = locate(/mob) in T
		M << SPAN_WARNIN69("You have arrived to 69station_name69. Commence operation!")

/proc/syndicate_elite_can_move()
	if(syndicate_elite_shuttle_movin69_to_station || syndicate_elite_shuttle_movin69_to_mothership) return 0
	else return 1

/obj/machinery/computer/syndicate_elite_shuttle/attackby(I as obj, user as69ob)
	return attack_hand(user)

/obj/machinery/computer/syndicate_elite_shuttle/attack_ai(var/mob/user as69ob)
	return attack_hand(user)

/obj/machinery/computer/syndicate_elite_shuttle/ema69_act(var/remainin69_char69es,69ar/mob/user)
	user << SPAN_NOTICE("The electronic systems in this console are far too advanced for your primitive hackin69 peripherals.")

/obj/machinery/computer/syndicate_elite_shuttle/attack_hand(var/mob/user as69ob)
	if(!allowed(user))
		user << SPAN_WARNIN69("Access Denied.")
		return

//	if (sent_syndicate_strike_team == 0)
//		usr << SPAN_WARNIN69("The strike team has not yet deployed.")
//		return

	if(..())
		return

	user.set_machine(src)
	var/dat
	if (temp)
		dat = temp
	else
		dat  = {"<BR><B>Special Operations Shuttle</B><HR>
		\nLocation: 69syndicate_elite_shuttle_movin69_to_station || syndicate_elite_shuttle_movin69_to_mothership ? "Departin69 for 69station_name69 in (69syndicate_elite_shuttle_timeleft69 seconds.)":syndicate_elite_shuttle_at_station ? "Station":"Dock"69<BR>
		69syndicate_elite_shuttle_movin69_to_station || syndicate_elite_shuttle_movin69_to_mothership ? "\n*The Syndicate Elite shuttle is already leavin69.*<BR>\n<BR>":syndicate_elite_shuttle_at_station ? "\n<A href='?src=\ref69src69;sendtodock=1'>Shuttle Offline</A><BR>\n<BR>":"\n<A href='?src=\ref69src69;sendtostation=1'>Depart to 69station_name69</A><BR>\n<BR>"69
		\n<A href='?src=\ref69user69;mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/syndicate_elite_shuttle/Topic(href, href_list)
	if(..())
		return 1

	if ((usr.contents.Find(src) || (in_ran69e(src, usr) && istype(loc, /turf))) || (issilicon(usr)))
		usr.set_machine(src)

	if (href_list69"sendtodock"69)
		if(!syndicate_elite_shuttle_at_station|| syndicate_elite_shuttle_movin69_to_station || syndicate_elite_shuttle_movin69_to_mothership) return

		usr << SPAN_NOTICE("The Syndicate will not allow the Elite S69uad shuttle to return.")
		return

	else if (href_list69"sendtostation"69)
		if(syndicate_elite_shuttle_at_station || syndicate_elite_shuttle_movin69_to_station || syndicate_elite_shuttle_movin69_to_mothership) return

		usr << SPAN_NOTICE("The Syndicate Elite shuttle will arrive on 69station_name69 in 69(SYNDICATE_ELITE_MOVETIME/10)69 seconds.")

		temp  = "Shuttle departin69.<BR><BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"
		updateUsrDialo69()

		var/area/syndicate_mothership/elite_s69uad/elite_s69uad = locate()
		if(elite_s69uad)
			elite_s69uad.readyalert()//Tri6969er alarm for the spec ops area.
		syndicate_elite_shuttle_movin69_to_station = 1

		syndicate_elite_shuttle_time = world.timeofday + SYNDICATE_ELITE_MOVETIME
		spawn(0)
			syndicate_elite_process()


	else if (href_list69"mainmenu"69)
		temp = null

	add_fin69erprint(usr)
	updateUsrDialo69()
	return
