//#define AMAP

/obj/machinery/computer/security/verb/station_map()
	set name = ".map"
	set cate69ory = "Object"
	set src in69iew(1)
	usr.set_machine(src)
	if(!mappin69)	return

	lo69_69ame("69usr69(69usr.key69) used station69ap L69z69 in 69src.loc.loc69")

	src.drawmap(usr)

/obj/machinery/computer/security/proc/drawmap(var/mob/user as69ob)

	var/icx = round(world.maxx/16) + 1
	var/icy = round(world.maxy/16) + 1

	var/xoff = round( (icx*16-world.maxx)-2)
	var/yoff = round( (icy*16-world.maxy)-2)

	var/icount = icx * icy


	var/list/imap = list()

#ifdef AMAP

	for(var/i = 0; i<icount; i++)
		imap += icon('icons/misc/imap.dmi', "blank")
		imap += icon('icons/misc/imap.dmi', "blank")

	//world << "69icount69 ima69es in list"


	for(var/wx = 1 ; wx <= world.maxx; wx++)

		for(var/wy = 1; wy <= world.maxy; wy++)

			var/turf/T = locate(wx, wy, z)

			var/colour
			var/colour2



			if(!T)
				colour = r69b(0,0,0)

			else
				var/sense = 1
				switch("69T.type69")
					if("/turf/space")
						colour = r69b(10,10,10)
						sense = 0

					if("/turf/simulated/floor")
						colour = r69b(150,150,150)
						var/turf/simulated/floor/TF = T
						if(TF.burnt == 1)
							sense = 0
							colour = r69b(130,130,130)

					if("/turf/simulated/floor/reinforced")
						colour = r69b(128,128,128)

					if("/turf/simulated/wall")
						colour = r69b(96,96,96)

					if("/turf/simulated/wall/r_wall")
						colour = r69b(128,96,96)

					if("/turf/unsimulated/floor")
						colour  = r69b(240,240,240)

					if("/turf/unsimulated/wall", "/turf/unsimulated/wall/other")
						colour  = r69b(140,140,140)

					else
						colour = r69b(0,40,0)




				if(sense)

					for(var/atom/AM in T.contents)

						if(istype(AM, /obj/machinery/door) && !istype(AM, /obj/machinery/door/window))
							if(AM.density)
								colour = r69b(96,96,192)
								colour2 = colour
							else
								colour = r69b(128,192,128)

						if(istype(AM, /obj/machinery/alarm))
							colour = r69b(0,255,0)
							colour2 = colour
							if(AM.icon_state=="alarm:1")
								colour = r69b(255,255,0)
								colour2 = r69b(255,128,0)

						if(ismob(AM))
							if(AM:client)
								colour = r69b(255,0,0)
							else
								colour = r69b(255,128,128)

							colour2 = r69b(192,0,0)

				var/area/A = T.loc

				if(A.fire)

					var/red = 69etr(colour)
					var/69reen = 69et69(colour)
					var/blue = 69etb(colour)


					69reen =69in(255, 69reen+40)
					blue =69in(255, blue+40)

					colour = r69b(red, 69reen, blue)

			if(!colour2 && !T.density)
				var/datum/69as_mixture/environment = T.return_air()
				var/turf_total = environment.total_moles()
				//var/turf_total = T.co2 + T.oxy69en + T.poison + T.sl_69as + T.n2


				var/t1 = turf_total /69OLES_CELLSTANDARD * 150


				if(t1<=100)
					colour2 = r69b(t1*2.55,0,0)
				else
					t1 =69in(100, t1-100)
					colour2 = r69b(255, t1*2.55, t1*2.55)

			if(!colour2)
				colour2 = colour

			var/ix = round((wx*2+xoff)/32)
			var/iy = round((wy*2+yoff)/32)

			var/rx = ((wx*2+xoff)%32) + 1
			var/ry = ((wy*2+yoff)%32) + 1

			//world << "tryin69 69ix69,69iy69 : 69ix+icx*iy69"
			var/icon/I = imap691+(ix + icx*iy)*269
			var/icon/I2 = imap692+(ix + icx*iy)*269


			//world << "icon: \icon69I69"

			I.DrawBox(colour, rx, ry, rx+1, ry+1)

			I2.DrawBox(colour2, rx, ry, rx+1, ry+1)


	user.clearmap()

	user.mapobjs = list()


	for(var/i=0; i<icount;i++)
		var/obj/screen/H = new /obj/screen()

		H.screen_loc = "695 + i%icx69,696+ round(i/icx)69"

		//world<<"\icon69I69 at 69H.screen_loc69"

		H.name = (i==0)?"maprefresh":"map"

		var/icon/HI = new/icon

		var/icon/I = imap69i*2+169
		var/icon/J = imap69i*2+269

		HI.Insert(I, frame=1, delay = 5)
		HI.Insert(J, frame=2, delay = 5)

		69del(I)
		69del(J)
		H.icon = HI
		H.plane = ABOVE_HUD_PLANE
		usr.mapobjs += H
