/obj/item/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which69onitors host69ital signs and transmits a radio69essage upon death."
	icon_state = "implant_deathalarm"
	implant_overlay = "implantstorage_deathalarm"
	var/mobname = "Will Robinson"
	origin_tech = list(TECH_BLUESPACE=1, TECH_MAGNET=2, TECH_DATA=4, TECH_BIO=3)

/obj/item/implant/death_alarm/get_data()
	var/data = {"
		<b>Implant Specifications:</b><BR>
		<b>Name:</b> 69company_name69 \"Profit69argin\" Class Employee Lifesign Sensor<BR>
		<b>Life:</b> Activates upon death.<BR>
		<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
		<HR>
		<b>Implant Details:</b><BR>
		<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
		<b>Special Features:</b> Alerts crew to crewmember death.<BR>
		<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally69alfunction."}
	return data

/obj/item/implant/death_alarm/Process()
	if (!implanted)
		return
	var/mob/M = wearer

	if(isnull(M)) // If the69ob got gibbed
		activate()
	else if(M.stat == DEAD)
		activate("death")

/obj/item/implant/death_alarm/activate(var/cause)
	var/mob/M = wearer
	var/area/t = get_area(M)
	switch (cause)
		if("death")
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			a.autosay("69mobname69 has died in 69t.name69!", "69mobname69's Death Alarm")
			69del(a)
			STOP_PROCESSING(SSobj, src)
		if ("emp")
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			var/name = prob(50) ? t.name : pick(SSmapping.teleportlocs)
			a.autosay("69mobname69 has died in 69name69!", "69mobname69's Death Alarm")
			69del(a)
		else
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			a.autosay("69mobname69 has died-zzzzt in-in-in...", "69mobname69's Death Alarm")
			69del(a)
			STOP_PROCESSING(SSobj, src)

/obj/item/implant/death_alarm/malfunction(severity)			//for some reason alarms stop going off in case they are emp'd, even without this
	if (malfunction)		//so I'm just going to add a69eltdown chance here
		return
	malfunction =69ALFUNCTION_TEMPORARY

	activate("emp")	//let's shout that this dude is dead
	if(severity == 1)
		if(prob(40))	//small chance of obvious69eltdown
			meltdown()
		else if (prob(60))	//but69ore likely it will just 69uietly die
			malfunction =69ALFUNCTION_PERMANENT
		STOP_PROCESSING(SSobj, src)

	spawn(20)
		malfunction--

/obj/item/implant/death_alarm/on_install(mob/living/source)
	mobname = source.real_name
	START_PROCESSING(SSobj, src)


/obj/item/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	desc = "A case containing a death alarm implant."
	implant = /obj/item/implant/death_alarm

/obj/item/implanter/death_alarm
	name = "implanter (death alarm)"
	implant = /obj/item/implant/death_alarm
	spawn_tags = null
