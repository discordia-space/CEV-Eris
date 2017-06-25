#define CLONING_IDLE 	0		//no cloning
#define CLONING_NONE 	1
#define CLONING_BONES 	2		//bones
#define CLONING_MEAT 	3		//bones and meat
#define CLONING_BODY 	4		//dependent body, will eject dead body
#define CLONING_HUMAN 	5		//autonomous body
#define CLONING_DONE 	6

/obj/machinery/neotheology/cloner
	name = "NeoTheology's clonpod"
	desc = "The newest design and God's gift from NeoTheology, this automatic machine will return the flesh to the spirit in no time."
	icon = 'icons/obj/neotheology_pod.dmi'
	icon_state = "preview"
	density = TRUE
	anchored = TRUE
	layer = 2.8
	circuit = /obj/item/weapon/circuitboard/neotheology/cloner

	frame_type = FRAME_VERTICAL

	var/mob/living/carbon/human/occupant
	var/cloning_stage = CLONING_IDLE
	var/stage_timer = 0
	var/cloning = FALSE

	var/closed = FALSE
	var/power_cost = 250

	var/biomass_error = 0
	var/data_error = 0

	var/list/stage_time = list(0,40,40,25,15,0)
	var/time_divisor = 1

	var/list/stage_biomass = list(10,40,50,40,10,0)

	var/list/stage_cloneloss = list(120,120,100,90,70,0)

	var/list/stage_brainloss = list(40,40,40,20,10,0)


/obj/machinery/neotheology/cloner/New()
	..()
	icon = 'icons/obj/neotheology_machinery.dmi'
	update_icon()

/obj/machinery/neotheology/cloner/Destroy()
	if(occupant)
		qdel(occupant)
	return ..()

/obj/machinery/neotheology/cloner/RefreshParts()
	var/T = 1
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T = (T + M.rating)/2
	time_divisor = T

/obj/machinery/neotheology/cloner/proc/is_done()
	return cloning_stage >= CLONING_DONE

/obj/machinery/neotheology/cloner/proc/require_biomass(var/count, var/notenough = TRUE)
	var/obj/machinery/neotheology/biomass_container/can = find_biomass_container()
	if(!can)
		if(count <= 0)	//If you need 0 or less biomass, you doesnt need the biocan
			return TRUE
		else
			if(notenough)
				not_enough_biomass()
			return FALSE

	if(can.biomass < count)
		if(notenough)
			not_enough_biomass()
		return FALSE
	else
		can.biomass -= count

	return TRUE


/obj/machinery/neotheology/cloner/proc/find_biomass_container()
	for(var/obj/machinery/neotheology/biomass_container/BC in orange(1,src))
		return BC
	return null


/obj/machinery/neotheology/cloner/proc/find_cruciform_reader()
	for(var/obj/machinery/neotheology/reader/CR in orange(1,src))
		return CR
	return null

/obj/machinery/neotheology/cloner/proc/read_data()
	var/obj/machinery/neotheology/reader/reader = find_cruciform_reader()
	if(!reader)
		return null

	if(!reader.implant)
		return null

	reader.start_reading()

	spawn(50)
		if(reader)
			reader.stop_reading()

	return reader.implant.data

/obj/machinery/neotheology/cloner/proc/set_stage_timer(var/seconds)
	stage_timer = (world.time + seconds*10)/time_divisor

/obj/machinery/neotheology/cloner/proc/get_next_stage()
	return max(min(cloning_stage+1, CLONING_DONE), CLONING_IDLE)

/obj/machinery/neotheology/cloner/proc/get_previous_stage()
	return max(min(cloning_stage-1, CLONING_DONE), CLONING_IDLE)

/obj/machinery/neotheology/cloner/proc/close()
	if(closed)
		return

	closed = TRUE
	update_icon()

/obj/machinery/neotheology/cloner/proc/open(var/forced = FALSE)	//if not forced, pod will not open, if cloning not done
	if(!closed)
		return

	if(forced || is_done())
		closed = FALSE
		eject_contents()

	update_icon()

