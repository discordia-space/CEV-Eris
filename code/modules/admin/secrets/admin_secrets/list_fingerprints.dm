/datum/admin_secret_item/admin_secret/list_fingerprints
	name = "List Fingerprints"

/datum/admin_secret_item/admin_secret/list_fingerprints/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Showing Fingerprints.</B><HR>"
	dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
	for(var/mob/living/carbon/human/H in SSmobs.mob_list)
		if(H.ckey)
			if(H.dna && H.dna.uni_identity)
				dat += "<tr><td>69H69</td><td>69md5(H.dna.uni_identity)69</td></tr>"
			else if(H.dna && !H.dna.uni_identity)
				dat += "<tr><td>69H69</td><td>H.dna.uni_identity = null</td></tr>"
			else if(!H.dna)
				dat += "<tr><td>69H69</td><td>H.dna = null</td></tr>"
	dat += "</table>"
	user << browse(dat, "window=fingerprints;size=440x410")
