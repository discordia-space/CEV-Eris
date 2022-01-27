//microscope code itself
/obj/machinery/microscope
	name = "high powered electron69icroscope"
	desc = "A highly advanced69icroscope capable of zooming up to 3000x."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "microscope"
	anchored = TRUE
	density = TRUE

	var/obj/item/sample = null
	var/report_num = 0

/obj/machinery/microscope/attackby(obj/item/W as obj,69ob/user as69ob)

	if(sample)
		to_chat(user, SPAN_WARNING("There is already a slide in the69icroscope."))
		return

	if(istype(W, /obj/item/forensics/swab)|| istype(W, /obj/item/sample/fibers) || istype(W, /obj/item/sample/print))
		to_chat(user, SPAN_NOTICE("You insert \the 69W69 into the69icroscope."))
		user.unEquip(W)
		W.forceMove(src)
		sample = W
		update_icon()
		return

/obj/machinery/microscope/attack_hand(mob/user)

	if(!sample)
		to_chat(user, SPAN_WARNING("The69icroscope has no sample to examine."))
		return

	to_chat(user, SPAN_NOTICE("The69icroscope whirrs as you examine \the 69sample69."))

	if(!do_after(user, 25, src) || !sample)
		to_chat(user, SPAN_NOTICE("You stop examining \the 69sample69."))
		return

	to_chat(user, SPAN_NOTICE("Printing findings now..."))
	var/obj/item/paper/report = new(get_turf(src))
	report.stamped = list(/obj/item/stamp)
	report.overlays = list("paper_stamped")
	report_num++

	if(istype(sample, /obj/item/forensics/swab))
		var/obj/item/forensics/swab/swab = sample

		report.name = "GSR report #69++report_num69: 69swab.name69"
		report.info = "<b>Scanned item:</b><br>69swab.name69<br><br>"

		if(swab.gsr)
			report.info += "Residue from a 69swab.gsr69 bullet detected."
		else
			report.info += "No gunpowder residue found."

	else if(istype(sample, /obj/item/sample/fibers))
		var/obj/item/sample/fibers/fibers = sample
		report.name = "Fiber report #69++report_num69: 69fibers.name69"
		report.info = "<b>Scanned item:</b><br>69fibers.name69<br><br>"
		if(fibers.evidence)
			report.info = "Molecular analysis on provided sample has determined the presence of unique fiber strings.<br><br>"
			for(var/fiber in fibers.evidence)
				report.info += "<span class='notice'>Most likely69atch for fibers: 69fiber69</span><br><br>"
		else
			report.info += "No fibers found."
	else if(istype(sample, /obj/item/sample/print))
		report.name = "Fingerprint report #69report_num69: 69sample.name69"
		report.info = "<b>Fingerprint analysis report #69report_num69</b>: 69sample.name69<br>"
		var/obj/item/sample/print/card = sample
		if(card.evidence && card.evidence.len)
			report.info += "Surface analysis has determined unique fingerprint strings:<br><br>"
			for(var/prints in card.evidence)
				report.info += SPAN_NOTICE("Fingerprint string: ")
				if(!is_complete_print(prints))
					report.info += "INCOMPLETE PRINT"
				else
					report.info += "69prints69"
				report.info += "<br>"
		else
			report.info += "No information available."

	if(report)
		report.update_icon()
		if(report.info)
			to_chat(user, report.info)
	return

/obj/machinery/microscope/proc/remove_sample(var/mob/living/remover)
	if(!istype(remover) || remover.incapacitated() || !Adjacent(remover))
		return
	if(!sample)
		to_chat(remover, SPAN_WARNING("\The 69src69 does not have a sample in it."))
		return
	to_chat(remover, SPAN_NOTICE("You remove \the 69sample69 from \the 69src69."))
	sample.forceMove(get_turf(src))
	remover.put_in_hands(sample)
	sample = null
	update_icon()

/obj/machinery/microscope/AltClick()
	remove_sample(usr)

/obj/machinery/microscope/MouseDrop(var/atom/other)
	if(usr == other)
		remove_sample(usr)
	else
		return ..()

/obj/machinery/microscope/update_icon()
	icon_state = "microscope"
	if(sample)
		icon_state += "slide"
