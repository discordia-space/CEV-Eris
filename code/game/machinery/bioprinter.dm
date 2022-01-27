//These69achines are69ostly just here for debugging/spawning. Skeletons of the feature to come.

/obj/machinery/bioprinter
	name = "organ bioprinter"
	desc = "A69achine that grows replacement organs."
	icon = 'icons/obj/surgery.dmi'

	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 40

	icon_state = "bioprinter"

	var/prints_prosthetics
	var/stored_matter = 0
	var/max_matter = 300
	var/loaded_dna //Blood sample for DNA hashing.
	var/list/products = list(
		OP_HEART =   list(/obj/item/organ/internal/heart,  50),
		OP_LUNGS =   list(/obj/item/organ/internal/lungs,  40),
		OP_KIDNEYS = list(/obj/item/organ/internal/kidney, 20),
		OP_EYES =    list(/obj/item/organ/internal/eyes,   30),
		OP_LIVER =   list(/obj/item/organ/internal/liver,  50)
		)

/obj/machinery/bioprinter/prosthetics
	name = "prosthetics fabricator"
	desc = "A69achine that prints prosthetic organs."
	prints_prosthetics = 1

/obj/machinery/bioprinter/New()
	..()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		stored_matter = 200


/obj/machinery/bioprinter/attack_hand(mob/user)

	var/choice = input("What would you like to print?") as null|anything in products
	if(!choice)
		return

	if(stored_matter >= products69choice6969269)

		stored_matter -= products69choice6969269
		var/new_organ = products69choice6969169
		var/obj/item/organ/O = new new_organ(get_turf(src))

		if(prints_prosthetics)
			O.nature =69ODIFICATION_SILICON
		else if(loaded_dna)
			visible_message("<span class='notice'>The printer injects the stored DNA into the biomass.</span>.")
			O.transplant_data = list()
			var/mob/living/carbon/C = loaded_dna69"donor"69
			O.transplant_data69"species"69 =    C.species.name
			O.transplant_data69"blood_type"69 = loaded_dna69"blood_type"69
			O.transplant_data69"blood_DNA"69 =  loaded_dna69"blood_DNA"69

		visible_message("<span class='info'>The bioprinter spits out a new organ.</span>")

	else
		to_chat(user, SPAN_WARNING("There is not enough69atter in the printer."))

/obj/machinery/bioprinter/attackby(obj/item/W,69ob/user)

	// DNA sample from syringe.
	if(!prints_prosthetics && istype(W,/obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = W
		var/datum/reagent/organic/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && injected.data)
			loaded_dna = injected.data
			to_chat(user, "<span class='info'>You inject the blood sample into the bioprinter.</span>")
		return
	//69eat for biomass.
	if(!prints_prosthetics)
		for(var/type in BIOMASS_TYPES)
			if(istype(W,type))
				stored_matter += BIOMASS_TYPES69type69
				user.drop_item()
				to_chat(user, "<span class='info'>\The 69src69 processes \the 69W69. Levels of stored biomass now: 69stored_matter69</span>")
				69del(W)
				return
	// Steel for69atter.
	if(prints_prosthetics && istype(W, /obj/item/stack/material) && W.get_material_name() ==69ATERIAL_STEEL)
		var/obj/item/stack/S = W
		stored_matter += S.amount * 10
		user.drop_item()
		to_chat(user, "<span class='info'>\The 69src69 processes \the 69W69. Levels of stored69atter now: 69stored_matter69</span>")
		69del(W)
		return

	return ..()
