/obj/item/weapon/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon death."
	var/mobname = "Will Robinson"
	origin_tech = list(TECH_BLUESPACE=1, TECH_MAGNET=2, TECH_DATA=4, TECH_BIO=3)

/obj/item/weapon/implant/death_alarm/get_data()
	var/data = {"
		<b>Implant Specifications:</b><BR>
		<b>Name:</b> [company_name] \"Profit Margin\" Class Employee Lifesign Sensor<BR>
		<b>Life:</b> Activates upon death.<BR>
		<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
		<HR>
		<b>Implant Details:</b><BR>
		<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
		<b>Special Features:</b> Alerts crew to crewmember death.<BR>
		<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	return data

/obj/item/weapon/implant/death_alarm/process()
	if (!implanted) return
	var/mob/M = imp_in

	if(isnull(M)) // If the mob got gibbed
		activate()
	else if(M.stat == 2)
		activate("death")

/obj/item/weapon/implant/death_alarm/activate(var/cause)
	var/mob/M = imp_in
	var/area/t = get_area(M)
	switch (cause)
		if("death")
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			if(istype(t, /area/syndicate_station) || istype(t, /area/syndicate_mothership) || istype(t, /area/shuttle/syndicate_elite) )
				//give the syndies a bit of stealth
				a.autosay("[mobname] has died in Space!", "[mobname]'s Death Alarm")
			else
				a.autosay("[mobname] has died in [t.name]!", "[mobname]'s Death Alarm")
			qdel(a)
			processing_objects.Remove(src)
		if ("emp")
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			var/name = prob(50) ? t.name : pick(teleportlocs)
			a.autosay("[mobname] has died in [name]!", "[mobname]'s Death Alarm")
			qdel(a)
		else
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			a.autosay("[mobname] has died-zzzzt in-in-in...", "[mobname]'s Death Alarm")
			qdel(a)
			processing_objects.Remove(src)

/obj/item/weapon/implant/death_alarm/emp_act(severity)			//for some reason alarms stop going off in case they are emp'd, even without this
	if (malfunction)		//so I'm just going to add a meltdown chance here
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp")	//let's shout that this dude is dead
	if(severity == 1)
		if(prob(40))	//small chance of obvious meltdown
			meltdown()
		else if (prob(60))	//but more likely it will just quietly die
			malfunction = MALFUNCTION_PERMANENT
		processing_objects.Remove(src)

	spawn(20)
		malfunction--

/obj/item/weapon/implant/death_alarm/install(mob/source as mob)
	..()
	mobname = source.real_name
	processing_objects.Add(src)


/obj/item/weapon/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	desc = "A case containing a death alarm implant."
	icon_state = "implantcase-b"
	implant_type = /obj/item/weapon/implant/death_alarm
