/obj/item/weapon/implant/health
	name = "health implant"
	var/healthstring = ""
	origin_tech = list(TECH_MATERIAL=3, TECH_BIO=4)

/obj/item/weapon/implant/health/proc/sensehealth()
	if(!implanted)
		return "ERROR"
	else
		if(isliving(implanted))
			var/mob/living/L = implanted
			healthstring = "[round(L.getOxyLoss())] - [round(L.getFireLoss())] - [round(L.getToxLoss())] - [round(L.getBruteLoss())]"
		if(!healthstring)
			healthstring = "ERROR"
		return healthstring


/obj/item/weapon/implantcase/health
	name = "glass case - 'health'"
	desc = "A case containing a health tracking implant."
	implant = /obj/item/weapon/implant/health