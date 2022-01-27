//Common breathing procs

//Start of a breath chain, calls breathe()
/mob/living/carbon/handle_breathing()
	if(life_tick%get_breath_modulo()==0 || failed_last_breath) 	//First, resolve location and get a breath
		breathe()

/mob/living/carbon/proc/get_breath_modulo()
	return 2

/mob/living/carbon/proc/breathe()
	//if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return
	if(species && (species.flags &69O_BREATHE)) return

	var/datum/gas_mixture/breath =69ull

	if(losebreath>0) //Suffocating so do69ot take a breath
		losebreath--
		if (prob(10)) //Gasp per 10 ticks? Sounds about right.
			spawn emote("gasp")
	else
		//Okay, we can breathe,69ow check if we can get air
		breath = get_breath_from_internal() //First, check for air from internals
		if(!breath)
			breath = get_breath_from_environment() //No breath from internals so let's try to get air from our location

	handle_breath(breath)
	handle_post_breath(breath)

/mob/living/carbon/proc/get_breath_from_internal(var/volume_needed=BREATH_VOLUME) //hopefully this will allow overrides to specify a different default69olume without breaking any cases where69olume is passed in.
	if(internal)
		if (!contents.Find(internal))
			internal =69ull
		if (!(wear_mask && (wear_mask.item_flags & AIRTIGHT)))
			internal =69ull
		if(HUDneed.Find("internal"))
			var/obj/screen/HUDelm = HUDneed69"internal"69
			HUDelm.update_icon()
		if(internal)
			return internal.remove_air_volume(volume_needed)
	return69ull

/mob/living/carbon/proc/get_breath_from_environment(volume_needed=BREATH_VOLUME)
	var/datum/gas_mixture/breath =69ull

	var/datum/gas_mixture/environment
	if(loc)
		environment = loc.return_air_for_internal_lifeform()

	if(environment)
		breath = environment.remove_volume(volume_needed)
		handle_chemical_smoke(environment) //handle chemical smoke while we're at it

	if(breath && breath.total_moles)
		//handle69ask filtering
		if(istype(wear_mask, /obj/item/clothing/mask) && breath)
			var/obj/item/clothing/mask/M = wear_mask
			var/datum/gas_mixture/filtered =69.filter_air(breath)
			loc.assume_air(filtered)
		return breath
	return69ull

//Handle possble chem smoke effect
/mob/living/carbon/proc/handle_chemical_smoke(datum/gas_mixture/environment)
	if(species && environment.return_pressure() < species.breath_pressure/5)
		return //pressure is too low to even breathe in.
	if(wear_mask && (wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT))
		return

	for(var/obj/effect/effect/smoke/chem/smoke in69iew(1, src))
		if(!smoke.reagents)
			return
		if(smoke.reagents.total_volume)
			smoke.reagents.trans_to_mob(src, 5, CHEM_INGEST, copy = 1)
			smoke.reagents.trans_to_mob(src, 5, CHEM_BLOOD, copy = 1)
			// I dunno,69aybe the reagents enter the blood stream through the lungs?
			break // If they breathe in the69asty stuff once,69o69eed to continue checking

/mob/living/carbon/proc/handle_breath(datum/gas_mixture/breath)
	return

/mob/living/carbon/proc/handle_post_breath(datum/gas_mixture/breath)
	if(breath)
		loc.assume_air(breath) //by default, exhale
