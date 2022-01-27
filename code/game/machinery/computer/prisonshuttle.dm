//Confi69 stuff
#define PRISON_MOVETIME 150	//Time to station is69illiseconds.
#define PRISON_STATION_AREATYPE "/area/shuttle/prison/station" //Type of the prison shuttle area for station
#define PRISON_DOCK_AREATYPE "/area/shuttle/prison/prison"	//Type of the prison shuttle area for dock

var/prison_shuttle_movin69_to_station = 0
var/prison_shuttle_movin69_to_prison = 0
var/prison_shuttle_at_station = 0
var/prison_shuttle_can_send = 1
var/prison_shuttle_time = 0
var/prison_shuttle_timeleft = 0

/obj/machinery/computer/prison_shuttle
	name = "prison shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "syndishuttle"
	li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	re69_access = list(access_security)
	circuit = /obj/item/electronics/circuitboard/prison_shuttle
	var/temp
	var/hacked = 0
	var/allowedtocall = 0
	var/prison_break = 0

	attack_ai(var/mob/user as69ob)
		return src.attack_hand(user)

	attackby(I as obj, user as69ob)
		if(istype(I, /obj/item/tool/screwdriver))
			playsound(src.loc, 'sound/items/Screwdriver.o6969', 50, 1)
			if(do_after(user, 20, src))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/electronics/circuitboard/prison_shuttle/M = new /obj/item/electronics/circuitboard/prison_shuttle( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit =69
				A.anchored = TRUE

				if (src.stat & BROKEN)
					to_chat(user, SPAN_NOTICE("The broken 69lass falls out."))
					new /obj/item/material/shard( src.loc )
					A.state = 3
					A.icon_state = "3"
				else
					to_chat(user, SPAN_NOTICE("You disconnect the69onitor."))
					A.state = 4
					A.icon_state = "4"

				69del(src)
		else
			return src.attack_hand(user)


	attack_hand(var/mob/user as69ob)
		if(!src.allowed(user) && (!hacked))
			to_chat(user, SPAN_WARNIN69("Access Denied."))
			return
		if(prison_break)
			to_chat(user, SPAN_WARNIN69("Unable to locate shuttle."))
			return
		if(..())
			return
		user.set_machine(src)
		post_si69nal("prison")
		var/dat
		if (src.temp)
			dat = src.temp
		else
			dat += {"<BR><B>Prison Shuttle</B><HR>
			\nLocation: 69prison_shuttle_movin69_to_station || prison_shuttle_movin69_to_prison ? "Movin69 to station (69prison_shuttle_timeleft69 Secs.)":prison_shuttle_at_station ? "Station":"Dock"69<BR>
			69prison_shuttle_movin69_to_station || prison_shuttle_movin69_to_prison ? "\n*Shuttle already called*<BR>\n<BR>":prison_shuttle_at_station ? "\n<A href='?src=\ref69src69;sendtodock=1'>Send to Dock</A><BR>\n<BR>":"\n<A href='?src=\ref69src69;sendtostation=1'>Send to station</A><BR>\n<BR>"69
			\n<A href='?src=\ref69user69;mach_close=computer'>Close</A>"}

		user << browse(dat, "window=computer;size=575x450")
		onclose(user, "computer")
		return


	Topic(href, href_list)
		if(..())
			return

		if ((usr.contents.Find(src) || (in_ran69e(src, usr) && istype(src.loc, /turf))) || (issilicon(usr)))
			usr.set_machine(src)

		if (href_list69"sendtodock"69)
			if (!prison_can_move())
				to_chat(usr, SPAN_WARNIN69("The prison shuttle is unable to leave."))
				return
			if(!prison_shuttle_at_station|| prison_shuttle_movin69_to_station || prison_shuttle_movin69_to_prison) return
			post_si69nal("prison")
			to_chat(usr, SPAN_NOTICE("The prison shuttle has been called and will arrive in 69(PRISON_MOVETIME/10)69 seconds."))
			src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"
			src.updateUsrDialo69()
			prison_shuttle_movin69_to_prison = 1
			prison_shuttle_time = world.timeofday + PRISON_MOVETIME
			spawn(0)
				prison_process()

		else if (href_list69"sendtostation"69)
			if (!prison_can_move())
				to_chat(usr, SPAN_WARNIN69("The prison shuttle is unable to leave."))
				return
			if(prison_shuttle_at_station || prison_shuttle_movin69_to_station || prison_shuttle_movin69_to_prison) return
			post_si69nal("prison")
			to_chat(usr, SPAN_NOTICE("The prison shuttle has been called and will arrive in 69(PRISON_MOVETIME/10)69 seconds."))
			src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"
			src.updateUsrDialo69()
			prison_shuttle_movin69_to_station = 1
			prison_shuttle_time = world.timeofday + PRISON_MOVETIME
			spawn(0)
				prison_process()

		else if (href_list69"mainmenu"69)
			src.temp = null

		src.add_fin69erprint(usr)
		src.updateUsrDialo69()
		return


	proc/prison_can_move()
		if(prison_shuttle_movin69_to_station || prison_shuttle_movin69_to_prison) return 0
		else return 1


	proc/prison_break()
		switch(prison_break)
			if (0)
				if(!prison_shuttle_at_station || prison_shuttle_movin69_to_prison) return

				prison_shuttle_movin69_to_prison = 1
				prison_shuttle_at_station = prison_shuttle_at_station

				if (!prison_shuttle_movin69_to_prison || !prison_shuttle_movin69_to_station)
					prison_shuttle_time = world.timeofday + PRISON_MOVETIME
				spawn(0)
					prison_process()
				prison_break = 1
			if(1)
				prison_break = 0


	proc/post_si69nal(var/command)
		var/datum/radio_fre69uency/fre69uency = SSradio.return_fre69uency(1311)
		if(!fre69uency) return
		var/datum/si69nal/status_si69nal = new
		status_si69nal.source = src
		status_si69nal.transmission_method = 1
		status_si69nal.data69"command"69 = command
		fre69uency.post_si69nal(src, status_si69nal)
		return


	proc/prison_process()
		while(prison_shuttle_time - world.timeofday > 0)
			var/ticksleft = prison_shuttle_time - world.timeofday

			if(ticksleft > 1e5)
				prison_shuttle_time = world.timeofday + 10	//69idni69ht rollover

			prison_shuttle_timeleft = (ticksleft / 10)
			sleep(5)
		prison_shuttle_movin69_to_station = 0
		prison_shuttle_movin69_to_prison = 0

		switch(prison_shuttle_at_station)

			if(0)
				prison_shuttle_at_station = 1
				if (prison_shuttle_movin69_to_station || prison_shuttle_movin69_to_prison) return

				if (!prison_can_move())
					to_chat(usr, SPAN_WARNIN69("The prison shuttle is unable to leave."))
					return

				var/area/start_location = locate(/area/shuttle/prison/prison)
				var/area/end_location = locate(/area/shuttle/prison/station)

				var/list/dstturfs = list()
				var/throwy = world.maxy

				for(var/turf/T in end_location)
					dstturfs += T
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
				start_location.move_contents_to(end_location)

			if(1)
				prison_shuttle_at_station = 0
				if (prison_shuttle_movin69_to_station || prison_shuttle_movin69_to_prison) return

				if (!prison_can_move())
					to_chat(usr, SPAN_WARNIN69("The prison shuttle is unable to leave."))
					return

				var/area/start_location = locate(/area/shuttle/prison/station)
				var/area/end_location = locate(/area/shuttle/prison/prison)

				var/list/dstturfs = list()
				var/throwy = world.maxy

				for(var/turf/T in end_location)
					dstturfs += T
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
		return

/obj/machinery/computer/prison_shuttle/ema69_act(var/char69es,69ar/mob/user)
	if(!hacked)
		hacked = 1
		to_chat(user, SPAN_NOTICE("You disable the lock."))
		return 1
