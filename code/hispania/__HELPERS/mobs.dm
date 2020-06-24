//hispania//
/proc/is_species(A, species_datum)
	. = FALSE
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(istype(H.species, species_datum))
			. = TRUE
//fin hispania//