/obj/machinery/neotheology/cloner/proc/eject_contents()
	if(!occupant || closed)
		return

	if(cloning_stage >= CLONING_BODY)
		if(cloning_stage < CLONING_HUMAN)
			occupant.death()	//Clone on "body" stage cannot live without cloner
		occupant.forceMove(loc)
		occupant = null
	else
		if(cloning_stage == CLONING_MEAT)
			for(var/i=1 to 2)
				var/obj/item/weapon/reagent_containers/food/snacks/meat/meat = new
				meat.forceMove(loc)
		qdel(occupant)

	update_icon()

/obj/machinery/neotheology/cloner/proc/start()
	if(cloning)
		return

	biomass_error = 0
	data_error = 0

	cloning_stage = CLONING_IDLE
	cloning = TRUE

	visible_message("<span class='notice'>Cloning started.</span>")
	update_icon()

/obj/machinery/neotheology/cloner/proc/stop(var/forced = FALSE, var/open = TRUE)
	if(!cloning)
		return

	if(forced || is_done())
		cloning = FALSE
		if(open)
			open(forced)
		if(is_done())
			visible_message("<span class='notice'>Cloning done!</span>")
		else
			visible_message("<span class='notice'>Cloning stopped!</span>")
		cloning_stage = CLONING_IDLE
	update_icon()

/obj/machinery/neotheology/cloner/proc/mutate()
	if(occupant && prob(20))
		randmuti(occupant)
		if(prob(10))
			randmutb(occupant)
		if(prob(1))
			randmutg(occupant)
		occupant.dna.UpdateSE()
		occupant.dna.UpdateUI()
		occupant.UpdateAppearance()

/obj/machinery/neotheology/cloner/proc/damage_external()
	if(occupant && prob(40))
		for(var/tag in occupant.organs_by_name)
			var/obj/item/organ/O = occupant.organs_by_name[tag]
			if(prob(40))
				O.take_damage(6+rand(4))

/obj/machinery/neotheology/cloner/proc/damage_internal()
	if(occupant && prob(30))
		for(var/tag in occupant.internal_organs_by_name)
			var/obj/item/organ/O = occupant.internal_organs_by_name[tag]
			if(prob(40))
				O.take_damage(5+rand(3))

//Cloning errors
/obj/machinery/neotheology/cloner/proc/not_enough_biomass()
	if(biomass_error < 1)
		visible_message("<span class='warning'>Not enough biomass!</span>")
	if(biomass_error > 3)
		if(occupant)
			if(cloning_stage <= CLONING_BODY)
				damage_internal()
			else
				damage_external()
	if(biomass_error > 20 || cloning_stage <= CLONING_BONES)
		stop(TRUE)
	biomass_error += 1

/obj/machinery/neotheology/cloner/proc/data_not_found()
	if(data_error < 1)
		visible_message("<span class='warning'>Implant read error!</span>")
	if(data_error > 3)
		if(occupant && cloning_stage <= CLONING_BODY)
			mutate()
	if(data_error > 20  || cloning_stage <= CLONING_BONES)
		stop(TRUE)
	data_error += 1

/obj/machinery/neotheology/cloner/proc/unexpected_error()	//For specific errors
	visible_message("<span class='warning'>Unexpected error!</span>")
	stop(TRUE)

///////////////

