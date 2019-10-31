/obj/item/device/dna_scanner
	name = "dna analyzer"
	desc = "A hand-held scanner able to distinguish mutations in DNA of the subject injected with kognim."
	icon_state = "dna"
	item_state = "analyzer"
	throw_speed = 5
	throw_range = 10
	var/use_delay = 170
	var/charge_per_use = 0
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small
	var/list/scanned_mutations = list()
	var/scan_sound = 'sound/machines/twobeep.ogg'
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 2)

obj/item/device/dna_scanner/proc/can_use(mob/user)
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(!cell_use_check(charge_per_use))
		to_chat(user, SPAN_WARNING("[src] battery is dead or missing."))
		return
	return TRUE

/obj/item/device/dna_scanner/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(!can_use(user))
		return

	if(istype(A, /obj/item/modular_computer))
		to_chat(user, "Transfering scanned mutations to \the [A].")
		var/obj/item/modular_computer/MC = A
		if(!MC.enabled)
			to_chat(user, "You cannot transfer any results to \the turned off [A].")
		else
			transfer_scanned_mutations(MC)
	else
		if(is_valid_scan_target(A) && A.simulated)
			user.visible_message(SPAN_NOTICE("[user] runs \the [src] over \the [A]."), range = 2)
			if(scan_sound)
				playsound(src, scan_sound, 30)
			if(use_delay && !do_after(user, use_delay, A))
				to_chat(user, "You stop scanning \the [A] with \the [src].")
				return
			scan(A, user)
		else
			to_chat(user, "You cannot get any results from \the [A] with \the [src].")

/obj/item/device/dna_scanner/proc/cell_use_check(charge)
	. = TRUE
	if(!cell || !cell.checked_use(charge))
		to_chat(usr, SPAN_WARNING("[src] battery is dead or missing."))
		. = FALSE

/obj/item/device/dna_scanner/Initialize()
	. = ..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

/obj/item/device/dna_scanner/get_cell()
	return cell

/obj/item/device/dna_scanner/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/item/device/dna_scanner/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/dna_scanner/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C

/obj/item/device/dna_scanner/proc/is_valid_scan_target(atom/O)
	return ishuman(O) || issuperioranimal(O)

/obj/item/device/dna_scanner/proc/scan(atom/A, mob/user)
	scanned_mutations.Add(get_mutations(A, user, src))
	scanned_mutations = removeNullsFromList(scanned_mutations)
	to_chat(user, "You successfully scanned \the [A].")

/obj/item/device/dna_scanner/proc/get_mutations(atom/target, mob/living/user, obj/scanner)
	if(issuperioranimal(target))
		var/mob/living/carbon/superior_animal/roach/R = target
		if(R.mutations)
			return R.mutations
		else
			to_chat(user, "You failed to get any results from \the [target] with \the [scanner].")
	else
		var/mob/living/carbon/human/H = target
		if(H.reagents.has_reagent("kognim"))
			return H.dna.mutations
		else
			to_chat(user, "You failed to get any results from \the [target] with \the [scanner].")

/obj/item/device/dna_scanner/proc/transfer_scanned_mutations(obj/item/modular_computer/MC)
	for(var/mutation in scanned_mutations)
		var/datum/computer_file/binary/dna_sample/dna_sample = new()
		dna_sample.set_dna_sample(mutation)
		if(MC.hard_drive.try_store_file(dna_sample))
			MC.hard_drive.store_file(dna_sample)