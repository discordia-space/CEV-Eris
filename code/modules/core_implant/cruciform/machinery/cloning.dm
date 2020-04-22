#define CLONING_START 	2	//Percent of total progress
#define CLONING_BONES	35
#define CLONING_MEAT 	70
#define CLONING_BODY 	90
#define CLONING_DONE	100

#define ANIM_OPEN 1
#define ANIM_NONE 0
#define ANIM_CLOSE -1

/obj/machinery/neotheology/cloner
	name = "NeoTheology's clonepod"
	desc = "The newest design and God's gift from NeoTheology, this automatic machine will return the flesh to the spirit in no time."
	icon = 'icons/obj/neotheology_pod.dmi'
	icon_state = "preview"
	density = TRUE
	anchored = TRUE
	layer = 2.8
	circuit = /obj/item/weapon/circuitboard/neotheology/cloner

	frame_type = FRAME_VERTICAL

	var/obj/machinery/neotheology/reader/reader
	var/reader_loc

	var/obj/machinery/neotheology/biomass_container/container
	var/container_loc

	var/mob/living/carbon/human/occupant
	var/cloning = FALSE
	var/closed = FALSE

	var/progress = 0

	var/time_multiplier = 1	//Try to avoid use of non integer values

	var/biomass_consumption = 2

	var/image/anim0 = null
	var/image/anim1 = null

	var/power_cost = 250


/obj/machinery/neotheology/cloner/New()
	..()
	icon = 'icons/obj/neotheology_machinery.dmi'
	update_icon()

/obj/machinery/neotheology/cloner/Destroy()
	if(occupant)
		qdel(occupant)
	return ..()


/obj/machinery/neotheology/cloner/RefreshParts()
	var/mn_rating = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		mn_rating += M.rating
	time_multiplier = round((3 * initial(time_multiplier))/mn_rating)


/obj/machinery/neotheology/cloner/proc/get_progress(var/prg = progress)
	return round(prg / time_multiplier)


/obj/machinery/neotheology/cloner/proc/find_container()
	for(var/obj/machinery/neotheology/biomass_container/BC in orange(1,src))
		return BC
	return null


/obj/machinery/neotheology/cloner/proc/find_reader()
	for(var/obj/machinery/neotheology/reader/CR in orange(1,src))
		return CR
	return null


/obj/machinery/neotheology/cloner/proc/close_anim()
	qdel(anim0)
	anim0 = image(icon, "pod_closing0")
	anim0.layer = 5.01

	qdel(anim1)
	anim1 = image(icon, "pod_closing1")
	anim1.layer = 5.01
	anim1.pixel_z = 32

	update_icon()
	spawn(20)
		qdel(anim0)
		qdel(anim1)
		anim0 = null
		anim1 = null
		update_icon()

	return TRUE

/obj/machinery/neotheology/cloner/proc/open_anim()
	qdel(anim0)
	anim0 = image(icon, "pod_opening0")
	anim0.layer = 5.01

	qdel(anim1)
	anim1 = image(icon, "pod_opening1")
	anim1.layer = 5.01
	anim1.pixel_z = 32

	update_icon()
	spawn(20)
		qdel(anim0)
		qdel(anim1)
		anim0 = null
		anim1 = null
		update_icon()

	return TRUE


/obj/machinery/neotheology/cloner/proc/eject_contents()
	if(occupant)
		occupant.forceMove(loc)
		occupant = null
	else
		if(get_progress(progress) >= CLONING_MEAT)
			new /obj/item/weapon/reagent_containers/food/snacks/meat(loc)

	update_icon()

/obj/machinery/neotheology/cloner/proc/start()
	if(cloning)
		return

	reader = find_reader()
	if(!reader)
		return

	reader_loc = reader.loc

	container = find_container()
	if(!container)
		return

	reader.reading = TRUE
	reader.update_icon()

	container_loc = container.loc

	progress = 0

	cloning = TRUE

	occupant = null

	closed = TRUE

	close_anim()

	update_icon()
	return TRUE

