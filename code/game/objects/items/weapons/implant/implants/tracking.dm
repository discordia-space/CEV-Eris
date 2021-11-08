/obj/item/implant/tracking
	name = "tracking implant"
	desc = "Track people with this."
	origin_tech = list(TECH_MATERIAL=2, TECH_MAGNET=2, TECH_DATA=2, TECH_BIO=2)
	///reference for later use
	var/datum/component/gps/gps

/obj/item/implant/tracking/Initialize()
	. = ..()
	gps = AddComponent(/datum/component/gps, "IMP")
	gps.tracking = FALSE // OFF by default
	START_PROCESSING(SSobj, src)

/obj/item/implant/tracking/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/implant/tracking/get_data()
	var/data = {"<b>Implant Specifications:</b><BR>
		<b>Name:</b> Tracking Beacon<BR>
		<b>Life:</b> 10 minutes after death of host<BR>
		<b>Important Notes:</b> None<BR>
		<HR>
		<b>Implant Details:</b> <BR>
		<b>Function:</b> Continuously transmits low power signal. Useful for tracking.<BR>
		<b>Special Features:</b><BR>
		<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if
		a malfunction occurs thereby securing safety of subject. The implant will melt and
		disintegrate into bio-safe elements.<BR>
		<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
		circuitry. As a result neurotoxins can cause massive damage.<HR>
		Implant Specifics:<BR>
		<b>Tracking ID:</b> [gps.gpstag]-[gps.serial_number]<BR>"}

	return data

/obj/item/implant/tracking/Process()
	if(wearer.stat == DEAD && wearer.timeofdeath + 10 MINUTES < world.time)
		gps.tracking = TRUE // they ded
		return
	gps.tracking = FALSE // they got defib or revived by something. Implant should still work

/obj/item/implant/tracking/emp_act(severity)
	if (malfunction)	//no, dawg, you can't malfunction while you are malfunctioning
		return
	malfunction = MALFUNCTION_TEMPORARY

	var/delay = 20
	switch(severity)
		if(1)
			if(prob(60))
				meltdown()
			else
				delay = rand(10 MINUTES, 30 MINUTES)
		if(2)
			delay = rand(5 MINUTES, 15 MINUTES)
		if(3)
			delay = rand(2 MINUTES, 5 MINUTES)
	gps.emped = TRUE

	addtimer(VARSET_CALLBACK(src, malfunction, MALFUNCTION_NONE), delay)
	addtimer(VARSET_CALLBACK(gps, emped, FALSE), delay)

/obj/item/implantcase/tracking
	name = "glass case - 'tracking'"
	desc = "A case containing a tracking implant."
	implant = /obj/item/implant/tracking
