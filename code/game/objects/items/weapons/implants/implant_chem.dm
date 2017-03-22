/obj/item/weapon/implant/chem
	name = "chemical implant"
	desc = "Injects things."
	allow_reagents = 1
	origin_tech = list(TECH_MATERIAL=3, TECH_BIO=4)

/obj/item/weapon/implant/chem/get_data()
	var/data = {"
		<b>Implant Specifications:</b><BR>
		<b>Name:</b> Robust Corp MJ-420 Prisoner Management Implant<BR>
		<b>Life:</b> Deactivates upon death but remains within the body.<BR>
		<b>Important Notes: Due to the system functioning off of nutrients in the implanted subject's body, the subject<BR>
		will suffer from an increased appetite.</B><BR>
		<HR>
		<b>Implant Details:</b><BR>
		<b>Function:</b> Contains a small capsule that can contain various chemicals. Upon receiving a specially encoded signal<BR>
		the implant releases the chemicals directly into the blood stream.<BR>
		<b>Special Features:</b>
		<i>Micro-Capsule</i>- Can be loaded with any sort of chemical agent via the common syringe and can hold 50 units.<BR>
		Can only be loaded while still in its original case.<BR>
		<b>Integrity:</b> Implant will last so long as the subject is alive. However, if the subject suffers from malnutrition,<BR>
		the implant may become unstable and either pre-maturely inject the subject or simply break."}
	return data


/obj/item/weapon/implant/chem/New()
	..()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src


/obj/item/weapon/implant/chem/trigger(emote, source as mob)
	if(emote == "deathgasp")
		src.activate(src.reagents.total_volume)
	return


/obj/item/weapon/implant/chem/activate(var/cause)
	if((!cause) || (!src.imp_in))	return 0
	var/mob/living/carbon/R = src.imp_in
	src.reagents.trans_to_mob(R, cause, CHEM_BLOOD)
	R << "You hear a faint *beep*."
	if(!src.reagents.total_volume)
		R << "You hear a faint click from your chest."
		spawn(0)
			qdel(src)
	return

/obj/item/weapon/implant/chem/emp_act(severity)
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	switch(severity)
		if(1)
			if(prob(60))
				activate(20)
		if(2)
			if(prob(30))
				activate(5)

	spawn(20)
		malfunction--


/obj/item/weapon/implantcase/chem
	name = "glass case - 'chem'"
	desc = "A case containing a chemical implant."
	icon_state = "implantcase-b"
	implant_type = /obj/item/weapon/implant/chem
