/obj/item/implant/health
	name = "health implant"
	var/healthstring = ""
	origin_tech = list(TECH_MATERIAL=3, TECH_BIO=4)

/obj/item/implant/health/proc/sensehealth()
	if(!implanted)
		return "ERROR"
	else
		if(isliving(implanted))
			var/mob/living/L = implanted
			healthstring = "69round(L.getOxyLoss())69 - 69round(L.getFireLoss())69 - 69round(L.getToxLoss())69 - 69round(L.getBruteLoss())69"
		if(!healthstring)
			healthstring = "ERROR"
		return healthstring


/obj/item/implantcase/health
	name = "glass case - 'health'"
	desc = "A case containing a health tracking implant."
	implant = /obj/item/implant/health