/obj/machinery/neotheology/cloner/proc/stop()
	if(!cloning)
		return

	cloning = FALSE
	closed = FALSE
	if(reader)
		reader.reading = FALSE
		reader.update_icon()

	eject_contents()
	update_icon()
	return TRUE

/obj/machinery/neotheology/cloner/proc/done()
	occupant.setCloneLoss(0)
	occupant.setBrainLoss(0)
	occupant.updatehealth()
	stop()

///////////////

/obj/machinery/neotheology/cloner/Process()
	if(stat & NOPOWER)
		return

	if(cloning)
		if(!reader || reader.loc != reader_loc || !reader.implant || !container || container.loc != container_loc)
			open_anim()
			stop()
			update_icon()
			return

		progress++
		var/progress_percent = get_progress()

		if(progress <= CLONING_DONE)
			if(container)
				if(!container.reagents.remove_reagent("biomatter", biomass_consumption))
					stop()
			else
				stop()

		if(occupant && ishuman(occupant))
			occupant.setCloneLoss(CLONING_DONE-progress_percent)
			occupant.setBrainLoss(CLONING_DONE-progress_percent)

			occupant.adjustOxyLoss(-4)
			occupant.Paralyse(4)

			occupant.updatehealth()


		if(progress_percent >= CLONING_MEAT && !occupant)
			var/datum/core_module/cruciform/cloning/R = reader.implant.get_module(CRUCIFORM_CLONING)
			if(!R)
				open_anim()
				stop()
				update_icon()
				return

			occupant = new/mob/living/carbon/human(src)
			occupant.dna = R.dna.Clone()
			occupant.stats = R.mind.stats.Clone()
			occupant.set_species()
			occupant.real_name = R.dna.real_name
			occupant.age = R.age
			occupant.UpdateAppearance()
			occupant.sync_organ_dna()
			occupant.flavor_text = R.flavor

		if(progress == CLONING_BODY*time_multiplier)
			var/datum/effect/effect/system/spark_spread/s = new
			s.set_up(3, 1, src)
			s.start()

		if(progress == CLONING_DONE*time_multiplier)
			open_anim()
			closed = FALSE

		if(progress >= CLONING_DONE*time_multiplier + 2)
			done()

		update_icon()

	use_power(power_cost)


/obj/machinery/neotheology/cloner/attackby(obj/item/I, mob/user as mob)

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
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
		I = image(icon, "pod_under")
		I.layer = 5
		overlays.Add(I)

		I = image(icon, "pod_top_on")
		I.layer = 5.021
		I.pixel_z = 32
		overlays.Add(I)


	/////////BODY
	var/P = get_progress()
	if(cloning && P >= CLONING_START)
		var/icon/IC = icon(icon, "clone_bones")
		var/crop = 32-min(32,round(((P-CLONING_START)/(CLONING_BONES-CLONING_START))*32))
		IC.Crop(1,crop,IC.Width(),IC.Height())

		I = image(IC)
		I.layer = 5
		I.pixel_z = 11 + crop

		overlays.Add(I)

		if(P >= CLONING_BONES)
			I = image(icon, "clone_meat")
			I.alpha = min(255,round(((P-CLONING_BONES)/(CLONING_MEAT-CLONING_BONES))*255))
			I.layer = 5
			I.pixel_z = 11
			overlays.Add(I)

			if(P >= CLONING_MEAT && occupant)
				I = image(occupant.icon, occupant.icon_state)
				I.alpha = min(255,round(((P-CLONING_MEAT)/(CLONING_BODY-CLONING_MEAT))*255))
				I.overlays = occupant.overlays
				I.layer = 5
				I.pixel_z = 11
				overlays.Add(I)

	//////////////

	if(closed)
		if(!anim0 && !anim1)
			I = image(icon, "pod_glass0")
			I.layer = 5.01
			overlays.Add(I)

			I = image(icon, "pod_glass1")
			I.layer = 5.01
			I.pixel_z = 32
			overlays.Add(I)

			I = image(icon, "pod_liquid0")
			I.layer = 5.01
			overlays.Add(I)

			I = image(icon, "pod_liquid1")
			I.layer = 5.01
			I.pixel_z = 32
			overlays.Add(I)

	if(anim0 && anim1)
		overlays.Add(anim0)
		overlays.Add(anim1)

	I = image(icon, "pod_top0")

	if(!cloning)
		I.layer = layer
	else
		I.layer = 5.02

	overlays.Add(I)

	I = image(icon, "pod_top1")
	I.layer = 5.02
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

	var/biomass_capacity = 600