/obj/machinery/neotheology/cloner/process()
	if(stat & NOPOWER)
		if(cloning)
			stop(TRUE)
			visible_message("<span class='warning'>Power lost!</span>")
			update_icon()
			return

	if(cloning)
		if(occupant && istype(occupant, /mob/living/carbon/human))
			occupant.setCloneLoss(stage_cloneloss[cloning_stage])
			occupant.setBrainLoss(stage_brainloss[cloning_stage])

			occupant.adjustOxyLoss(-4)
			occupant.Paralyse(4)

			occupant.updatehealth()

		if(world.time >= stage_timer)

			var/datum/coreimplant_record/R = read_data()

			var/has_bio = require_biomass(stage_biomass[get_next_stage()])

			if(!R)
				data_not_found()
			else
				if(data_error)
					data_error = 0

			if(!has_bio)
				not_enough_biomass()
			else
				if(biomass_error)
					biomass_error = 0


			if(cloning)
				if(!biomass_error && !data_error)
					if(!is_done())
						cloning_stage = get_next_stage()
						if(cloning_stage < CLONING_DONE)
							visible_message("<span class='notice'>Processing cloning stage [cloning_stage]/5.</span>")
						set_stage_timer(stage_time[cloning_stage])


					if(cloning_stage == CLONING_NONE)
						close()

					if(cloning_stage == CLONING_BONES)
						occupant = new/mob/living/carbon/human(src)
						occupant.dna = R.dna.Clone()
						occupant.set_species()
						occupant.real_name = R.dna.real_name
						occupant.age = R.age
						occupant.UpdateAppearance()
						occupant.sync_organ_dna()

					if(cloning_stage == CLONING_MEAT)
						var/datum/effect/effect/system/spark_spread/s = new
						s.set_up(3, 1, src)
						s.start()

					if(cloning_stage == CLONING_BODY)
						if(!occupant)
							unexpected_error()

					if(cloning_stage == CLONING_HUMAN)
						if(occupant)
							occupant.flavor_text = R.flavor
						else
							unexpected_error()

					if(cloning_stage >= CLONING_DONE)
						stage_timer = 0
						occupant.setCloneLoss(0)
						occupant.setBrainLoss(0)
						occupant.updatehealth()
						stop()

		update_icon()
		use_power(power_cost)


/obj/machinery/neotheology/cloner/relaymove()
	if(!closed)
		eject_contents()

/obj/machinery/neotheology/cloner/attackby(obj/item/O as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

/obj/machinery/neotheology/cloner/update_icon()
	icon_state = "pod_base0"
	overlays.Cut()

	if(panel_open)
		var/image/P = image(icon, "pod_panel")
		overlays.Add(P)

	var/image/I = image(icon, "pod_base1")
	I.layer = 5
	I.pixel_z = 32
	overlays.Add(I)

	if(closed)
		I = image(icon, "pod_under0")
		I.layer = 5
		overlays.Add(I)

		I = image(icon, "pod_under1")
		I.layer = 5
		I.pixel_z = 32
		overlays.Add(I)

	/////////BODY
	if(cloning_stage == CLONING_BONES || cloning_stage == CLONING_MEAT)
		var/icon/IC = icon(icon, "clone_bones")
		if(cloning_stage == CLONING_BONES)
			var/crop = round((max(stage_timer-world.time,0)/((stage_time[cloning_stage]*10)/time_divisor))*32)
			IC.Crop(1,crop,IC.Width(),IC.Height())
		I = image(IC)
		I.layer = 5
		I.pixel_z = 11

		overlays.Add(I)
	if(cloning_stage == CLONING_MEAT || cloning_stage == CLONING_BODY)
		I = image(icon, "clone_meat")
		if(cloning_stage == CLONING_MEAT)
			I.alpha = 255-round((max(stage_timer-world.time,0)/((stage_time[cloning_stage]*10)/time_divisor))*255)
		I.layer = 5
		I.pixel_z = 11
		overlays.Add(I)
	if(cloning_stage >= CLONING_BODY)
		if(occupant)
			I = image(occupant.icon, occupant.icon_state)
			if(cloning_stage == CLONING_BODY)
				I.alpha = 255-round((max(stage_timer-world.time,0)/((stage_time[cloning_stage]*10)/time_divisor))*255)
			I.overlays = occupant.overlays
			I.layer = 5
			I.pixel_z = 11
			overlays.Add(I)
	//////////////

	if(closed)
		I = image(icon, "pod_glass0")
		I.layer = 5
		overlays.Add(I)

		I = image(icon, "pod_glass1")
		I.layer = 5
		I.pixel_z = 32
		overlays.Add(I)

	I = image(icon, "pod_top0")
	I.layer = layer
	overlays.Add(I)

	I = image(icon, "pod_top1")
	I.layer = 5
	I.pixel_z = 32
	overlays.Add(I)


/////////////////////

/////////////////////
//BIOMASS CONTAINER
/////////////////////

/obj/machinery/neotheology/biomass_container
	name = "NeoTheology's biomass container"
	desc = "Making strange noises barrel, filled with a substance which at any time may become someone else's body."
	icon_state = "biocan"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/neotheology/biocan

	var/biomass = 0
	var/biomass_max = 900


/obj/machinery/neotheology/biomass_container/New()
	..()
	if(!(ticker && ticker.current_state == GAME_STATE_PLAYING))
		biomass = 600

/obj/machinery/neotheology/biomass_container/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		T += M.rating * 300
	biomass_max = T

/obj/machinery/neotheology/biomass_container/examine(mob/user)
	if(!..(user, 2))
		return

	if(biomass == 0)
		user << "<span class='notice'>It is empty.</span>"
	else
		user << "<span class='notice'>Filled by [biomass]/[biomass_max].</span>"

/obj/machinery/neotheology/biomass_container/attackby(obj/item/O as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/meat))
		if(biomass >= biomass_max)
			user << "<span class='notice'>\The [src] is full.</span>"
			return
		user << "<span class='notice'>You put [O] in [src].</span>"
		biomass += 50
		user.drop_item()
		qdel(O)

	src.add_fingerprint(user)

