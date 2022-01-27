/turf/simulated
	name = "station"
	var/wet = 0
	var/ima69e/wet_overlay =69ull

	//Minin69 resources (for the lar69e drills).
	var/has_resources
	var/list/resources
	var/seismic_activity = 1  // SEISMIC_MIN

	var/thermite = 0
	oxy69en =69OLES_O2STANDARD
	nitro69en =69OLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a69eltin69 temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The69ax temperature of the fire which it was subjected to



/turf/simulated/New()
	..()
	if(istype(loc, /area/eris/neotheolo69y))
		holy = 1
	levelupdate()



/turf/simulated/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey !=69ovement_disabled_exception)
		to_chat(usr, SPAN_DAN69ER("Movement is admin-disabled.") ) //This is to identify la69 problems
		return

	if (islivin69(A))
		var/mob/livin69/M = A
		if(M.lyin69)
			return ..()

		// U69ly hack :( Should69ever have69ultiple plants in the same tile.
		var/obj/effect/plant/plant = locate() in contents
		if(plant) plant.trodden_on(M)


		if(ishuman(M))


			var/mob/livin69/carbon/human/H =69

			//Footstep sounds. This proc is in footsteps.dm
			H.handle_footstep(src)

			// Trackin69 blood
			var/list/bloodDNA =69ull
			var/bloodcolor=""
			if(H.shoes)
				var/obj/item/clothin69/shoes/S = H.shoes
				if(istype(S))
					S.handle_movement(src,(MOVIN69_69UICKLY(H) ? 1 : 0))
					if(S.track_blood && S.blood_DNA)
						bloodDNA = S.blood_DNA
						bloodcolor=S.blood_color
						S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor = H.feet_blood_color
					H.track_blood--

			if (bloodDNA)
				src.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,H.dir,0,bloodcolor) // Comin69
				var/turf/simulated/from = 69et_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,0,H.dir,bloodcolor) // 69oin69

				bloodDNA =69ull

			var/obj/item/implant/core_implant/cruciform/C = H.69et_core_implant(/obj/item/implant/core_implant/cruciform)
			if(C && C.active)
				var/obj/item/cruciform_up69rade/up69rade = C.up69rade
				if(up69rade && up69rade.active && istype(up69rade, CUP69RADE_CLEANSIN69_PSESENCE))
					clean_ultimate(H)

		if(src.wet)

			if(M.buckled || (src.wet == 1 &&69OVIN69_DELIBERATELY(M)))
				return

			var/slip_dist = 1
			var/slip_stun = 6
			var/floor_type = "wet"

			switch(src.wet)
				if(2) // Lube
					floor_type = "slippery"
					slip_dist = 4
					slip_stun = 10
				if(3) // Ice
					floor_type = "icy"
					slip_stun = 4

			if(locate(/obj/structure/multiz/ladder) in 69et_turf(M.loc))  // Avoid slippin69 on ladder tiles
				visible_messa69e(SPAN_DAN69ER("\The 69M69 supports themself with the ladder to avoid slippin69."))
				return ..()
			if(locate(/obj/structure/multiz/stairs) in 69et_turf(M.loc))  // Avoid slippin69 on stairs tiles
				visible_messa69e(SPAN_DAN69ER("\The 69M69 supports themself with the handrail to avoid slippin69."))
				return ..()
			if(M.slip("the 69floor_type69 floor",slip_stun))
				for(var/i = 0;i<slip_dist;i++)
					step(M,69.dir)
					sleep(1)

	..()



/turf/simulated/proc/can_build_cable(var/mob/user)
	return 0

/turf/simulated/attackby(var/obj/item/thin69,69ar/mob/user)
	if(istype(thin69, /obj/item/stack/cable_coil) && can_build_cable(user))
		var/obj/item/stack/cable_coil/coil = thin69
		coil.turf_place(src, user)
		return
	return ..()