/obj/machinery/neotheology/biomass_container/New()
	..()
	create_reagents(biomass_capacity)
	if(SSticker.current_state != GAME_STATE_PLAYING)
		reagents.add_reagent("biomatter", 300)

/obj/machinery/neotheology/biomass_container/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		T += M.rating * 200
	biomass_capacity = T

/obj/machinery/neotheology/biomass_container/examine(mob/user)
	if(!..(user, 2))
		return

	if(!reagents.has_reagent("biomatter"))
		to_chat(user, SPAN_NOTICE("It is empty."))
	else
		to_chat(user, SPAN_NOTICE("Filled to [reagents.total_volume]/[biomass_capacity]."))

/obj/machinery/neotheology/biomass_container/attackby(obj/item/I, mob/user as mob)

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if (istype(I, /obj/item/stack/material/biomatter))
		var/obj/item/stack/material/biomatter/B = I
		if (B.biomatter_in_sheet && B.amount)
			var/sheets_amount_to_transphere = input(user, "How many sheets you want to load?", "Biomatter melting", 1) as num
			if(sheets_amount_to_transphere)
				var/total_transphere_from_stack = 0
				var/i = 1
				while(i <= sheets_amount_to_transphere)
					reagents.add_reagent("biomatter", B.biomatter_in_sheet)
					total_transphere_from_stack += B.biomatter_in_sheet
					i++
				B.use(sheets_amount_to_transphere)
				user.visible_message(
									"[user.name] inserted \the [B.name]'s sheets in \the [name].",
									"You inserted \the [B.name] in  (in amount: [sheets_amount_to_transphere]) \the [name].\
									And after that you see how the counter on \the [name] is incremented by [total_transphere_from_stack]."
									)
				ping()
			else
				to_chat(user, SPAN_WARNING("You can't insert [sheets_amount_to_transphere] in [name]"))
			return
		else
			to_chat(user, SPAN_WARNING("\The [B.name] is exhausted and can't be melted to biomatter. "))

	if(istype(I, /obj/item/weapon/reagent_containers) && I.is_open_container())
		var/obj/item/weapon/reagent_containers/container = I
		if(container.reagents.get_reagent_amount("biomatter") == container.reagents.total_volume)
			container.reagents.trans_to_holder(reagents, container.amount_per_transfer_from_this)
			to_chat(user, SPAN_NOTICE("You transfer some of biomatter from \the [container] to \the [name]."))
		else
			to_chat(user, SPAN_NOTICE("You need clear biomatter to fill \the [name]."))


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

	var/obj/item/weapon/implant/core_implant/cruciform/implant
	var/reading = FALSE


/obj/machinery/neotheology/reader/attackby(obj/item/I, mob/user as mob)

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(istype(I, /obj/item/weapon/implant/core_implant/cruciform))
		var/obj/item/weapon/implant/core_implant/cruciform/C = I
		user.drop_item()
		C.forceMove(src)
		implant = C

	src.add_fingerprint(user)
	update_icon()

/obj/machinery/neotheology/reader/attack_hand(mob/user as mob)
	if(!implant)
		return

	if(reading)
		to_chat(user, SPAN_WARNING("You try to pull the [implant], but it does not move."))
		return

	user.put_in_active_hand(implant)
	implant = null

	src.add_fingerprint(user)
	update_icon()

/obj/machinery/neotheology/reader/on_deconstruction()
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
		if(implant.get_module(CRUCIFORM_PRIEST))
			I = image(icon, "reader_c_red")
		overlays.Add(I)


/////////////////////

/obj/machinery/neotheology
	icon = 'icons/obj/neotheology_machinery.dmi'

#undef ANIM_OPEN
#undef ANIM_NONE
#undef ANIM_CLOSE