/obj/machinery/neotheology/biomass_container/update_icon()
	overlays.Cut()

	if(panel_open)
		var/image/P = image(icon, "biocan_panel")
		P.dir = dir
		overlays.Add(P)

/////////////////////

/////////////////////
//CRUCIFORM IMPLANT READER
/////////////////////

/obj/machinery/neotheology/reader
	name = "NeoTheology's cruciform reader"
	desc = "The altar for scanning genetic information from medium of soul - the cruciform."
	icon_state = "reader_off"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/neotheology/reader

	var/obj/item/weapon/implant/external/core_implant/cruciform/implant
	var/reading = FALSE

/obj/machinery/neotheology/reader/proc/start_reading()
	if(!implant)
		return

	reading = TRUE
	update_icon()

/obj/machinery/neotheology/reader/proc/stop_reading()
	reading = FALSE
	update_icon()

/obj/machinery/neotheology/reader/attackby(obj/item/O as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(istype(O, /obj/item/weapon/implant/external/core_implant/cruciform))
		var/obj/item/weapon/implant/external/core_implant/cruciform/C = O
		user.drop_item()
		C.forceMove(src)
		implant = C

	src.add_fingerprint(user)
	update_icon()

/obj/machinery/neotheology/reader/attack_hand(mob/user as mob)
	if(!implant)
		return

	if(reading)
		user << "<span class='notice'>You try to pull the [implant], but it does not move.</span>"
		return

	user.put_in_active_hand(implant)
	implant = null

	src.add_fingerprint(user)
	update_icon()

/obj/machinery/neotheology/reader/dismantle()
	if(implant)
		implant.forceMove(loc)
		implant = null
	return ..()

/obj/machinery/neotheology/reader/update_icon()
	overlays.Cut()

	if(panel_open)
		var/image/P = image(icon, "reader_panel")
		overlays.Add(P)


	icon_state = "reader_off"

	if(reading)
		icon_state = "reader_on"

	if(implant)
		var/image/I = image(icon, "reader_c_green")
		if(istype(implant, /obj/item/weapon/implant/external/core_implant/cruciform/priest))
			I = image(icon, "reader_c_red")
		overlays.Add(I)


/////////////////////

/obj/machinery/neotheology
	icon = 'icons/obj/neotheology_machinery.dmi'