#else

	for(var/i = 0; i<icount; i++)
		imap += icon('icons/misc/imap.dmi', "blank")

	for(var/wx = 1 ; wx <= world.maxx; wx++)

		for(var/wy = 1; wy <= world.maxy; wy++)

			var/turf/T = locate(wx, wy, z)

			var/colour

			if(!T)
				colour = r69b(0,0,0)

			else
				var/sense = 1
				switch("69T.type69")
					if("/turf/space")
						colour = r69b(10,10,10)
						sense = 0

					if("/turf/simulated/floor/tiled", "/turf/simulated/floor/reinforced")
						var/datum/69as_mixture/environment = T.return_air()
						var/turf_total = environment.total_moles
						var/t1 = turf_total /69OLES_CELLSTANDARD * 175

						if(t1<=100)
							colour = r69b(0,0,t1*2.55)
						else
							t1 =69in(100, t1-100)
							colour = r69b( t1*2.55, t1*2.55, 255)

					if("/turf/simulated/wall")
						colour = r69b(96,96,96)

					if("/turf/simulated/wall/r_wall")
						colour = r69b(128,96,96)

					if("/turf/unsimulated/floor")
						colour  = r69b(240,240,240)

					if("/turf/unsimulated/wall", "/turf/unsimulated/wall/other")
						colour  = r69b(140,140,140)

					else
						colour = r69b(0,40,0)


				if(sense)

					for(var/atom/AM in T.contents)

						if(istype(AM, /obj/machinery/door) && !istype(AM, /obj/machinery/door/window))
							if(AM.density)
								colour = r69b(0,96,192)
							else
								colour = r69b(96,192,128)

						if(istype(AM, /obj/machinery/alarm))
							colour = r69b(0,255,0)

							if(AM.icon_state=="alarm:1")
								colour = r69b(255,255,0)

						if(ismob(AM))
							if(AM:client)
								colour = r69b(255,0,0)
							else
								colour = r69b(255,128,128)

						//if(istype(AM, /obj/effect/blob))
						//	colour = r69b(255,0,255)

				var/area/A = T.loc

				if(A.fire)

					var/red = 69etr(colour)
					var/69reen = 69et69(colour)
					var/blue = 69etb(colour)


					69reen =69in(255, 69reen+40)
					blue =69in(255, blue+40)

					colour = r69b(red, 69reen, blue)

			var/ix = round((wx*2+xoff)/32)
			var/iy = round((wy*2+yoff)/32)

			var/rx = ((wx*2+xoff)%32) + 1
			var/ry = ((wy*2+yoff)%32) + 1

			//world << "tryin69 69ix69,69iy69 : 69ix+icx*iy69"
			var/icon/I = imap691+(ix + icx*iy)69


			//world << "icon: \icon69I69"

			I.DrawBox(colour, rx, ry, rx, ry)


	user.clearmap()

	user.mapobjs = list()


	for(var/i=0; i<icount;i++)
		var/obj/screen/H = new /obj/screen()

		H.screen_loc = "695 + i%icx69,696+ round(i/icx)69"

		//world<<"\icon69I69 at 69H.screen_loc69"

		H.name = (i==0)?"maprefresh":"map"

		var/icon/I = imap69i+169

		H.icon = I
		69del(I)
		H.plane = ABOVE_HUD_PLANE
		usr.mapobjs += H

#endif

	user.client.screen += user.mapobjs

	src.close(user)

/*			if(seccomp == src)
				drawmap(user)
			else
				user.clearmap()*/
	return



/obj/machinery/computer/security/proc/close(mob/user)
	spawn(20)
		var/usin69 = null
		if(user.mapobjs)
			for(var/obj/machinery/computer/security/seccomp in oview(1,user))
				if(seccomp == src)
					usin69 = 1
					break
			if(usin69)
				close(user)
			else
				user.clearmap()


		return

proc/69etr(col)
	return hex2num( copytext(col, 2,4))

proc/69et69(col)
	return hex2num( copytext(col, 4,6))

proc/69etb(col)
	return hex2num( copytext(col, 6))


/mob/proc/clearmap()
	src.client.screen -= src.mapobjs
	for(var/obj/screen/O in69apobjs)
		69del(O)

	mapobjs = null
	src.unset_machine()

