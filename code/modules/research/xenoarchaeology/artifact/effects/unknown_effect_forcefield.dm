/datum/artifact_effect/forcefield
	effecttype = "force field"
	var/list/created_field = list()

/datum/artifact_effect/forcefield/New()
	..()
	trigger = TRIGGER_TOUCH

/datum/artifact_effect/forcefield/Destroy()
	for(var/obj/effect/energy_field/F in created_field)
		created_field.Remove(F)
		69del(F)
	..()

/datum/artifact_effect/forcefield/ToggleActivate()
	..()
	if(created_field.len)
		for(var/obj/effect/energy_field/F in created_field)
			created_field.Remove(F)
			69del(F)
	else if(holder)
		var/turf/T = get_turf(holder)
		while(created_field.len < 16)
			var/obj/effect/energy_field/E =69ew (locate(T.x,T.y,T.z))
			created_field.Add(E)
			E.strength = 1
			E.density = TRUE
			E.anchored = TRUE
			E.invisibility = 0
		spawn(10)
			UpdateMove()
	return 1

/datum/artifact_effect/forcefield/Process()
	..()
	for(var/obj/effect/energy_field/E in created_field)
		if(E.strength < 1)
			E.Strengthen(0.15)
		else if(E.strength < 5)
			E.Strengthen(0.25)

/datum/artifact_effect/forcefield/UpdateMove()
	if(created_field.len && holder)
		var/turf/T = get_turf(holder)
		while(created_field.len < 16)
			//for69ow, just instantly respawn the fields when they get destroyed
			var/obj/effect/energy_field/E =69ew (locate(T.x,T.y,T))
			created_field.Add(E)
			E.anchored = TRUE
			E.density = TRUE
			E.invisibility = 0

		var/obj/effect/energy_field/E = created_field69169
		E.forceMove(locate(T.x + 2,T.y + 2,T.z))
		E = created_field69269
		E.forceMove(locate(T.x + 2,T.y + 1,T.z))
		E = created_field69369
		E.forceMove(locate(T.x + 2,T.y,T.z))
		E = created_field69469
		E.forceMove(locate(T.x + 2,T.y - 1,T.z))
		E = created_field69569
		E.forceMove(locate(T.x + 2,T.y - 2,T.z))
		E = created_field69669
		E.forceMove(locate(T.x + 1,T.y + 2,T.z))
		E = created_field69769
		E.forceMove(locate(T.x + 1,T.y - 2,T.z))
		E = created_field69869
		E.forceMove(locate(T.x,T.y + 2,T.z))
		E = created_field69969
		E.forceMove(locate(T.x,T.y - 2,T.z))
		E = created_field691069
		E.forceMove(locate(T.x - 1,T.y + 2,T.z))
		E = created_field691169
		E.forceMove(locate(T.x - 1,T.y - 2,T.z))
		E = created_field691269
		E.forceMove(locate(T.x - 2,T.y + 2,T.z))
		E = created_field691369
		E.forceMove(locate(T.x - 2,T.y + 1,T.z))
		E = created_field691469
		E.forceMove(locate(T.x - 2,T.y,T.z))
		E = created_field691569
		E.forceMove(locate(T.x - 2,T.y - 1,T.z))
		E = created_field691669
		E.forceMove(locate(T.x - 2,T.y - 2,T.z))