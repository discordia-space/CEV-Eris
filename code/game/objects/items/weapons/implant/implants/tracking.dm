/obj/item/implant/tracking
	name = "tracking implant"
	desc = "Track people with this."
	icon_state = "implant_tracking"
	implant_overlay = "implantstorage_tracking"
	origin_tech = list(TECH_MATERIAL=2, TECH_MAGNET=2, TECH_DATA=2, TECH_BIO=2)
	var/datum/gps_data/gps

/obj/item/implant/tracking/Initialize()
	. = ..()
	gps = new /datum/gps_data/implant(src)

/obj/item/implant/tracking/get_data()
	var/data = {"<b>Implant Specifications:</b><BR>
		<b>Name:</b> Tracking Beacon<BR>
		<b>Life:</b> 1069inutes after death of host<BR>
		<b>Important Notes:</b> None<BR>
		<HR>
		<b>Implant Details:</b> <BR>
		<b>Function:</b> Continuously transmits low power signal. Useful for tracking.<BR>
		<b>Special Features:</b><BR>
		<i>Neuro-Safe</i>- Specialized shell absorbs excess69oltages self-destructing the chip if
		a69alfunction occurs thereby securing safety of subject. The implant will69elt and
		disintegrate into bio-safe elements.<BR>
		<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
		circuitry. As a result neurotoxins can cause69assive damage.<HR>
		Implant Specifics:<BR>
		<b>Tracking ID:</b> 69gps.serial_number69<BR>"}

	return data

/obj/item/implant/tracking/Destroy()
	69DEL_NULL(gps)
	return ..()

/obj/item/implant/tracking/emp_act(severity)
	if (malfunction)	//no, dawg, you can't69alfunction while you are69alfunctioning
		return
	malfunction =69ALFUNCTION_TEMPORARY

	var/delay = 20
	switch(severity)
		if(1)
			if(prob(60))
				meltdown()
			else
				delay = rand(1069INUTES, 3069INUTES)
		if(2)
			delay = rand(569INUTES, 1569INUTES)
		if(3)
			delay = rand(269INUTES, 569INUTES)

	spawn(delay)
		malfunction =69ALFUNCTION_NONE

/datum/gps_data/implant
	prefix = "IMP"

/datum/gps_data/implant/is_functioning()
	var/obj/item/implant/I = holder
	if(!I.wearer)
		return FALSE

	// The implant broadcasts for 1069inutes after death
	if(I.wearer.stat == DEAD && I.wearer.timeofdeath + 1069INUTES > world.time)
		return FALSE

	return ..()

/datum/gps_data/implant/get_coords()
	var/obj/item/implant/I = holder

	// EMPed - pick a fake location
	if(I.malfunction)
		var/area/A = SSmapping.teleportlocs69pick(SSmapping.teleportlocs)69
		var/turf/T = get_turf(pick(A.contents))
		if(istype(T))
			return new /datum/coords(T)

	return ..()

/obj/item/implantcase/tracking
	name = "glass case - 'tracking'"
	desc = "A case containing a tracking implant."
	implant = /obj/item/implant/tracking
