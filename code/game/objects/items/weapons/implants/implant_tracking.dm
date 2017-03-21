/obj/item/weapon/implant/tracking
	name = "tracking implant"
	desc = "Track with this."
	var/id = 1.0
	origin_tech = list(TECH_MATERIAL=2, TECH_MAGNET=2, TECH_DATA=2, TECH_BIO=2)

/obj/item/weapon/implant/tracking/get_data()
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
		Implant Specifics:<BR>"}
	return data

/obj/item/weapon/implant/tracking/emp_act(severity)
	if (malfunction)	//no, dawg, you can't malfunction while you are malfunctioning
		return
	malfunction = MALFUNCTION_TEMPORARY

	var/delay = 20
	switch(severity)
		if(1)
			if(prob(60))
				meltdown()
		if(2)
			delay = rand(5*60*10,15*60*10)	//from 5 to 15 minutes of free time

	spawn(delay)
		malfunction--


/obj/item/weapon/implantcase/tracking
	name = "glass case - 'tracking'"
	desc = "A case containing a tracking implant."
	icon_state = "implantcase-b"
	implant_type = /obj/item/weapon/implant/tracking
