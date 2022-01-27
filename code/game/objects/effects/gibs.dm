/proc/gibs(atom/location,69ar/datum/dna/MobDNA, gibber_type = /obj/effect/gibspawner/generic,69ar/fleshcolor,69ar/bloodcolor)
	new gibber_type(location,MobDNA,fleshcolor,bloodcolor)

/obj/effect/gibspawner
	var/sparks = 0 //whether sparks spread on Gib()
	var/virusProb = 20 //the chance for69iruses to spread on the gibs
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.

	New(location,69ar/datum/dna/MobDNA,69ar/fleshcolor,69ar/bloodcolor)
		..()

		if(fleshcolor) src.fleshcolor = fleshcolor
		if(bloodcolor) src.bloodcolor = bloodcolor
		Gib(loc,MobDNA)

	proc/Gib(atom/location,69ar/datum/dna/MobDNA = null)
		if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
			to_chat(world, SPAN_WARNING("Gib list length69ismatch!"))
			return

		if(sparks)
			var/datum/effect/effect/system/spark_spread/s = new
			s.set_up(2, 1, get_turf(location)) // Not sure if it's safe to pass an arbitrary object to set_up, todo
			s.start()

		var/obj/effect/decal/cleanable/blood/gibs/gib
		for(var/i = 1, i<= gibtypes.len, i++)
			if(gibamounts69i69)
				for(var/j = 1, j<= gibamounts69i69, j++)
					var/gibType = gibtypes69i69
					gib = new gibType(location)

					// Apply human species colouration to69asks.
					if(fleshcolor)
						gib.fleshcolor = fleshcolor
					if(bloodcolor)
						gib.basecolor = bloodcolor

					gib.update_icon()

					gib.blood_DNA = list()
					if(MobDNA)
						gib.blood_DNA69MobDNA.uni69ue_enzymes69 =69obDNA.b_type
					else if(istype(src, /obj/effect/gibspawner/human)) // Probably a69onkey
						gib.blood_DNA69"Non-human DNA"69 = "A+"
					if(istype(location,/turf/))
						var/list/directions = gibdirections69i69
						if(directions.len)
							gib.streak(directions)

		69del(src)
